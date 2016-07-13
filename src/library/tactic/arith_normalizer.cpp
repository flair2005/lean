/*
Copyright (c) 2016 Daniel Selsam. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Daniel Selsam
*/
#include <functional>
#include "util/optional.h"
#include "util/timeit.h"
#include "util/interrupt.h"
#include "util/sexpr/option_declarations.h"
#include "kernel/abstract.h"
#include "kernel/expr_maps.h"
#include "kernel/expr_sets.h"
#include "kernel/instantiate.h"
#include "library/trace.h"
#include "library/constants.h"
#include "library/expr_lt.h"
#include "library/num.h"
#include "library/util.h"
#include "library/norm_num.h"
#include "library/defeq_canonizer.h"
#include "library/app_builder.h"
#include "library/fun_info.h"
#include "library/sorry.h"
#include "library/mpq_macro.h"
#include "library/kernel_serializer.h"
#include "library/vm/vm_expr.h"
#include "library/tactic/tactic_state.h"
#include "library/tactic/arith_normalizer.h"

#ifndef LEAN_DEFAULT_ARITH_NORMALIZER_DISTRIBUTE_MUL
#define LEAN_DEFAULT_ARITH_NORMALIZER_DISTRIBUTE_MUL false
#endif
#ifndef LEAN_DEFAULT_ARITH_NORMALIZER_FUSE_MUL
#define LEAN_DEFAULT_ARITH_NORMALIZER_FUSE_MUL false
#endif
#ifndef LEAN_DEFAULT_ARITH_NORMALIZER_NORMALIZE_DIV
#define LEAN_DEFAULT_ARITH_NORMALIZER_NORMALIZE_DIV false
#endif
#ifndef LEAN_DEFAULT_ARITH_NORMALIZER_ORIENT_POLYS
#define LEAN_DEFAULT_ARITH_NORMALIZER_ORIENT_POLYS false
#endif
#ifndef LEAN_DEFAULT_ARITH_NORMALIZER_PROFILE
#define LEAN_DEFAULT_ARITH_NORMALIZER_PROFILE false
#endif

namespace lean {

// Options
static name * g_arith_normalizer_distribute_mul = nullptr;
static name * g_arith_normalizer_fuse_mul       = nullptr;
static name * g_arith_normalizer_normalize_div  = nullptr;
static name * g_arith_normalizer_orient_polys   = nullptr;
static name * g_arith_normalizer_profile = nullptr;

static bool get_arith_normalizer_distribute_mul(options const & o) {
    return o.get_bool(*g_arith_normalizer_distribute_mul, LEAN_DEFAULT_ARITH_NORMALIZER_DISTRIBUTE_MUL);
}

static bool get_arith_normalizer_fuse_mul(options const & o) {
    return o.get_bool(*g_arith_normalizer_fuse_mul, LEAN_DEFAULT_ARITH_NORMALIZER_FUSE_MUL);
}

static bool get_arith_normalizer_normalize_div(options const & o) {
    return o.get_bool(*g_arith_normalizer_normalize_div, LEAN_DEFAULT_ARITH_NORMALIZER_NORMALIZE_DIV);
}

static bool get_arith_normalizer_orient_polys(options const & o) {
    return o.get_bool(*g_arith_normalizer_orient_polys, LEAN_DEFAULT_ARITH_NORMALIZER_ORIENT_POLYS);
}

static bool get_arith_normalizer_profile(options const & o) {
    return o.get_bool(*g_arith_normalizer_profile, LEAN_DEFAULT_ARITH_NORMALIZER_PROFILE);
}

struct arith_normalize_options {
    bool m_distribute_mul, m_fuse_mul, m_normalize_div, m_orient_polys, m_profile;
    arith_normalize_options(options const & o):
        m_distribute_mul(get_arith_normalizer_distribute_mul(o)),
        m_fuse_mul(get_arith_normalizer_fuse_mul(o)),
        m_normalize_div(get_arith_normalizer_normalize_div(o)),
        m_orient_polys(get_arith_normalizer_orient_polys(o)),
        m_profile(get_arith_normalizer_profile(o))
        {}

    bool distribute_mul() const { return m_distribute_mul; }
    bool fuse_mul() const { return m_fuse_mul; }
    bool normalize_div() const { return m_normalize_div; }
    bool orient_polys() const { return m_orient_polys; }
    bool profile() const { return m_profile; }
};


// Helpers

static expr mk_nary_app(expr const & fn, buffer<expr> const & args) {
    lean_assert(!args.empty());
    expr e = args.back();
    for (int i = args.size() - 2; i >= 0; --i) {
        e = mk_app(fn, args[i], e);
    }
    return e;
}

static expr get_power_product(expr const & monomial) {
    expr lhs, rhs;
    if (is_mul(monomial, lhs, rhs) && is_mpq_macro(lhs)) {
        return rhs;
    } else {
        return monomial;
    }
}

static expr get_power_product(expr const & monomial, mpq & num) {
    expr lhs, rhs;
    if (is_mul(monomial, lhs, rhs) && is_mpq_macro(lhs, num)) {
        return rhs;
    } else {
        num = 1;
        return monomial;
    }
}

static expr app_arg2(expr const & e) {
    return app_arg(app_fn(e));
}

// Fast arith_normalizer

enum class head_type {
    EQ, LE, GE,
    // TODO(dhs): LT, GT
        ADD, MUL,
        SUB, DIV,
        NEG,
        DIV0,
        ZERO, ONE, BIT0, BIT1,
        INT_OF_NAT, RAT_OF_INT, REAL_OF_RAT,
        OTHER
        };

enum rel_kind { EQ, LE, GE };

enum class norm_status { DONE, FAILED };

// Partial application cache
// The current plan is to use flets to track the current type being normalized
struct partial_apps {
    type_context m_tctx;

