--
constant b : nat
#check b + b + b
#check true ∧ false ∧ true
#check (true ∧ false) ∧ true
#check (2:nat) + (2 + 2)
#check (2 + 2) + (2:nat)
#check (1:nat) = (2 + 3)*2
#check (2:nat) + 3 * 2 = 3 * 2 + 2
#check (true ∨ false) = (true ∨ false) ∧ true
#check true ∧ (false ∨ true)
constant A : Type
constant a : A
notation 1 := a
#check a
open nat
#check ℕ → ℕ
