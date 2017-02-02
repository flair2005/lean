import .tmath .compute_grad .builder .aevb

namespace certigrad

attribute [semireducible] T

def M₁ : T [2, 3] := 2
def N₁ : T [3, 2] := 3
def x₁ : T [3] := 5

print "[5 5 5]"
vm_eval x₁

print "75"
vm_eval T.dot x₁ x₁

print "[30 30]"
vm_eval T.gemv M₁ x₁

print "[18 18]"
vm_eval T.gemm M₁ N₁

print "12"
vm_eval T.sum M₁

print "15"
vm_eval T.sum x₁

print "64"
vm_eval T.prod M₁

print "125"
vm_eval T.prod x₁

-----------------------------

print "[0 0]"
vm_eval compute_grad_slow [Identifier.str "cost"]
                          [2] (Identifier.str "theta")
                          [⟨Identifier.str "cost", [], [], Ops.Det.const (7 : T []), [], rfl⟩]
                          (DMap.insert (Identifier.str "theta") (5 : T [2]) (DMap.mk Identifier T))

print "[1 1]"
vm_eval compute_grad_slow [Identifier.str "cost"]
                          [2] (Identifier.str "theta")
                          [⟨Identifier.str "cost", [[2]], [], Ops.Det.sum [2], [Identifier.str "theta"], rfl⟩]
                          (DMap.insert (Identifier.str "theta") (5 : T [2]) (DMap.mk Identifier T))

print "[5 5]"
vm_eval compute_grad_slow [Identifier.str "cost"]
                          [2] (Identifier.str "theta")
                          [⟨Identifier.str "cost", [[2]], [], Ops.Det.prod [2], [Identifier.str "theta"], rfl⟩]
                          (DMap.insert (Identifier.str "theta") (5 : T [2]) (DMap.mk Identifier T))

print "[25 25 25]"
vm_eval compute_grad_slow [Identifier.str "cost"]
                          [3] (Identifier.str "theta")
                          [⟨Identifier.str "cost", [[3]], [], Ops.Det.prod [3], [Identifier.str "theta"], rfl⟩]
                          (DMap.insert (Identifier.str "theta") (5 : T [3]) (DMap.mk Identifier T))

print "[25 25 25]"
vm_eval DVec.head (bprop [Identifier.str "cost"]
                         [[3]] [Identifier.str "theta"] rfl
                         [⟨Identifier.str "cost", [[3]], [], Ops.Det.prod [3], [Identifier.str "theta"], rfl⟩]
                         (DMap.insert (Identifier.str "theta") (5 : T [3]) (DMap.mk Identifier T)))

print "[1 1]"
vm_eval DVec.head (bprop [Identifier.str "cost_sum", Identifier.str "cost_prod"]
                         [[2], [3]] [Identifier.str "theta_sum", Identifier.str "theta_prod"] rfl
                         [⟨Identifier.str "cost_sum", [[2]], [], Ops.Det.sum [2], [Identifier.str "theta_sum"], rfl⟩,
                          ⟨Identifier.str "cost_prod", [[3]], [], Ops.Det.prod [3], [Identifier.str "theta_prod"], rfl⟩]
                         (DMap.insert (Identifier.str "theta_sum") (5 : T [2])
                                      (DMap.insert (Identifier.str "theta_prod") (5 : T [3]) (DMap.mk Identifier T))))

print "[25 25 25]"
vm_eval DVec.head₂ (bprop [Identifier.str "cost_sum", Identifier.str "cost_prod"]
                         [[2], [3]] [Identifier.str "theta_sum", Identifier.str "theta_prod"] rfl
                         [⟨Identifier.str "cost_sum", [[2]], [], Ops.Det.sum [2], [Identifier.str "theta_sum"], rfl⟩,
                          ⟨Identifier.str "cost_prod", [[3]], [], Ops.Det.prod [3], [Identifier.str "theta_prod"], rfl⟩]
                         (DMap.insert (Identifier.str "theta_sum") (5 : T [2])
                                      (DMap.insert (Identifier.str "theta_prod") (5 : T [3]) (DMap.mk Identifier T))))


section
open GraphBuilder
open GraphBuilder.Det
open GraphBuilder.Rand

def g₁ : Graph := build_graph $ do
  θ ← param "theta" [2],
  x ← const (1 : T [2]),
--  y ← dot 2 θ x,
  y ← const (1 : T [2]),
  z ← const (1 : T [2]),
  cost ← sum [2] y,
--  cost ← dot 2 θ x,
  return [y]


def foo := DVec.head (bprop g₁~>costs
                         (list.map Target.shape g₁~>targets) (list.map Target.name g₁~>targets) rfl
                         g₁~>nodes
                         (DMap.insert (Identifier.str "theta") (5 : T [2]) (DMap.mk Identifier T)))


--  return [cost]
set_option trace.compiler.code_gen true
set_option trace.vm.run true

vm_eval DVec.head (bprop g₁~>costs
                         (list.map Target.shape g₁~>targets) (list.map Target.name g₁~>targets) rfl
                         g₁~>nodes
                         (DMap.insert (Identifier.str "theta") (5 : T [2]) (DMap.mk Identifier T)))

set_option trace.compiler.code_gen false
/-

def g₂ : Graph := build_graph $ do
  θ ← param "theta" [2],
  x_all ← const (5 : T [2, 2]),
  x ← get_col 2 2 x_all ⟨0, sorry⟩,
  y ← dot 2 x x,
  cost ← sum [2] y,
  return [cost]


print "tricky one"
vm_eval DVec.head (bprop g₂~>costs
                         (list.map Target.shape g₂~>targets) (list.map Target.name g₂~>targets) rfl
                         g₂~>nodes
                         (DMap.insert (Identifier.str "theta") (5 : T [2]) (DMap.mk Identifier T)))
-/

end

/-
vm_eval AEVB.Programs.build_graph₁ (1 : T [3, 7]) ⟨0, sorry⟩ 2 [] []
-- {n_x x_dim : ℕ} (x_data : T [x_dim, n_x]) (x_idx : fin n_x) (z_dim : ℕ) (z_hiddens x_hiddens : List (ℕ × String)) : Graph := build_graph $ d
-/
end certigrad