    expr m_type;
    level m_level;

    optional<bool> m_is_field;

    expr m_zero, m_one;
    expr m_bit0, m_bit1;
    expr m_add, m_mul, m_div, m_sub, m_neg;
    expr m_eq, m_le, m_ge;

    expr m_div0;

    partial_apps(type_context & tctx, expr const & type): m_tctx(tctx), m_type(type) {
        m_level = get_level(m_tctx, type);
    }

    bool init(expr const & e) { return e != expr(); }

    bool is_field() {
        if (m_is_field) {
            return *m_is_field;
        } else {
            expr inst_type = mk_app(mk_constant(get_field_name(), {m_level}), m_type);
            if (auto inst = m_tctx.mk_class_instance(inst_type)) {
                m_is_field = optional<bool>(true);
                return true;
            } else {
                m_is_field = optional<bool>(false);
                return false;
            }
        }
    }

    // TODO(dhs): PERF synthesize the first time, and then cache
    expr get_type() const { return m_type; }

    expr get_zero() {
        if (init(m_zero)) {
            return m_zero;
        } else {
            expr inst_type = mk_app(mk_constant(get_has_zero_name(), {m_level}), m_type);
            if (auto inst = m_tctx.mk_class_instance(inst_type)) {
                m_zero = mk_app(mk_constant(get_zero_name(), {m_level}), m_type, *inst);
                return m_zero;
            } else {
                throw exception(sstream() << "cannot synthesize [has_zero " << m_type << "]\n");
            }
        }
    }

    expr get_one() {
        if (init(m_one)) {
            return m_one;
        } else {
            expr inst_type = mk_app(mk_constant(get_has_one_name(), {m_level}), m_type);
            if (auto inst = m_tctx.mk_class_instance(inst_type)) {
                m_one = mk_app(mk_constant(get_one_name(), {m_level}), m_type, *inst);
                return m_one;
            } else {
                throw exception(sstream() << "cannot synthesize [has_one " << m_type << "]\n");
            }
        }
    }

    expr get_bit0() {
        if (init(m_bit0)) {
            return m_bit0;
        } else {
            expr inst_type = mk_app(mk_constant(get_has_add_name(), {m_level}), m_type);
            if (auto inst = m_tctx.mk_class_instance(inst_type)) {
                m_bit0 = mk_app(mk_constant(get_bit0_name(), {m_level}), m_type, *inst);
                return m_bit0;
            } else {
                throw exception(sstream() << "cannot synthesize [has_add " << m_type << "]\n");
            }
        }
    }

    expr get_bit1() {
        if (init(m_bit1)) {
            return m_bit1;
        } else {
            expr inst_type1 = mk_app(mk_constant(get_has_one_name(), {m_level}), m_type);
            if (auto inst1 = m_tctx.mk_class_instance(inst_type1)) {
                expr inst_type2 = mk_app(mk_constant(get_has_add_name(), {m_level}), m_type);
                if (auto inst2 = m_tctx.mk_class_instance(inst_type2)) {
                    m_bit1 = mk_app(mk_constant(get_bit1_name(), {m_level}), m_type, *inst1, *inst2);
                    return m_bit1;
                } else {
                    throw exception(sstream() << "cannot synthesize [has_add " << m_type << "]\n");
                }
            } else {
                throw exception(sstream() << "cannot synthesize [has_one " << m_type << "]\n");
            }
        }
    }

    expr get_add() {
        if (init(m_add)) {
            return m_add;
        } else {
            expr inst_type = mk_app(mk_constant(get_has_add_name(), {m_level}), m_type);
            if (auto inst = m_tctx.mk_class_instance(inst_type)) {
                m_add = mk_app(mk_constant(get_add_name(), {m_level}), m_type, *inst);
                return m_add;
            } else {
                throw exception(sstream() << "cannot synthesize [has_add " << m_type << "]\n");
            }
        }
    }

    expr get_mul() {
        if (init(m_mul)) {
            return m_mul;
        } else {
            expr inst_type = mk_app(mk_constant(get_has_mul_name(), {m_level}), m_type);
            if (auto inst = m_tctx.mk_class_instance(inst_type)) {
                m_mul = mk_app(mk_constant(get_mul_name(), {m_level}), m_type, *inst);
                return m_mul;
            } else {
                throw exception(sstream() << "cannot synthesize [has_mul " << m_type << "]\n");
            }
        }
    }

    expr get_sub() {
        expr inst_type = mk_app(mk_constant(get_has_sub_name(), {m_level}), m_type);
        if (auto inst = m_tctx.mk_class_instance(inst_type)) {
            return mk_app(mk_constant(get_sub_name(), {m_level}), m_type, *inst);
        } else {
            throw exception(sstream() << "cannot synthesize [has_sub " << m_type << "]\n");
        }
    }

