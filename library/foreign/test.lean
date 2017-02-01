import foreign.eigen icml2017.certigrad.tmath

meta def approx_name : name → name
| `certigrad       := `certigrad.approx
| (name.mk_string s p)  :=  name.mk_string s (approx_name p)
| (name.mk_numeral s p) :=  name.mk_numeral s (approx_name p)
| anonymous := anonymous

meta def names_to_approx : list name :=
  [ /- RNG -/
    `certigrad.RNG,
    `certigrad.RNG.to_string,
    `certigrad.RNG.has_to_string,
    `certigrad.RNG.mk,
    /- T -/
    `certigrad.TShape,
    `certigrad.T,
    `certigrad.T.to_string,
    `certigrad.T.has_to_string,
    `certigrad.T.zero,
    `certigrad.T.one,
    `certigrad.T.pi,
    `certigrad.T.const,

    `certigrad.T.neg,
    `certigrad.T.inv,
    `certigrad.T.log,
    `certigrad.T.exp,
    `certigrad.T.sqrt,
    `certigrad.T.tanh,

    `certigrad.T.add,
    `certigrad.T.mul,
    `certigrad.T.sub,
    `certigrad.T.div,

    `certigrad.T.smul,

    `certigrad.T.sum,
    `certigrad.T.prod,

    `certigrad.T.get_row,
    `certigrad.T.get_col,
    `certigrad.T.get_col_range,

    `certigrad.T.gemv,
    `certigrad.T.gemm,
    `certigrad.T.sample_gauss
]

meta def names_to_transport : list name :=
[   `certigrad.T.has_zero,
    `certigrad.T.has_one,
    `certigrad.T.has_neg,
    `certigrad.T.has_inv,
    `certigrad.T.has_add,
    `certigrad.T.has_mul,
    `certigrad.T.has_sub,
    `certigrad.T.has_div,
    `certigrad.T.mdot
]

namespace certigrad
namespace T

noncomputable def mdot {n : ℕ} (x y : certigrad.T [n]) : certigrad.T [] := sum (x * y)

end T
end certigrad

open tactic

private meta def apply_replacement (replacements : name_map name) (e : expr) : expr :=
e^.replace (λ e d,
  match e with
  | expr.const n ls :=
    match replacements^.find n with
    | some new_n := some (expr.const new_n ls)
    | none       := none
    end
  | _ := none
  end)

meta def meta_copy_decl_using (replacements : name_map name) (src_decl_name : name) (new_decl_name : name) : command :=
do env  ← get_env,
   decl ← returnex $ env^.get src_decl_name,
   new_decl ← return $ declaration.defn new_decl_name
                                        decl^.univ_params
                                        (apply_replacement replacements decl^.type)
                                        (apply_replacement replacements decl^.value)
                                        (reducibility_hints.regular 1 tt)
                                        ff,
   add_decl new_decl,
   copy_attribute `instance src_decl_name tt new_decl_name

open tactic


meta def mtransport : command :=
let dict : name_map name := rb_map.of_list (list.map (λ n, (n, approx_name n)) (names_to_approx ++ names_to_transport)) in
list.foldl (λ t (n : name), do
  env ← get_env,
  t >> meta_copy_decl_using dict n (approx_name n))
skip names_to_transport

run_command mtransport

print certigrad.approx.T.mdot

vm_eval certigrad.approx.T.mdot (1 : certigrad.approx.T [5]) 1
