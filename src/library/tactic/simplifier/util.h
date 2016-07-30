/*
Copyright (c) 2016 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Author: Daniel Selsam
*/
#pragma once
#include "kernel/expr.h"
#include "library/tactic/simp_result.h"

namespace lean {

void initialize_simp_util();
void finalize_simp_util();

}