    expr get_div() {
        expr inst_type = mk_app(mk_constant(get_has_div_name(), {m_level}), m_type);
        if (auto inst = m_tctx.mk_class_instance(inst_type)) {
            return mk_app(mk_constant(get_div_name(), {m_level}), m_type, *inst);
        } else {
            throw exception(sstream() << "cannot synthesize [has_div " << m_type << "]\n");
        }
    }

    expr get_div0() {
        expr inst_type = mk_app(mk_constant(get_has_div_name(), {m_level}), m_type);
        if (auto inst = m_tctx.mk_class_instance(inst_type)) {
            return mk_app(mk_constant(get_div0_name(), {m_level}), m_type, *inst);
        } else {
            throw exception(sstream() << "cannot synthesize [has_div " << m_type << "]\n");
        }
    }

    expr get_neg() {
        expr inst_type = mk_app(mk_constant(get_has_neg_name(), {m_level}), m_type);
        if (auto inst = m_tctx.mk_class_instance(inst_type)) {
            return mk_app(mk_constant(get_neg_name(), {m_level}), m_type, *inst);
        } else {
            throw exception(sstream() << "cannot synthesize [has_neg " << m_type << "]\n");
        }
    }

    expr get_eq() { return mk_app(mk_constant(get_eq_name(), {m_level}), m_type); }
    expr get_le() { return mk_app(mk_constant(get_le_name(), {m_level}), m_type); }
    expr get_ge() { return mk_app(mk_constant(get_ge_name(), {m_level}), m_type); }

};

static inline head_type get_head_type(expr const & op) {
    if (!is_constant(op)) return head_type::OTHER;

    else if (const_name(op) == get_add_name()) return head_type::ADD;
    else if (const_name(op) == get_mul_name()) return head_type::MUL;

    else if (const_name(op) == get_zero_name()) return head_type::ZERO;
    else if (const_name(op) == get_one_name()) return head_type::ONE;
    else if (const_name(op) == get_bit0_name()) return head_type::BIT0;
    else if (const_name(op) == get_bit1_name()) return head_type::BIT1;

    else if (const_name(op) == get_neg_name()) return head_type::NEG;
    else if (const_name(op) == get_sub_name()) return head_type::SUB;
    else if (const_name(op) == get_div_name()) return head_type::DIV;

    else if (const_name(op) == get_div0_name()) return head_type::DIV0;

    else if (const_name(op) == get_int_of_nat_name()) return head_type::INT_OF_NAT;
    else if (const_name(op) == get_rat_of_int_name()) return head_type::RAT_OF_INT;
    else if (const_name(op) == get_real_of_rat_name()) return head_type::REAL_OF_RAT;

    else if (const_name(op) == get_eq_name()) return head_type::EQ;

    else if (const_name(op) == get_le_name()) return head_type::LE;
    else if (const_name(op) == get_ge_name()) return head_type::GE;

    else return head_type::OTHER;
}

class fast_arith_normalize_fn {
    type_context            m_tctx;
    arith_normalize_options m_options;
    partial_apps *          m_partial_apps_ptr;

public:
    fast_arith_normalize_fn(type_context & tctx): m_tctx(tctx), m_options(tctx.get_options()) {}

    expr operator()(expr const & e) {
        scope_trace_env scope(env(), m_tctx);
        buffer<expr> args;
        expr op = get_app_args(e, args);

        expr type;
        level l;

        switch (get_head_type(op)) {
        case head_type::OTHER:
            // TODO(dhs): we may still do something here
            throw exception(sstream() << "fast_arith_normalizer not expecting to be called on expr " << e << "\n");
            return e;
        case head_type::REAL_OF_RAT:
            type = mk_constant(get_real_name());
            l = mk_level_one();
            break;
        case head_type::RAT_OF_INT:
            type = mk_constant(get_rat_name());
            l = mk_level_one();
            break;
        case head_type::INT_OF_NAT:
            type = mk_constant(get_int_name());
            l = mk_level_one();
            break;
        default:
            type = args[0];
            l = get_level(m_tctx, type);
            break;
        }

        auto comm_ring_inst = m_tctx.mk_class_instance(mk_app(mk_constant(get_comm_ring_name(), {l}), type));
        if (!comm_ring_inst) {
            throw exception(sstream() << "fast_arith_normalizer not expecting to be called on expr " << e << " that is not of a type with commutative ring structure\n");
            return e;
        }
        partial_apps main_partial_apps(m_tctx, type);
        // TODO(dhs): these are hacky and unnecessary
        flet<partial_apps *> with_papps1(m_partial_apps_ptr, &main_partial_apps);

        if (m_options.profile()) {
            std::ostringstream msg;
            msg << " arith_normalizer time: ";
            timeit timer(get_dummy_ios().get_diagnostic_stream(), msg.str().c_str(), 0.0);
            return fast_normalize(e);
        } else {
            return fast_normalize(e);
        }
    }

private:
    environment env() const { return m_tctx.env(); }

    expr get_current_type() const { return m_partial_apps_ptr->get_type(); }

    expr mk_monomial(mpq const & coeff) {
        return mk_mpq_macro(coeff, get_current_type());
    }

    expr mk_monomial(mpq const & coeff, expr const & power_product) {
        if (coeff == 1) {
            return power_product;
        } else {
            expr c = mk_mpq_macro(coeff, get_current_type());
            return mk_app(m_partial_apps_ptr->get_mul(), c, power_product);
        }
    }

