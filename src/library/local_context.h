/*
Copyright (c) 2016 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Author: Leonardo de Moura
*/
#pragma once
#include "util/name_map.h"
#include "util/name_set.h"
#include "kernel/expr.h"

namespace lean {
class local_decl {
public:
    struct cell {
        /*
          <name> : <type> := <value>

          m_pp_name is used for interacting with the user.
          It may not be not unique.
        */
        name               m_name; /* this one is unique */
        name               m_pp_name;
        expr               m_type;
        optional<expr>     m_value;
        binder_info        m_bi;
        unsigned           m_idx;
        MK_LEAN_RC(); // Declare m_rc counter
        void dealloc();
        cell(unsigned idx, name const & n, name const & pp_n, expr const & t, optional<expr> const & v,
             binder_info const & bi);
    };
private:
    cell * m_ptr;
    friend class local_context;
    friend void initialize_local_context();
    local_decl(unsigned idx, name const & n, name const & pp_n, expr const & t, optional<expr> const & v, binder_info const & bi);
    local_decl(local_decl const & d, expr const & t, optional<expr> const & v);
public:
    local_decl();
    local_decl(local_decl const & s):m_ptr(s.m_ptr) { if (m_ptr) m_ptr->inc_ref(); }
    local_decl(local_decl && s):m_ptr(s.m_ptr) { s.m_ptr = nullptr; }
    ~local_decl() { if (m_ptr) m_ptr->dec_ref(); }
    local_decl & operator=(local_decl const & s) { LEAN_COPY_REF(s); }
    local_decl & operator=(local_decl && s) { LEAN_MOVE_REF(s); }

    friend bool is_eqp(local_decl const & a, local_decl const & b) { return a.m_ptr == b.m_ptr; }

    name const & get_name() const { return m_ptr->m_name; }
    name const & get_pp_name() const { return m_ptr->m_pp_name; }
    expr const & get_type() const { return m_ptr->m_type; }
    optional<expr> const & get_value() const { return m_ptr->m_value; }
    binder_info const & get_info() const { return m_ptr->m_bi; }
    expr mk_ref() const;
    unsigned get_idx() const { return m_ptr->m_idx; }
};

bool is_local_decl_ref(expr const & e);

class metavar_context;

bool depends_on(expr const & e, metavar_context const & mctx, unsigned num, expr const * locals);
bool depends_on(local_decl const & d, metavar_context const & mctx,  unsigned num, expr const * locals);
bool depends_on(expr const & e, metavar_context const & mctx,  buffer<expr> const & locals);
bool depends_on(local_decl const & d, metavar_context const & mctx, buffer<expr> const & locals);

/* Create an unieq local_decl name.
   This is a low-level function. The high-level methods
   at local_context use this function internally. */
name mk_local_decl_name();

class metavar_context;

class local_context {
    typedef rb_map<unsigned, local_decl, unsigned_cmp> idx2local_decl;
    unsigned              m_next_idx;
    name_map<local_decl>  m_name2local_decl;
    idx2local_decl        m_idx2local_decl;
    optional<unsigned>    m_instance_fingerprint;
    friend class type_context;
    /* Return the instance fingerprint for empty local_contexts */
    static unsigned get_empty_instance_fingerprint() { return 31; }

    local_context remove(buffer<expr> const & locals) const;
    expr mk_local_decl(name const & n, name const & ppn, expr const & type,
                       optional<expr> const & value, binder_info const & bi);
public:
    local_context():m_next_idx(0) {}

    /* Return an empty local context with instance fingerprint set. */
    static local_context mk_with_instance_fingerprint() {
        local_context lctx;
        lctx.m_instance_fingerprint = optional<unsigned>(get_empty_instance_fingerprint());
        return lctx;
    }

    optional<unsigned> get_instance_fingerprint() const { return m_instance_fingerprint; }

    bool empty() const { return m_idx2local_decl.empty(); }

