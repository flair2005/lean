/*
Copyright (c) 2016 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Author: Daniel Selsam
*/
#pragma once
#include "kernel/expr.h"
#include "library/type_context.h"
#include "library/tactic/simp_result.h"

namespace lean {

optional<pair<expr, expr> > is_assoc(type_context & tctx, name const & rel, expr const & e);

expr mk_flat_simp_macro(expr const & assoc, expr const & thm, optional<expr> pf_of_simp);

expr mk_congr_flat_simp_macro(expr const & assoc, expr const & thm, optional<expr> const & pf_of_simp,
                              optional<expr> const & pf_op, buffer<optional<expr> > const & pf_nary_args);

expr mk_rewrite_assoc_macro(expr const & assoc, expr const & thm, expr const & pf_of_step);

void initialize_simp_util();
void finalize_simp_util();

}