    expr mk_polynomial(mpq const & coeff, buffer<expr> const & monomials) {
        expr c = mk_mpq_macro(coeff, get_current_type());
        if (monomials.empty()) {
            return c;
        } else if (coeff.is_zero()) {
            return mk_polynomial(monomials);
        } else {
            expr add = m_partial_apps_ptr->get_add();
            return mk_app(add, c, mk_nary_app(add, monomials));
        }
    }

    expr mk_polynomial(buffer<expr> const & monomials) {
        if (monomials.empty())
            return mk_mpq_macro(mpq(), get_current_type());

        expr add = m_partial_apps_ptr->get_add();
        return mk_nary_app(add, monomials);
    }

    expr fast_normalize(expr const & e, bool is_summand = false, bool is_multiplicand = false) {
        check_system("arith_normalizer");
        lean_trace_inc_depth(name({"arith_normalizer", "fast"}));
        lean_trace_d(name({"arith_normalizer", "fast"}), tout() << e << "\n";);

        buffer<expr> args;
        expr op = get_app_args(e, args);

        unsigned num_args = args.size();
        switch (get_head_type(op)) {
        case head_type::EQ: return fast_normalize_rel(args[num_args-2], args[num_args-1], rel_kind::EQ);

        case head_type::LE: return fast_normalize_rel(args[num_args-2], args[num_args-1], rel_kind::LE);
        case head_type::GE: return fast_normalize_rel(args[num_args-2], args[num_args-1], rel_kind::GE);

        case head_type::ADD: return fast_normalize_add(e);
        case head_type::MUL: return fast_normalize_mul(e);

        case head_type::SUB: return fast_normalize_sub(args[2], args[3], is_summand);
        case head_type::DIV: return fast_normalize_div(args[2], args[3]);

        case head_type::DIV0: return fast_normalize_div0(args[2]);

        case head_type::NEG: return fast_normalize_neg(args[2], is_multiplicand);

        case head_type::INT_OF_NAT: return fast_normalize_int_of_nat(args[0]);
        case head_type::RAT_OF_INT: return fast_normalize_rat_of_int(args[0]);
        case head_type::REAL_OF_RAT: return fast_normalize_real_of_rat(args[0]);

        case head_type::ZERO: case head_type::ONE: case head_type::BIT0: case head_type::BIT1:
            if (auto n = to_num(e))
                return mk_mpq_macro(mpq(*n), get_current_type());
            else
                break;

        case head_type::OTHER:
            break;
        }
        // TODO(dhs): this will be unreachable eventually
        return e;
    }

    // Coercions
    // TODO(dhs): confirm that we do not need to re-traverse after pushing
    expr fast_normalize_real_of_rat(expr const & e) {
        lean_assert(get_current_type() == mk_constant(get_real_name()));
        expr e_n;
        {
            partial_apps rat_partial_apps(m_tctx, mk_constant(get_rat_name()));
            flet<partial_apps *> use_rat(m_partial_apps_ptr, &rat_partial_apps);
            e_n = fast_normalize(e);
        }
        lean_assert(get_current_type() == mk_constant(get_real_name()));
        return fast_push_coe(mk_constant(get_real_of_rat_name()), e_n);
    }

    expr fast_normalize_rat_of_int(expr const & e) {
        lean_assert(get_current_type() == mk_constant(get_rat_name()));
        expr e_n;
        {
            partial_apps int_partial_apps(m_tctx, mk_constant(get_int_name()));
            flet<partial_apps *> use_int(m_partial_apps_ptr, &int_partial_apps);
            e_n = fast_normalize(e);
        }
        lean_assert(get_current_type() == mk_constant(get_rat_name()));
        return fast_push_coe(mk_constant(get_rat_of_int_name()), e_n);
    }

    expr fast_normalize_int_of_nat(expr const & e) {
        lean_assert(get_current_type() == mk_constant(get_int_name()));
        // TODO(dhs): normalize nat part
        // Note: we don't yet have support for normalizing non-commutative rings
        if (auto z = is_num(e)) {
            return mk_mpq_macro(mpq(z), mk_constant(get_int_name()));
        } else {
            return mk_app(mk_constant(get_int_of_nat_name()), e);
        }
    }

    expr fast_push_coe(expr const & coe, expr const & e) {
        mpq q;
        expr arg1, arg2;

        if (is_mpq_macro(e, q)) {
            return mk_mpq_macro(q, get_current_type());
        } else if (is_add(e, arg1, arg2)) {
            lean_assert(!is_add(arg1));
            arg1 = fast_push_coe(coe, arg1);
            arg2 = fast_push_coe(coe, arg2);
            return mk_app(m_partial_apps_ptr->get_add(), arg1, arg2);
        } else if (is_mul(e, arg1, arg2)) {
            lean_assert(!is_mul(arg1));
            arg1 = fast_push_coe(coe, arg1);
            arg2 = fast_push_coe(coe, arg2);
            return mk_app(m_partial_apps_ptr->get_mul(), arg1, arg2);
        } else {
            return mk_app(coe, e);
        }
    }