    expr mk_local_decl(expr const & type, binder_info const & bi = binder_info());
    expr mk_local_decl(expr const & type, expr const & value);
    expr mk_local_decl(name const & ppn, expr const & type, binder_info const & bi = binder_info());
    expr mk_local_decl(name const & ppn, expr const & type, expr const & value);

    /* Low-level version of the methods above.

       \pre `n` was created using mk_local_decl_name
       \pre there is no local_decl named `n` in this local_context. */
    expr mk_local_decl(name const & n, name const & ppn, expr const & type, binder_info const & bi = binder_info());
    expr mk_local_decl(name const & n, name const & ppn, expr const & type, expr const & value);

    /** \brief Return the local declarations for the given reference.
        \pre is_local_decl_ref(e) */
    optional<local_decl> get_local_decl(expr const & e) const;
    optional<local_decl> get_local_decl(name const & n) const;
    /** \brief Traverse local declarations based on the order they were created */
    void for_each(std::function<void(local_decl const &)> const & fn) const;
    optional<local_decl> find_if(std::function<bool(local_decl const &)> const & pred) const; // NOLINT
    optional<local_decl> back_find_if(std::function<bool(local_decl const &)> const & pred) const; // NOLINT

    /** \brief Return the most recently added local_decl \c d s.t. d.get_pp_name() == n
        \remark This method is used to implement tactics such as 'revert'. */
    optional<local_decl> get_local_decl_from_user_name(name const & n) const;

    optional<local_decl> get_last_local_decl() const;

    /** Return a local_decl_ref associated with the given name.

        \pre get_local_decl(n) */
    expr get_local(name const & n) const;

    bool rename_user_name(name const & from, name const & to);

    /** \brief Execute fn for each local declaration created after \c d. */
    void for_each_after(local_decl const & d, std::function<void(local_decl const &)> const & fn) const;

    /** \brief Return a non-none iff other local decls depends on \c d. If the result is not none,
        then it is the name of the local decl that depends on d.
        \pre \c d is in this local context. */
    optional<local_decl> has_dependencies(local_decl const & d, metavar_context const & mctx) const;

    /** \brief Return an unused hypothesis "user name" with the given prefix, the suffix is an
        unsigned >= idx. */
    name get_unused_name(name const & prefix, unsigned & idx) const;
    name get_unused_name(name const & suggestion) const;
    /** \brief Return true iff the given name is a hypothesis "user name". */
    bool uses_user_name(name const & n) const;

    /** \brief Remove the given local decl. */
    void clear(local_decl const & d);

    /** \brief Return true iff all locals in this context are in the set \c ls. */
    bool is_subset_of(name_set const & ls) const;
    /** \brief Return true iff all locals in this context are also in \c ctx. */
    bool is_subset_of(local_context const & ctx) const;

    void pop_local_decl();

    /** \brief We say a local context is well-formed iff all local declarations only
        contain local_decl references that were defined before them.

        \remark This method is for debugging purposes. */
    bool well_formed() const;

    /** \brief Return true iff \c e is well-formed with respect to this local context.
        That is, all local_decl references in \c e are defined in this context. */
    bool well_formed(expr const & e) const;

    format pp(formatter const & fmt, bool full_names = false) const;

    /** \brief Replaced assigned metavariables with their values.
        This method is a little bit hackish since it reuses the names and ids of
        the existing local_decls. So, it may affects cached information.

        This method is mainly used in the elaborator for reporting errors,
        and for instantiating metavariables created by the elaborator before
        invoking the tactic framework. */
    local_context instantiate_mvars(metavar_context & ctx) const;
};

/** \brief Return true iff `e` contains a local_decl_ref that contains a value */
bool contains_let_local_decl(local_context const & lctx, expr const & e);

/** \brief Expand all local_decl_refs (that have values) in `e` */
expr zeta_expand(local_context const & lctx, expr const & e);

void initialize_local_context();
void finalize_local_context();
}