    expr fast_normalize_sub(expr const & e1, expr const & e2, bool is_summand) {
        if (is_summand) {
            expr e1_n = fast_normalize(e1);
            expr e2_neg_n = fast_normalize(mk_app(m_partial_apps_ptr->get_neg(), e2));
            return mk_app(m_partial_apps_ptr->get_add(), e1_n, e2_neg_n);
        } else {
            expr e2_neg = mk_app(m_partial_apps_ptr->get_neg(), e2);
            return fast_normalize(mk_app(m_partial_apps_ptr->get_add(), e1, e2_neg));
        }
    }

    expr fast_normalize_neg(expr const & e, bool is_multiplicand) {
        mpq q(-1);
        expr c = mk_mpq_macro(q, get_current_type());
        if (is_multiplicand) {
            expr e_n = fast_normalize(e);
            return mk_app(m_partial_apps_ptr->get_mul(), c, e_n);
        } else {
            return fast_normalize(mk_app(m_partial_apps_ptr->get_mul(), c, e));
        }
    }

    expr fast_normalize_div0(expr const & e) {
        expr e_n = fast_normalize(e);
        return mk_app(m_partial_apps_ptr->get_div0(), e_n);
    }

    expr fast_normalize_div(expr const & _e1, expr const & _e2) {
        expr e1 = fast_normalize(_e1);
        expr e2 = fast_normalize(_e2);

        mpq q1, q2;
        if (is_mpq_macro(e2, q2)) {
            if (q2.is_zero()) {
                return mk_app(m_partial_apps_ptr->get_div0(), e1);
            } else if (is_mpq_macro(e1, q1)) {
                return mk_mpq_macro(q1/q2, get_current_type());
            } else {
                q2.inv();
                return mk_app(m_partial_apps_ptr->get_mul(), mk_mpq_macro(q2, get_current_type()), e1);
            }
        }
/*
  theorem field.div_mul_div (a : A) {b : A} (c : A) {d : A} (Hb : b ≠ 0) (Hd : d ≠ 0) :
      (a / b) * (c / d) = (a * c) / (b * d)
*/

        if (m_partial_apps_ptr->is_field()) {
            expr a1, v1, a2, v2;
            if (is_mul(e1, a1, v1) && is_mpq_macro(a1, q1)) {
                // already <num> * <other>
            } else {
                q1 = 1/1;
                v1 = e1;
            }

            if (is_mul(e2, a2, v2) && is_mpq_macro(a2, q2)) {
                // already <num> * <other>
            } else {
                q2 = 1/1;
                v2 = e2;
            }

            if (q1 != 1 || q2 != 1) {
                q1 /= q2;
                return mk_app(m_partial_apps_ptr->get_mul(), mk_mpq_macro(q1, get_current_type()),
                              mk_app(m_partial_apps_ptr->get_div(), v1, v2));
            }
        }

        // Note: we don't currently bother re-using original expression if it fails to simplify
        // If we did, we would need to check that the instances matched.
        return mk_app(m_partial_apps_ptr->get_div(), e1, e2);
    }

    // Normalizes as well
    void fast_get_flattened_nary_summands(expr const & e, buffer<expr> & args) {
        expr arg1, arg2;
        if (is_add(e, arg1, arg2)) {
            fast_get_flattened_nary_summands(arg1, args);
            fast_get_flattened_nary_summands(arg2, args);
        } else {
            bool is_summand = true;
            bool is_multiplicand = false;
            expr e_n = fast_normalize(e, is_summand, is_multiplicand);
            if (is_add(e_n, arg1, arg2)) {
                fast_get_flattened_nary_summands(arg1, args);
                fast_get_flattened_nary_summands(arg2, args);
            } else {
                args.push_back(e_n);
            }
        }
    }

    void fast_get_flattened_nary_multiplicands(expr const & e, buffer<expr> & args, bool normalize_multiplicands) {
        expr arg1, arg2;
        if (is_mul(e, arg1, arg2)) {
            fast_get_flattened_nary_multiplicands(arg1, args, normalize_multiplicands);
            fast_get_flattened_nary_multiplicands(arg2, args, normalize_multiplicands);
        } else if (normalize_multiplicands) {
            bool is_summand = false;
            bool is_multiplicand = true;
            expr e_n = fast_normalize(e, is_summand, is_multiplicand);
            if (is_mul(e_n, arg1, arg2)) {
                fast_get_flattened_nary_multiplicands(arg1, args, normalize_multiplicands);
                fast_get_flattened_nary_multiplicands(arg2, args, normalize_multiplicands);
            } else {
                args.push_back(e_n);
            }
        } else {
            args.push_back(e);
        }
    }

    expr fast_normalize_add(expr const & e) {
        buffer<expr> monomials;
        fast_get_flattened_nary_summands(e, monomials);
        expr_struct_set power_products;
        expr_struct_set repeated_power_products;

        mpq coeff;
        mpq num;
        unsigned num_coeffs = 0;

        for (expr const & monomial : monomials) {
            // TODO(dhs): I think we will be able to assume that numerals are already in normal form
            if (is_mpq_macro(monomial, num)) {
                coeff += num;
                num_coeffs++;
            } else {
                expr power_product = get_power_product(monomial);
                if (power_products.count(power_product)) {
                    repeated_power_products.insert(power_product);
                } else {
                    power_products.insert(power_product);
                }
            }
        }

        buffer<expr> new_monomials;
        expr e_n;

        if (repeated_power_products.empty()) {
            // Only numerals may need to be fused
            for (expr const & monomial : monomials) {
                if (!is_mpq_macro(monomial)) {
                    new_monomials.push_back(monomial);
                }
            }
            e_n = mk_polynomial(coeff, new_monomials);
        } else {
            lean_assert(!repeated_power_products.empty());
            expr_struct_map<mpq> power_product_to_coeff;

            for (expr const & monomial : monomials) {
                if (is_mpq_macro(monomial))
                    continue;
                expr power_product = get_power_product(monomial, num);
                if (!repeated_power_products.count(power_product))
                    continue;
                power_product_to_coeff[power_product] += num;
            }

            power_products.clear();

            for (expr const & monomial : monomials) {
                if (is_mpq_macro(monomial))
                    continue;
                expr power_product = get_power_product(monomial, num);
                if (!repeated_power_products.count(power_product)) {
                    new_monomials.push_back(monomial);
                } else if (!power_products.count(power_product)) {
                    power_products.insert(power_product);
                    mpq c = power_product_to_coeff.at(power_product);
                    if (!c.is_zero())
                        new_monomials.push_back(mk_monomial(c, power_product));
                }
            }
            e_n = mk_polynomial(coeff, new_monomials);
        }
        lean_trace_d(name({"arith_normalizer", "fast", "normalize_add"}), tout() << e << " ==> " << e_n << "\n";);
        return e_n;
    }

    void get_normalized_add_summands(expr const & e, buffer<expr> & summands) {
        expr first, rest;
        if (is_add(e, first, rest)) {
            lean_assert(!is_add(first));
            summands.push_back(first);
            get_normalized_add_summands(rest, summands);
        } else {
            summands.push_back(e);
        }
    }

    expr fast_normalize_mul(expr const & e, bool normalize_multiplicands = true) {
        buffer<expr> multiplicands;
        fast_get_flattened_nary_multiplicands(e, multiplicands, normalize_multiplicands);

        mpq coeff(1);
        mpq num;
        unsigned num_coeffs = 0;
        unsigned num_add    = 0;

        buffer<expr> non_num_multiplicands;

        for (expr const & multiplicand : multiplicands) {
            if (is_mpq_macro(multiplicand, num)) {
                coeff *= num;
                num_coeffs++;
            } else {
                non_num_multiplicands.push_back(multiplicand);
                if (is_add(multiplicand))
                    num_add++;
            }
        }

        if (coeff.is_zero()) {
            return mk_monomial(coeff);
        } else if (non_num_multiplicands.empty()) {
            return mk_monomial(coeff);
        }

        // TODO(dhs): expr_pow_lt

        // TODO(dhs): detect special cases and return early


        expr e_n;
        if (!m_options.distribute_mul() || num_add == 0) {
            std::sort(non_num_multiplicands.begin(), non_num_multiplicands.end());
            e_n = mk_monomial(coeff, mk_nary_app(m_partial_apps_ptr->get_mul(), non_num_multiplicands));
        } else {
            // TODO(dhs): use buffer<expr &> instead, to avoid all the reference counting
            lean_assert(m_options.distribute_mul());
            lean_assert(num_add > 0);

            buffer<unsigned> sizes;
            buffer<unsigned> iter;
            buffer<buffer<expr>> sums;

            for (expr const & multiplicand : non_num_multiplicands) {
                iter.push_back(0);
                buffer<expr> sum;
                if (is_add(multiplicand)) {
                    get_normalized_add_summands(multiplicand, sum);
                    sums.push_back(sum);
                    sizes.push_back(sum.size());
                } else {
                    sum.push_back(multiplicand);
                    sizes.push_back(1);
                    sums.push_back(sum);
                    lean_assert(sums.back()[0] == multiplicand);
                }
            }

            buffer<expr> new_multiplicands;
            buffer<expr> tmp;
            do {
                tmp.clear();
                for (unsigned i = 0; i < non_num_multiplicands.size(); ++i) {
                    tmp.push_back(sums[i][iter[i]]);
                }
                // TODO(dhs): there is no need to construct the application only to deconstruct it again
                // We have can a fast_normalize_mul_core that takes the buffer of arguments
                new_multiplicands.push_back(fast_normalize_mul(mk_monomial(coeff, mk_nary_app(m_partial_apps_ptr->get_mul(), tmp)), false));
            } while (product_iterator_next(sizes, iter));
            e_n = mk_nary_app(m_partial_apps_ptr->get_add(), new_multiplicands);
        }
        // TODO(dhs): need to normalize again at the top level (monomials now may be unnormalized)
        lean_trace_d(name({"arith_normalizer", "fast", "normalize_mul"}), tout() << e << " ==> " << e_n << "\n";);
        return e_n;
    }

    // Assumes that both sides are in normal form already
    norm_status fast_cancel_monomials(expr const & lhs, expr const & rhs, expr & new_lhs, expr & new_rhs) {
        buffer<expr> lhs_monomials;
        buffer<expr> rhs_monomials;
        fast_get_flattened_nary_summands(lhs, lhs_monomials);
        fast_get_flattened_nary_summands(rhs, rhs_monomials);

        // Pass 1: collect numerals, determine which power products appear on both sides
        // TODO(dhs): expr_set?
        expr_struct_set lhs_power_products;
        expr_struct_set shared_power_products;

        mpq coeff;
        mpq num;
        unsigned num_coeffs = 0;

        for (expr const & monomial : lhs_monomials) {
            if (is_mpq_macro(monomial, num)) {
                coeff += num;
                num_coeffs++;
            } else {
                expr power_product = get_power_product(monomial);
                lhs_power_products.insert(power_product);
            }
        }

        for (expr const & monomial : rhs_monomials) {
            if (is_mpq_macro(monomial, num)) {
                coeff -= num;
                num_coeffs++;
            } else {
                expr power_product = get_power_product(monomial);
                if (lhs_power_products.count(power_product)) {
                    shared_power_products.insert(power_product);
                }
            }
        }

        // TODO(dhs): may fail here

        // Pass 2: collect coefficients for power products that appear on both sides
        expr_struct_map<mpq> power_product_to_coeff;

        for (expr const & monomial : lhs_monomials) {
            if (is_mpq_macro(monomial))
                continue;
            expr power_product = get_power_product(monomial, num);
            if (!shared_power_products.count(power_product))
                continue;
            power_product_to_coeff[power_product] += num;
        }

        for (expr const & monomial : rhs_monomials) {
            if (is_mpq_macro(monomial))
                continue;
            expr power_product = get_power_product(monomial, num);
            if (!shared_power_products.count(power_product))
                continue;
            power_product_to_coeff[power_product] -= num;
        }


        // Pass 3: collect new monomials for both sides
        buffer<expr> new_lhs_monomials;
        for (expr const & monomial : lhs_monomials) {
            if (is_mpq_macro(monomial))
                continue;
            expr power_product = get_power_product(monomial, num);
            if (!shared_power_products.count(power_product)) {
                new_lhs_monomials.push_back(monomial);
            } else {
                mpq coeff = power_product_to_coeff.at(power_product);
                if (!coeff.is_zero())
                    new_lhs_monomials.push_back(mk_monomial(coeff, power_product));
            }
        }

        buffer<expr> new_rhs_monomials;
        for (expr const & monomial : rhs_monomials) {
            if (is_mpq_macro(monomial))
                continue;
            expr power_product = get_power_product(monomial, num);
            if (!shared_power_products.count(power_product)) {
                if (m_options.orient_polys()) {
                    if (!num.is_zero()) {
                        if (num == -1) {
                            new_lhs_monomials.push_back(power_product);
                        } else {
                            new_lhs_monomials.push_back(mk_monomial(neg(num), power_product));
                        }
                    }
                } else {
                    new_rhs_monomials.push_back(monomial);
                }
            }
        }

        bool coeff_on_rhs = m_options.orient_polys() || new_rhs_monomials.empty() || !new_lhs_monomials.empty();
        if (coeff_on_rhs) {
            new_lhs = mk_polynomial(new_lhs_monomials);
            new_rhs = mk_polynomial(neg(coeff), new_rhs_monomials);
        } else {
            new_lhs = mk_polynomial(coeff, new_lhs_monomials);
            new_rhs = mk_polynomial(new_rhs_monomials);
        }

        lean_trace_d(name({"arith_normalizer", "fast", "cancel_monomials"}), tout() << lhs << " <> " << rhs << " ==> " << new_lhs << " <> " << new_rhs << "\n";);
        return norm_status::DONE;
    }

    expr fast_normalize_rel(expr const & _lhs, expr const & _rhs, rel_kind rk) {
        expr lhs = fast_normalize(_lhs);
        expr rhs = fast_normalize(_rhs);
        expr new_lhs, new_rhs;
        norm_status st = fast_cancel_monomials(lhs, rhs, new_lhs, new_rhs);

        // TODO(dhs): if both sides are numerals, then reduce to true or false
        // TODO(dhs): bounds
        // TODO(dhs): gcd stuff
        // TODO(dhs): clear denominators?

        mpq q1, q2;
        if (is_mpq_macro(new_lhs, q1) && is_mpq_macro(new_rhs, q2)) {
            switch (rk) {
            case rel_kind::EQ: return (q1 == q2) ? mk_constant(get_true_name()) : mk_constant(get_false_name());
            case rel_kind::LE: return (q1 <= q2) ? mk_constant(get_true_name()) : mk_constant(get_false_name());
            case rel_kind::GE: return (q1 >= q2) ? mk_constant(get_true_name()) : mk_constant(get_false_name());
            }
        } else {
            switch (rk) {
            case rel_kind::EQ: return mk_app(m_partial_apps_ptr->get_eq(), new_lhs, new_rhs);
            case rel_kind::LE: return mk_app(m_partial_apps_ptr->get_le(), new_lhs, new_rhs);
            case rel_kind::GE: return mk_app(m_partial_apps_ptr->get_ge(), new_lhs, new_rhs);
            }
        }
        lean_unreachable();
    }
};


// Macro for trusting the fast normalizer
static name * g_arith_normalizer_macro_name    = nullptr;
static std::string * g_arith_normalizer_opcode = nullptr;

class arith_normalizer_macro_definition_cell : public macro_definition_cell {
    // TODO(dhs): what will I need to trigger the tactic framework from the kernel?
    /*
    environment     m_env
    local_context   m_lctx;
    metavar_context m_mctx;
    expr            m_thm;
    */

    void check_macro(expr const & m) const {
        if (!is_macro(m) || macro_num_args(m) != 1)
            throw exception(sstream() << "invalid 'arith_normalizer' macro, incorrect number of arguments");
    }

public:
    arith_normalizer_macro_definition_cell() {}

    virtual name get_name() const { return *g_arith_normalizer_macro_name; }
    virtual expr check_type(expr const & m, abstract_type_context & ctx, bool infer_only) const {
        check_macro(m);
        return macro_arg(m, 0);
    }

    virtual optional<expr> expand(expr const & m, abstract_type_context & ctx) const {
        check_macro(m);
        // TODO(dhs): create a new type context and run slow_arith_normalizer
        return none_expr();
    }

    virtual void write(serializer & s) const {
        s.write_string(*g_arith_normalizer_opcode);
    }

    virtual bool operator==(macro_definition_cell const & other) const {
        // TODO(dhs): what is this used for?
        if (auto other_ptr = dynamic_cast<arith_normalizer_macro_definition_cell const *>(&other)) {
            return true;
        } else {
            return false;
        }
    }

    virtual unsigned hash() const {
        return get_name().hash();
    }
};

static expr mk_arith_normalizer_macro(expr const & thm) {
    macro_definition m(new arith_normalizer_macro_definition_cell());
    return mk_macro(m, 1, &thm);
}

// Entry points
expr fast_arith_normalize(type_context & tctx, expr const & lhs) {
    return fast_arith_normalize_fn(tctx)(lhs);
}

simp_result arith_normalize(type_context & tctx, expr const & lhs) {
    expr rhs = fast_arith_normalize(tctx, lhs);
    expr pf = mk_arith_normalizer_macro(mk_eq(tctx, lhs, rhs));
    return simp_result(rhs, pf);
}

// VM

vm_obj tactic_arith_normalize(vm_obj const & e, vm_obj const & s0) {
    tactic_state const & s   = to_tactic_state(s0);
    try {
        type_context tctx = mk_type_context_for(s, transparency_mode::None);
        expr lhs = to_expr(e);
        simp_result result = arith_normalize(tctx, lhs);
        if (result.has_proof()) {
            return mk_tactic_success(mk_vm_pair(to_obj(result.get_new()), to_obj(result.get_proof())), s);
        } else {
            return mk_tactic_exception("arith_normalize tactic failed to simplify", s);
        }
    } catch (exception & e) {
        return mk_tactic_exception(e, s);
    }
}


// Setup and teardown

void initialize_arith_normalizer() {
    // Tracing
    register_trace_class("arith_normalizer");
    register_trace_class(name({"arith_normalizer", "fast"}));
    register_trace_class(name({"arith_normalizer", "slow"}));

    register_trace_class(name({"arith_normalizer", "fast", "cancel_monomials"}));
    register_trace_class(name({"arith_normalizer", "fast", "normalize_add"}));
    register_trace_class(name({"arith_normalizer", "fast", "normalize_mul"}));

    // Options names
    g_arith_normalizer_distribute_mul     = new name{"arith_normalizer", "distribute_mul"};
    g_arith_normalizer_fuse_mul           = new name{"arith_normalizer", "fuse_mul"};
    g_arith_normalizer_normalize_div      = new name{"arith_normalizer", "normalize_div"};
    g_arith_normalizer_orient_polys       = new name{"arith_normalizer", "orient_polys"};
    g_arith_normalizer_profile     = new name{"arith_normalizer", "profile"};

    // Register options
    register_bool_option(*g_arith_normalizer_distribute_mul, LEAN_DEFAULT_ARITH_NORMALIZER_DISTRIBUTE_MUL,
                         "(arith_normalizer) distribute mul over add");
    register_bool_option(*g_arith_normalizer_fuse_mul, LEAN_DEFAULT_ARITH_NORMALIZER_FUSE_MUL,
                         "(arith_normalizer) fuse (x * x) ==> x^2");
    register_bool_option(*g_arith_normalizer_normalize_div, LEAN_DEFAULT_ARITH_NORMALIZER_NORMALIZE_DIV,
                         "(arith_normalizer) (x / z) * y ==> (x * y) / z");
    register_bool_option(*g_arith_normalizer_orient_polys, LEAN_DEFAULT_ARITH_NORMALIZER_ORIENT_POLYS,
                         "(arith_normalizer) x + y + z = w + 2 ==> x + y + z - w = 2");
    register_bool_option(*g_arith_normalizer_profile, LEAN_DEFAULT_ARITH_NORMALIZER_PROFILE,
                         "(arith_normalizer) print how long an invocation takes");

    // Declare tactics
    DECLARE_VM_BUILTIN(name({"tactic", "arith_normalize"}), tactic_arith_normalize);

    // Register macro
    g_arith_normalizer_macro_name = new name("arith_normalizer");
    g_arith_normalizer_opcode     = new std::string("Arith_Norm");
    register_macro_deserializer(*g_arith_normalizer_opcode,
                                [](deserializer & d, unsigned num, expr const * args) {
                                    if (num != 1)
                                        throw corrupted_stream_exception();
                                    return mk_arith_normalizer_macro(args[0]);
                                });

}
void finalize_arith_normalizer() {
    // Delete names for options
    delete g_arith_normalizer_profile;
    delete g_arith_normalizer_orient_polys;
    delete g_arith_normalizer_normalize_div;
    delete g_arith_normalizer_fuse_mul;
    delete g_arith_normalizer_distribute_mul;

    // Delete names for macro
    delete g_arith_normalizer_macro_name;
    delete g_arith_normalizer_opcode;
}

}
