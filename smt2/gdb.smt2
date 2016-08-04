(set-logic QF_ALIA)
(set-info :source |
Benchmarks from Leonardo de Moura <demoura@csl.sri.com>

This benchmark was automatically translated into SMT-LIB format from
CVC format using CVC Lite
|)
(set-info :smt-lib-version 2.0)
(set-info :category "industrial")
(set-info :status unsat)

;(set-option :lnat 10000 simplify max_steps)

(declare-fun x_0 () Int)
(declare-fun x_1 () Int)
(declare-fun x_2 () Int)
(declare-fun x_3 () Int)
(declare-fun x_4 () (Array Int Int))
(declare-fun x_5 () Int)
(declare-fun x_6 () Int)
(declare-fun x_7 () Int)
(declare-fun x_8 () Int)
(declare-fun x_9 () Int)
(declare-fun x_10 () (Array Int Int))
(declare-fun x_11 () (Array Int Int))
(declare-fun x_12 () Int)
(declare-fun x_13 () Int)
(declare-fun x_14 () Int)
(declare-fun x_15 () Int)
(declare-fun x_16 () (Array Int Int))
(declare-fun x_17 () Int)
(declare-fun x_18 () Int)
(declare-fun x_19 () Int)
(declare-fun x_20 () Int)
(declare-fun x_21 () Int)
(declare-fun x_22 () Int)
(declare-fun x_23 () Int)
(declare-fun x_24 () (Array Int Int))
(declare-fun x_25 () Int)
(declare-fun x_26 () Int)
(declare-fun x_27 () Int)
(declare-fun x_28 () (Array Int Int))
(declare-fun x_29 () Int)
(declare-fun x_30 () Int)
(declare-fun x_31 () Int)
(declare-fun x_32 () Int)
(declare-fun x_33 () Int)
(declare-fun x_34 () Int)
(declare-fun x_35 () (Array Int Int))
(declare-fun x_36 () Int)
(declare-fun x_37 () Int)
(declare-fun x_38 () Int)
(declare-fun x_39 () (Array Int Int))
(declare-fun x_40 () Int)
(declare-fun x_41 () Int)
(declare-fun x_42 () Int)
(declare-fun x_43 () Int)
(declare-fun x_44 () Int)
(declare-fun x_45 () Int)
(declare-fun x_46 () (Array Int Int))
(declare-fun x_47 () Int)
(declare-fun x_48 () Int)
(declare-fun x_49 () Int)
(declare-fun x_50 () (Array Int Int))
(declare-fun x_51 () Int)
(declare-fun x_52 () Int)
(declare-fun x_53 () Int)
(declare-fun x_54 () Int)
(declare-fun x_55 () Int)
(declare-fun x_56 () Int)
(declare-fun x_57 () (Array Int Int))
(declare-fun x_58 () Int)
(declare-fun x_59 () Int)
(declare-fun x_60 () Int)
(declare-fun x_61 () (Array Int Int))
(declare-fun x_62 () Int)
(declare-fun x_63 () Int)
(declare-fun x_64 () Int)
(declare-fun x_65 () Int)
(declare-fun x_66 () Int)
(declare-fun x_67 () Int)
(declare-fun x_68 () (Array Int Int))
(declare-fun x_69 () Int)
(declare-fun x_70 () Int)
(declare-fun x_71 () Int)
(declare-fun x_72 () (Array Int Int))
(declare-fun x_73 () Int)
(declare-fun x_74 () Int)
(declare-fun x_75 () Int)
(declare-fun x_76 () Int)
(declare-fun x_77 () Int)
(declare-fun x_78 () Int)
(declare-fun x_79 () (Array Int Int))
(declare-fun x_80 () Int)
(declare-fun x_81 () Int)
(declare-fun x_82 () Int)
(declare-fun x_83 () (Array Int Int))
(declare-fun x_84 () Int)
(declare-fun x_85 () Int)
(declare-fun x_86 () Int)
(declare-fun x_87 () Int)
(declare-fun x_88 () Int)
(declare-fun x_89 () Int)
(declare-fun x_90 () (Array Int Int))
(declare-fun x_91 () Int)
(declare-fun x_92 () Int)
(declare-fun x_93 () Int)
(declare-fun x_94 () (Array Int Int))
(declare-fun x_95 () Int)
(declare-fun x_96 () Int)
(declare-fun x_97 () Int)
(declare-fun x_98 () Int)
(declare-fun x_99 () Int)
(declare-fun x_100 () Int)
(declare-fun x_101 () (Array Int Int))
(declare-fun x_102 () Int)
(declare-fun x_103 () Int)
(declare-fun x_104 () Int)
(declare-fun x_105 () (Array Int Int))
(declare-fun x_106 () Int)
(declare-fun x_107 () Int)
(declare-fun x_108 () Int)
(declare-fun x_109 () Int)
(declare-fun x_110 () Int)
(declare-fun x_111 () Int)
(declare-fun x_112 () (Array Int Int))
(declare-fun x_113 () Int)
(declare-fun x_114 () Int)
(declare-fun x_115 () Int)
(declare-fun x_116 () (Array Int Int))
(declare-fun x_117 () Int)
(declare-fun x_118 () Int)
(declare-fun x_119 () Int)
(declare-fun x_120 () Int)
(declare-fun x_121 () Int)
(declare-fun x_122 () Int)
(declare-fun x_123 () (Array Int Int))
(declare-fun x_124 () Int)
(declare-fun x_125 () Int)
(declare-fun x_126 () Int)
(declare-fun x_127 () (Array Int Int))
(declare-fun x_128 () Int)
(declare-fun x_129 () Int)
(declare-fun x_130 () Int)
(declare-fun x_131 () Int)
(declare-fun x_132 () Int)
(declare-fun x_133 () Int)
(declare-fun x_134 () (Array Int Int))
(declare-fun x_135 () Int)
(declare-fun x_136 () Int)
(declare-fun x_137 () Int)
(declare-fun x_138 () (Array Int Int))
(declare-fun x_139 () Int)
(declare-fun x_140 () Int)
(declare-fun x_141 () Int)
(declare-fun x_142 () Int)
(declare-fun x_143 () Int)
(declare-fun x_144 () Int)
(declare-fun x_145 () (Array Int Int))
(declare-fun x_146 () Int)
(declare-fun x_147 () Int)
(declare-fun x_148 () Int)
(declare-fun x_149 () (Array Int Int))
(declare-fun x_150 () Int)
(declare-fun x_151 () Int)
(declare-fun x_152 () Int)
(declare-fun x_153 () Int)
(declare-fun x_154 () Int)
(declare-fun x_155 () Int)
(declare-fun x_156 () (Array Int Int))
(declare-fun x_157 () Int)
(declare-fun x_158 () Int)
(declare-fun x_159 () Int)
(declare-fun x_160 () (Array Int Int))
(declare-fun x_161 () Int)
(declare-fun x_162 () Int)
(declare-fun x_163 () Int)
(declare-fun x_164 () Int)
(declare-fun x_165 () Int)
(declare-fun x_166 () Int)
(declare-fun x_167 () (Array Int Int))
(declare-fun x_168 () Int)
(declare-fun x_169 () Int)
(declare-fun x_170 () Int)
(declare-fun x_171 () (Array Int Int))
(declare-fun x_172 () Int)
(declare-fun x_173 () Int)
(declare-fun x_174 () Int)
(declare-fun x_175 () Int)
(declare-fun x_176 () Int)
(declare-fun x_177 () Int)
(declare-fun x_178 () (Array Int Int))
(declare-fun x_179 () Int)
(declare-fun x_180 () Int)
(declare-fun x_181 () Int)
(declare-fun x_182 () (Array Int Int))
(declare-fun x_183 () Int)
(declare-fun x_184 () Int)
(declare-fun x_185 () Int)
(declare-fun x_186 () Int)
(declare-fun x_187 () Int)
(declare-fun x_188 () Int)
(declare-fun x_189 () (Array Int Int))
(declare-fun x_190 () Int)
(declare-fun x_191 () Int)
(declare-fun x_192 () Int)
(declare-fun x_193 () (Array Int Int))
(declare-fun x_194 () Int)
(declare-fun x_195 () Int)
(declare-fun x_196 () Int)
(declare-fun x_197 () Int)
(declare-fun x_198 () Int)
(declare-fun x_199 () Int)
(declare-fun x_200 () (Array Int Int))
(declare-fun x_201 () Int)
(declare-fun x_202 () Int)
(declare-fun x_203 () Int)
(declare-fun x_204 () (Array Int Int))
(declare-fun x_205 () Int)
(declare-fun x_206 () Int)
(declare-fun x_207 () Int)
(declare-fun x_208 () Int)
(declare-fun x_209 () Int)
(declare-fun x_210 () Int)
(declare-fun x_211 () (Array Int Int))
(declare-fun x_212 () Int)
(declare-fun x_213 () Int)
(declare-fun x_214 () Int)
(declare-fun x_215 () (Array Int Int))
(declare-fun x_216 () Int)
(declare-fun x_217 () Int)
(declare-fun x_218 () Int)
(declare-fun x_219 () Int)
(declare-fun x_220 () Int)
(declare-fun x_221 () Int)
(declare-fun x_222 () (Array Int Int))
(declare-fun x_223 () Int)
(declare-fun x_224 () Int)
(declare-fun x_225 () Int)
(declare-fun x_226 () (Array Int Int))
(declare-fun x_227 () Int)
(declare-fun x_228 () Int)
(declare-fun x_229 () Int)
(declare-fun x_230 () Int)
(declare-fun x_231 () Int)
(declare-fun x_232 () Int)
(declare-fun x_233 () Int)
(declare-fun x_234 () Int)
(declare-fun x_235 () Int)
(declare-fun x_236 () Int)
(declare-fun x_237 () Int)
(declare-fun x_238 () Int)
(declare-fun x_239 () Int)
(declare-fun x_240 () Int)
(declare-fun x_241 () Int)
(declare-fun x_242 () Int)
(declare-fun x_243 () Int)
(declare-fun x_244 () Int)
(declare-fun x_245 () Int)
(declare-fun x_246 () Int)
(declare-fun x_247 () Int)
(declare-fun x_248 () Int)
(assert (let ((?v_174 (= x_6 (+ x_0 1))) (?v_181 (= x_9 x_2)) (?v_177 (= x_10 x_11)) (?v_175 (= x_12 x_13)) (?v_178 (= x_14 x_1)) (?v_179 (= x_15 x_3)) (?v_182 (= x_16 x_4)) (?v_180 (= x_17 x_18)) (?v_164 (= x_21 (+ x_6 1))) (?v_171 (= x_23 x_9)) (?v_167 (= x_24 x_10)) (?v_165 (= x_25 x_12)) (?v_168 (= x_26 x_14)) (?v_169 (= x_27 x_15)) (?v_172 (= x_28 x_16)) (?v_170 (= x_29 x_17)) (?v_155 (= x_32 (+ x_21 1))) (?v_162 (= x_34 x_23)) (?v_158 (= x_35 x_24)) (?v_156 (= x_36 x_25)) (?v_159 (= x_37 x_26)) (?v_160 (= x_38 x_27)) (?v_163 (= x_39 x_28)) (?v_161 (= x_40 x_29)) (?v_146 (= x_43 (+ x_32 1))) (?v_153 (= x_45 x_34)) (?v_149 (= x_46 x_35)) (?v_147 (= x_47 x_36)) (?v_150 (= x_48 x_37)) (?v_151 (= x_49 x_38)) (?v_154 (= x_50 x_39)) (?v_152 (= x_51 x_40)) (?v_137 (= x_54 (+ x_43 1))) (?v_144 (= x_56 x_45)) (?v_140 (= x_57 x_46)) (?v_138 (= x_58 x_47)) (?v_141 (= x_59 x_48)) (?v_142 (= x_60 x_49)) (?v_145 (= x_61 x_50)) (?v_143 (= x_62 x_51)) (?v_128 (= x_65 (+ x_54 1))) (?v_135 (= x_67 x_56)) (?v_131 (= x_68 x_57)) (?v_129 (= x_69 x_58)) (?v_132 (= x_70 x_59)) (?v_133 (= x_71 x_60)) (?v_136 (= x_72 x_61)) (?v_134 (= x_73 x_62)) (?v_119 (= x_76 (+ x_65 1))) (?v_126 (= x_78 x_67)) (?v_122 (= x_79 x_68)) (?v_120 (= x_80 x_69)) (?v_123 (= x_81 x_70)) (?v_124 (= x_82 x_71)) (?v_127 (= x_83 x_72)) (?v_125 (= x_84 x_73)) (?v_110 (= x_87 (+ x_76 1))) (?v_117 (= x_89 x_78)) (?v_113 (= x_90 x_79)) (?v_111 (= x_91 x_80)) (?v_114 (= x_92 x_81)) (?v_115 (= x_93 x_82)) (?v_118 (= x_94 x_83)) (?v_116 (= x_95 x_84)) (?v_101 (= x_98 (+ x_87 1))) (?v_108 (= x_100 x_89)) (?v_104 (= x_101 x_90)) (?v_102 (= x_102 x_91)) (?v_105 (= x_103 x_92)) (?v_106 (= x_104 x_93)) (?v_109 (= x_105 x_94)) (?v_107 (= x_106 x_95)) (?v_92 (= x_109 (+ x_98 1))) (?v_99 (= x_111 x_100)) (?v_95 (= x_112 x_101)) (?v_93 (= x_113 x_102)) (?v_96 (= x_114 x_103)) (?v_97 (= x_115 x_104)) (?v_100 (= x_116 x_105)) (?v_98 (= x_117 x_106)) (?v_83 (= x_120 (+ x_109 1))) (?v_90 (= x_122 x_111)) (?v_86 (= x_123 x_112)) (?v_84 (= x_124 x_113)) (?v_87 (= x_125 x_114)) (?v_88 (= x_126 x_115)) (?v_91 (= x_127 x_116)) (?v_89 (= x_128 x_117)) (?v_74 (= x_131 (+ x_120 1))) (?v_81 (= x_133 x_122)) (?v_77 (= x_134 x_123)) (?v_75 (= x_135 x_124)) (?v_78 (= x_136 x_125)) (?v_79 (= x_137 x_126)) (?v_82 (= x_138 x_127)) (?v_80 (= x_139 x_128)) (?v_65 (= x_142 (+ x_131 1))) (?v_72 (= x_144 x_133)) (?v_68 (= x_145 x_134)) (?v_66 (= x_146 x_135)) (?v_69 (= x_147 x_136)) (?v_70 (= x_148 x_137)) (?v_73 (= x_149 x_138)) (?v_71 (= x_150 x_139)) (?v_56 (= x_153 (+ x_142 1))) (?v_63 (= x_155 x_144)) (?v_59 (= x_156 x_145)) (?v_57 (= x_157 x_146)) (?v_60 (= x_158 x_147)) (?v_61 (= x_159 x_148)) (?v_64 (= x_160 x_149)) (?v_62 (= x_161 x_150)) (?v_47 (= x_164 (+ x_153 1))) (?v_54 (= x_166 x_155)) (?v_50 (= x_167 x_156)) (?v_48 (= x_168 x_157)) (?v_51 (= x_169 x_158)) (?v_52 (= x_170 x_159)) (?v_55 (= x_171 x_160)) (?v_53 (= x_172 x_161)) (?v_38 (= x_175 (+ x_164 1))) (?v_45 (= x_177 x_166)) (?v_41 (= x_178 x_167)) (?v_39 (= x_179 x_168)) (?v_42 (= x_180 x_169)) (?v_43 (= x_181 x_170)) (?v_46 (= x_182 x_171)) (?v_44 (= x_183 x_172)) (?v_29 (= x_186 (+ x_175 1))) (?v_36 (= x_188 x_177)) (?v_32 (= x_189 x_178)) (?v_30 (= x_190 x_179)) (?v_33 (= x_191 x_180)) (?v_34 (= x_192 x_181)) (?v_37 (= x_193 x_182)) (?v_35 (= x_194 x_183)) (?v_20 (= x_197 (+ x_186 1))) (?v_27 (= x_199 x_188)) (?v_23 (= x_200 x_189)) (?v_21 (= x_201 x_190)) (?v_24 (= x_202 x_191)) (?v_25 (= x_203 x_192)) (?v_28 (= x_204 x_193)) (?v_26 (= x_205 x_194)) (?v_10 (= x_208 (+ x_197 1))) (?v_18 (= x_210 x_199)) (?v_14 (= x_211 x_200)) (?v_11 (= x_212 x_201)) (?v_15 (= x_213 x_202)) (?v_16 (= x_214 x_203)) (?v_19 (= x_215 x_204)) (?v_17 (= x_216 x_205)) (?v_1 (= x_219 (+ x_208 1))) (?v_8 (= x_221 x_210)) (?v_4 (= x_222 x_211)) (?v_2 (= x_223 x_212)) (?v_5 (= x_224 x_213)) (?v_6 (= x_225 x_214)) (?v_9 (= x_226 x_215)) (?v_7 (= x_227 x_216)) (?v_0 (+ x_7 2)) (?v_12 (+ x_7 1)) (?v_173 (= x_2 (- 1))) (?v_183 (= x_210 (- 1)))) (let ((?v_3 (not ?v_183)) (?v_184 (= x_199 (- 1)))) (let ((?v_13 (not ?v_184)) (?v_185 (= x_188 (- 1)))) (let ((?v_22 (not ?v_185)) (?v_186 (= x_177 (- 1)))) (let ((?v_31 (not ?v_186)) (?v_187 (= x_166 (- 1)))) (let ((?v_40 (not ?v_187)) (?v_188 (= x_155 (- 1)))) (let ((?v_49 (not ?v_188)) (?v_189 (= x_144 (- 1)))) (let ((?v_58 (not ?v_189)) (?v_190 (= x_133 (- 1)))) (let ((?v_67 (not ?v_190)) (?v_191 (= x_122 (- 1)))) (let ((?v_76 (not ?v_191)) (?v_192 (= x_111 (- 1)))) (let ((?v_85 (not ?v_192)) (?v_193 (= x_100 (- 1)))) (let ((?v_94 (not ?v_193)) (?v_194 (= x_89 (- 1)))) (let ((?v_103 (not ?v_194)) (?v_195 (= x_78 (- 1)))) (let ((?v_112 (not ?v_195)) (?v_196 (= x_67 (- 1)))) (let ((?v_121 (not ?v_196)) (?v_197 (= x_56 (- 1)))) (let ((?v_130 (not ?v_197)) (?v_198 (= x_45 (- 1)))) (let ((?v_139 (not ?v_198)) (?v_199 (= x_34 (- 1)))) (let ((?v_148 (not ?v_199)) (?v_200 (= x_23 (- 1)))) (let ((?v_157 (not ?v_200)) (?v_201 (= x_9 (- 1)))) (let ((?v_166 (not ?v_201)) (?v_176 (not ?v_173))) (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (and (not (<= x_7 0)) (= x_0 0)) (= x_1 0)) ?v_173) (= x_3 0)) (= x_229 (select x_4 x_2))) (= x_5 x_229)) (= x_8 ?v_0)) (= x_230 (select x_16 x_9))) (= x_20 x_230)) (= x_22 ?v_0)) (= x_231 (select x_28 x_23))) (= x_31 x_231)) (= x_33 ?v_0)) (= x_232 (select x_39 x_34))) (= x_42 x_232)) (= x_44 ?v_0)) (= x_233 (select x_50 x_45))) (= x_53 x_233)) (= x_55 ?v_0)) (= x_234 (select x_61 x_56))) (= x_64 x_234)) (= x_66 ?v_0)) (= x_235 (select x_72 x_67))) (= x_75 x_235)) (= x_77 ?v_0)) (= x_236 (select x_83 x_78))) (= x_86 x_236)) (= x_88 ?v_0)) (= x_237 (select x_94 x_89))) (= x_97 x_237)) (= x_99 ?v_0)) (= x_238 (select x_105 x_100))) (= x_108 x_238)) (= x_110 ?v_0)) (= x_239 (select x_116 x_111))) (= x_119 x_239)) (= x_121 ?v_0)) (= x_240 (select x_127 x_122))) (= x_130 x_240)) (= x_132 ?v_0)) (= x_241 (select x_138 x_133))) (= x_141 x_241)) (= x_143 ?v_0)) (= x_242 (select x_149 x_144))) (= x_152 x_242)) (= x_154 ?v_0)) (= x_243 (select x_160 x_155))) (= x_163 x_243)) (= x_165 ?v_0)) (= x_244 (select x_171 x_166))) (= x_174 x_244)) (= x_176 ?v_0)) (= x_245 (select x_182 x_177))) (= x_185 x_245)) (= x_187 ?v_0)) (= x_246 (select x_193 x_188))) (= x_196 x_246)) (= x_198 ?v_0)) (= x_247 (select x_204 x_199))) (= x_207 x_247)) (= x_209 ?v_0)) (= x_248 (select x_215 x_210))) (= x_218 x_248)) (= x_220 ?v_0)) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_228 0) (< x_208 x_7)) ?v_1) (= x_225 (+ x_214 1))) (= x_221 x_213)) (= x_224 (+ x_213 1))) (= x_222 (store x_211 x_213 x_208))) ?v_2) (= x_226 (store x_215 x_213 x_210))) ?v_7) (and (and (and (and (and (and (and (and (and (and (= x_228 1) (= x_208 x_7)) ?v_3) (= x_227 x_210)) (= x_221 x_218)) ?v_1) ?v_4) ?v_2) ?v_5) ?v_6) ?v_9)) (and (and (and (and (and (and (and (and (and (and (= x_228 2) (= x_208 ?v_12)) ?v_3) ?v_1) ?v_8) ?v_4) ?v_2) ?v_5) ?v_6) (= x_226 (store x_215 x_216 x_218))) ?v_7)) (and (and (and (and (and (and (and (and (and (= x_228 3) (= x_208 x_220)) ?v_1) ?v_8) ?v_4) ?v_2) ?v_5) ?v_6) (= x_226 (store x_215 x_210 x_216))) ?v_7)) (and (and (and (and (and (and (and (and (and (= x_228 4) (not (<= x_208 x_220))) ?v_8) ?v_4) ?v_2) ?v_5) ?v_6) ?v_9) ?v_7) (= x_219 x_208)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_217 0) (< x_197 x_7)) ?v_10) (= x_214 (+ x_203 1))) (= x_210 x_202)) (= x_213 (+ x_202 1))) (= x_211 (store x_200 x_202 x_197))) ?v_11) (= x_215 (store x_204 x_202 x_199))) ?v_17) (and (and (and (and (and (and (and (and (and (and (= x_217 1) (= x_197 x_7)) ?v_13) (= x_216 x_199)) (= x_210 x_207)) ?v_10) ?v_14) ?v_11) ?v_15) ?v_16) ?v_19)) (and (and (and (and (and (and (and (and (and (and (= x_217 2) (= x_197 ?v_12)) ?v_13) ?v_10) ?v_18) ?v_14) ?v_11) ?v_15) ?v_16) (= x_215 (store x_204 x_205 x_207))) ?v_17)) (and (and (and (and (and (and (and (and (and (= x_217 3) (= x_197 x_209)) ?v_10) ?v_18) ?v_14) ?v_11) ?v_15) ?v_16) (= x_215 (store x_204 x_199 x_205))) ?v_17)) (and (and (and (and (and (and (and (and (and (= x_217 4) (not (<= x_197 x_209))) ?v_18) ?v_14) ?v_11) ?v_15) ?v_16) ?v_19) ?v_17) (= x_208 x_197)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_206 0) (< x_186 x_7)) ?v_20) (= x_203 (+ x_192 1))) (= x_199 x_191)) (= x_202 (+ x_191 1))) (= x_200 (store x_189 x_191 x_186))) ?v_21) (= x_204 (store x_193 x_191 x_188))) ?v_26) (and (and (and (and (and (and (and (and (and (and (= x_206 1) (= x_186 x_7)) ?v_22) (= x_205 x_188)) (= x_199 x_196)) ?v_20) ?v_23) ?v_21) ?v_24) ?v_25) ?v_28)) (and (and (and (and (and (and (and (and (and (and (= x_206 2) (= x_186 ?v_12)) ?v_22) ?v_20) ?v_27) ?v_23) ?v_21) ?v_24) ?v_25) (= x_204 (store x_193 x_194 x_196))) ?v_26)) (and (and (and (and (and (and (and (and (and (= x_206 3) (= x_186 x_198)) ?v_20) ?v_27) ?v_23) ?v_21) ?v_24) ?v_25) (= x_204 (store x_193 x_188 x_194))) ?v_26)) (and (and (and (and (and (and (and (and (and (= x_206 4) (not (<= x_186 x_198))) ?v_27) ?v_23) ?v_21) ?v_24) ?v_25) ?v_28) ?v_26) (= x_197 x_186)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_195 0) (< x_175 x_7)) ?v_29) (= x_192 (+ x_181 1))) (= x_188 x_180)) (= x_191 (+ x_180 1))) (= x_189 (store x_178 x_180 x_175))) ?v_30) (= x_193 (store x_182 x_180 x_177))) ?v_35) (and (and (and (and (and (and (and (and (and (and (= x_195 1) (= x_175 x_7)) ?v_31) (= x_194 x_177)) (= x_188 x_185)) ?v_29) ?v_32) ?v_30) ?v_33) ?v_34) ?v_37)) (and (and (and (and (and (and (and (and (and (and (= x_195 2) (= x_175 ?v_12)) ?v_31) ?v_29) ?v_36) ?v_32) ?v_30) ?v_33) ?v_34) (= x_193 (store x_182 x_183 x_185))) ?v_35)) (and (and (and (and (and (and (and (and (and (= x_195 3) (= x_175 x_187)) ?v_29) ?v_36) ?v_32) ?v_30) ?v_33) ?v_34) (= x_193 (store x_182 x_177 x_183))) ?v_35)) (and (and (and (and (and (and (and (and (and (= x_195 4) (not (<= x_175 x_187))) ?v_36) ?v_32) ?v_30) ?v_33) ?v_34) ?v_37) ?v_35) (= x_186 x_175)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_184 0) (< x_164 x_7)) ?v_38) (= x_181 (+ x_170 1))) (= x_177 x_169)) (= x_180 (+ x_169 1))) (= x_178 (store x_167 x_169 x_164))) ?v_39) (= x_182 (store x_171 x_169 x_166))) ?v_44) (and (and (and (and (and (and (and (and (and (and (= x_184 1) (= x_164 x_7)) ?v_40) (= x_183 x_166)) (= x_177 x_174)) ?v_38) ?v_41) ?v_39) ?v_42) ?v_43) ?v_46)) (and (and (and (and (and (and (and (and (and (and (= x_184 2) (= x_164 ?v_12)) ?v_40) ?v_38) ?v_45) ?v_41) ?v_39) ?v_42) ?v_43) (= x_182 (store x_171 x_172 x_174))) ?v_44)) (and (and (and (and (and (and (and (and (and (= x_184 3) (= x_164 x_176)) ?v_38) ?v_45) ?v_41) ?v_39) ?v_42) ?v_43) (= x_182 (store x_171 x_166 x_172))) ?v_44)) (and (and (and (and (and (and (and (and (and (= x_184 4) (not (<= x_164 x_176))) ?v_45) ?v_41) ?v_39) ?v_42) ?v_43) ?v_46) ?v_44) (= x_175 x_164)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_173 0) (< x_153 x_7)) ?v_47) (= x_170 (+ x_159 1))) (= x_166 x_158)) (= x_169 (+ x_158 1))) (= x_167 (store x_156 x_158 x_153))) ?v_48) (= x_171 (store x_160 x_158 x_155))) ?v_53) (and (and (and (and (and (and (and (and (and (and (= x_173 1) (= x_153 x_7)) ?v_49) (= x_172 x_155)) (= x_166 x_163)) ?v_47) ?v_50) ?v_48) ?v_51) ?v_52) ?v_55)) (and (and (and (and (and (and (and (and (and (and (= x_173 2) (= x_153 ?v_12)) ?v_49) ?v_47) ?v_54) ?v_50) ?v_48) ?v_51) ?v_52) (= x_171 (store x_160 x_161 x_163))) ?v_53)) (and (and (and (and (and (and (and (and (and (= x_173 3) (= x_153 x_165)) ?v_47) ?v_54) ?v_50) ?v_48) ?v_51) ?v_52) (= x_171 (store x_160 x_155 x_161))) ?v_53)) (and (and (and (and (and (and (and (and (and (= x_173 4) (not (<= x_153 x_165))) ?v_54) ?v_50) ?v_48) ?v_51) ?v_52) ?v_55) ?v_53) (= x_164 x_153)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_162 0) (< x_142 x_7)) ?v_56) (= x_159 (+ x_148 1))) (= x_155 x_147)) (= x_158 (+ x_147 1))) (= x_156 (store x_145 x_147 x_142))) ?v_57) (= x_160 (store x_149 x_147 x_144))) ?v_62) (and (and (and (and (and (and (and (and (and (and (= x_162 1) (= x_142 x_7)) ?v_58) (= x_161 x_144)) (= x_155 x_152)) ?v_56) ?v_59) ?v_57) ?v_60) ?v_61) ?v_64)) (and (and (and (and (and (and (and (and (and (and (= x_162 2) (= x_142 ?v_12)) ?v_58) ?v_56) ?v_63) ?v_59) ?v_57) ?v_60) ?v_61) (= x_160 (store x_149 x_150 x_152))) ?v_62)) (and (and (and (and (and (and (and (and (and (= x_162 3) (= x_142 x_154)) ?v_56) ?v_63) ?v_59) ?v_57) ?v_60) ?v_61) (= x_160 (store x_149 x_144 x_150))) ?v_62)) (and (and (and (and (and (and (and (and (and (= x_162 4) (not (<= x_142 x_154))) ?v_63) ?v_59) ?v_57) ?v_60) ?v_61) ?v_64) ?v_62) (= x_153 x_142)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_151 0) (< x_131 x_7)) ?v_65) (= x_148 (+ x_137 1))) (= x_144 x_136)) (= x_147 (+ x_136 1))) (= x_145 (store x_134 x_136 x_131))) ?v_66) (= x_149 (store x_138 x_136 x_133))) ?v_71) (and (and (and (and (and (and (and (and (and (and (= x_151 1) (= x_131 x_7)) ?v_67) (= x_150 x_133)) (= x_144 x_141)) ?v_65) ?v_68) ?v_66) ?v_69) ?v_70) ?v_73)) (and (and (and (and (and (and (and (and (and (and (= x_151 2) (= x_131 ?v_12)) ?v_67) ?v_65) ?v_72) ?v_68) ?v_66) ?v_69) ?v_70) (= x_149 (store x_138 x_139 x_141))) ?v_71)) (and (and (and (and (and (and (and (and (and (= x_151 3) (= x_131 x_143)) ?v_65) ?v_72) ?v_68) ?v_66) ?v_69) ?v_70) (= x_149 (store x_138 x_133 x_139))) ?v_71)) (and (and (and (and (and (and (and (and (and (= x_151 4) (not (<= x_131 x_143))) ?v_72) ?v_68) ?v_66) ?v_69) ?v_70) ?v_73) ?v_71) (= x_142 x_131)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_140 0) (< x_120 x_7)) ?v_74) (= x_137 (+ x_126 1))) (= x_133 x_125)) (= x_136 (+ x_125 1))) (= x_134 (store x_123 x_125 x_120))) ?v_75) (= x_138 (store x_127 x_125 x_122))) ?v_80) (and (and (and (and (and (and (and (and (and (and (= x_140 1) (= x_120 x_7)) ?v_76) (= x_139 x_122)) (= x_133 x_130)) ?v_74) ?v_77) ?v_75) ?v_78) ?v_79) ?v_82)) (and (and (and (and (and (and (and (and (and (and (= x_140 2) (= x_120 ?v_12)) ?v_76) ?v_74) ?v_81) ?v_77) ?v_75) ?v_78) ?v_79) (= x_138 (store x_127 x_128 x_130))) ?v_80)) (and (and (and (and (and (and (and (and (and (= x_140 3) (= x_120 x_132)) ?v_74) ?v_81) ?v_77) ?v_75) ?v_78) ?v_79) (= x_138 (store x_127 x_122 x_128))) ?v_80)) (and (and (and (and (and (and (and (and (and (= x_140 4) (not (<= x_120 x_132))) ?v_81) ?v_77) ?v_75) ?v_78) ?v_79) ?v_82) ?v_80) (= x_131 x_120)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_129 0) (< x_109 x_7)) ?v_83) (= x_126 (+ x_115 1))) (= x_122 x_114)) (= x_125 (+ x_114 1))) (= x_123 (store x_112 x_114 x_109))) ?v_84) (= x_127 (store x_116 x_114 x_111))) ?v_89) (and (and (and (and (and (and (and (and (and (and (= x_129 1) (= x_109 x_7)) ?v_85) (= x_128 x_111)) (= x_122 x_119)) ?v_83) ?v_86) ?v_84) ?v_87) ?v_88) ?v_91)) (and (and (and (and (and (and (and (and (and (and (= x_129 2) (= x_109 ?v_12)) ?v_85) ?v_83) ?v_90) ?v_86) ?v_84) ?v_87) ?v_88) (= x_127 (store x_116 x_117 x_119))) ?v_89)) (and (and (and (and (and (and (and (and (and (= x_129 3) (= x_109 x_121)) ?v_83) ?v_90) ?v_86) ?v_84) ?v_87) ?v_88) (= x_127 (store x_116 x_111 x_117))) ?v_89)) (and (and (and (and (and (and (and (and (and (= x_129 4) (not (<= x_109 x_121))) ?v_90) ?v_86) ?v_84) ?v_87) ?v_88) ?v_91) ?v_89) (= x_120 x_109)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_118 0) (< x_98 x_7)) ?v_92) (= x_115 (+ x_104 1))) (= x_111 x_103)) (= x_114 (+ x_103 1))) (= x_112 (store x_101 x_103 x_98))) ?v_93) (= x_116 (store x_105 x_103 x_100))) ?v_98) (and (and (and (and (and (and (and (and (and (and (= x_118 1) (= x_98 x_7)) ?v_94) (= x_117 x_100)) (= x_111 x_108)) ?v_92) ?v_95) ?v_93) ?v_96) ?v_97) ?v_100)) (and (and (and (and (and (and (and (and (and (and (= x_118 2) (= x_98 ?v_12)) ?v_94) ?v_92) ?v_99) ?v_95) ?v_93) ?v_96) ?v_97) (= x_116 (store x_105 x_106 x_108))) ?v_98)) (and (and (and (and (and (and (and (and (and (= x_118 3) (= x_98 x_110)) ?v_92) ?v_99) ?v_95) ?v_93) ?v_96) ?v_97) (= x_116 (store x_105 x_100 x_106))) ?v_98)) (and (and (and (and (and (and (and (and (and (= x_118 4) (not (<= x_98 x_110))) ?v_99) ?v_95) ?v_93) ?v_96) ?v_97) ?v_100) ?v_98) (= x_109 x_98)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_107 0) (< x_87 x_7)) ?v_101) (= x_104 (+ x_93 1))) (= x_100 x_92)) (= x_103 (+ x_92 1))) (= x_101 (store x_90 x_92 x_87))) ?v_102) (= x_105 (store x_94 x_92 x_89))) ?v_107) (and (and (and (and (and (and (and (and (and (and (= x_107 1) (= x_87 x_7)) ?v_103) (= x_106 x_89)) (= x_100 x_97)) ?v_101) ?v_104) ?v_102) ?v_105) ?v_106) ?v_109)) (and (and (and (and (and (and (and (and (and (and (= x_107 2) (= x_87 ?v_12)) ?v_103) ?v_101) ?v_108) ?v_104) ?v_102) ?v_105) ?v_106) (= x_105 (store x_94 x_95 x_97))) ?v_107)) (and (and (and (and (and (and (and (and (and (= x_107 3) (= x_87 x_99)) ?v_101) ?v_108) ?v_104) ?v_102) ?v_105) ?v_106) (= x_105 (store x_94 x_89 x_95))) ?v_107)) (and (and (and (and (and (and (and (and (and (= x_107 4) (not (<= x_87 x_99))) ?v_108) ?v_104) ?v_102) ?v_105) ?v_106) ?v_109) ?v_107) (= x_98 x_87)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_96 0) (< x_76 x_7)) ?v_110) (= x_93 (+ x_82 1))) (= x_89 x_81)) (= x_92 (+ x_81 1))) (= x_90 (store x_79 x_81 x_76))) ?v_111) (= x_94 (store x_83 x_81 x_78))) ?v_116) (and (and (and (and (and (and (and (and (and (and (= x_96 1) (= x_76 x_7)) ?v_112) (= x_95 x_78)) (= x_89 x_86)) ?v_110) ?v_113) ?v_111) ?v_114) ?v_115) ?v_118)) (and (and (and (and (and (and (and (and (and (and (= x_96 2) (= x_76 ?v_12)) ?v_112) ?v_110) ?v_117) ?v_113) ?v_111) ?v_114) ?v_115) (= x_94 (store x_83 x_84 x_86))) ?v_116)) (and (and (and (and (and (and (and (and (and (= x_96 3) (= x_76 x_88)) ?v_110) ?v_117) ?v_113) ?v_111) ?v_114) ?v_115) (= x_94 (store x_83 x_78 x_84))) ?v_116)) (and (and (and (and (and (and (and (and (and (= x_96 4) (not (<= x_76 x_88))) ?v_117) ?v_113) ?v_111) ?v_114) ?v_115) ?v_118) ?v_116) (= x_87 x_76)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_85 0) (< x_65 x_7)) ?v_119) (= x_82 (+ x_71 1))) (= x_78 x_70)) (= x_81 (+ x_70 1))) (= x_79 (store x_68 x_70 x_65))) ?v_120) (= x_83 (store x_72 x_70 x_67))) ?v_125) (and (and (and (and (and (and (and (and (and (and (= x_85 1) (= x_65 x_7)) ?v_121) (= x_84 x_67)) (= x_78 x_75)) ?v_119) ?v_122) ?v_120) ?v_123) ?v_124) ?v_127)) (and (and (and (and (and (and (and (and (and (and (= x_85 2) (= x_65 ?v_12)) ?v_121) ?v_119) ?v_126) ?v_122) ?v_120) ?v_123) ?v_124) (= x_83 (store x_72 x_73 x_75))) ?v_125)) (and (and (and (and (and (and (and (and (and (= x_85 3) (= x_65 x_77)) ?v_119) ?v_126) ?v_122) ?v_120) ?v_123) ?v_124) (= x_83 (store x_72 x_67 x_73))) ?v_125)) (and (and (and (and (and (and (and (and (and (= x_85 4) (not (<= x_65 x_77))) ?v_126) ?v_122) ?v_120) ?v_123) ?v_124) ?v_127) ?v_125) (= x_76 x_65)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_74 0) (< x_54 x_7)) ?v_128) (= x_71 (+ x_60 1))) (= x_67 x_59)) (= x_70 (+ x_59 1))) (= x_68 (store x_57 x_59 x_54))) ?v_129) (= x_72 (store x_61 x_59 x_56))) ?v_134) (and (and (and (and (and (and (and (and (and (and (= x_74 1) (= x_54 x_7)) ?v_130) (= x_73 x_56)) (= x_67 x_64)) ?v_128) ?v_131) ?v_129) ?v_132) ?v_133) ?v_136)) (and (and (and (and (and (and (and (and (and (and (= x_74 2) (= x_54 ?v_12)) ?v_130) ?v_128) ?v_135) ?v_131) ?v_129) ?v_132) ?v_133) (= x_72 (store x_61 x_62 x_64))) ?v_134)) (and (and (and (and (and (and (and (and (and (= x_74 3) (= x_54 x_66)) ?v_128) ?v_135) ?v_131) ?v_129) ?v_132) ?v_133) (= x_72 (store x_61 x_56 x_62))) ?v_134)) (and (and (and (and (and (and (and (and (and (= x_74 4) (not (<= x_54 x_66))) ?v_135) ?v_131) ?v_129) ?v_132) ?v_133) ?v_136) ?v_134) (= x_65 x_54)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_63 0) (< x_43 x_7)) ?v_137) (= x_60 (+ x_49 1))) (= x_56 x_48)) (= x_59 (+ x_48 1))) (= x_57 (store x_46 x_48 x_43))) ?v_138) (= x_61 (store x_50 x_48 x_45))) ?v_143) (and (and (and (and (and (and (and (and (and (and (= x_63 1) (= x_43 x_7)) ?v_139) (= x_62 x_45)) (= x_56 x_53)) ?v_137) ?v_140) ?v_138) ?v_141) ?v_142) ?v_145)) (and (and (and (and (and (and (and (and (and (and (= x_63 2) (= x_43 ?v_12)) ?v_139) ?v_137) ?v_144) ?v_140) ?v_138) ?v_141) ?v_142) (= x_61 (store x_50 x_51 x_53))) ?v_143)) (and (and (and (and (and (and (and (and (and (= x_63 3) (= x_43 x_55)) ?v_137) ?v_144) ?v_140) ?v_138) ?v_141) ?v_142) (= x_61 (store x_50 x_45 x_51))) ?v_143)) (and (and (and (and (and (and (and (and (and (= x_63 4) (not (<= x_43 x_55))) ?v_144) ?v_140) ?v_138) ?v_141) ?v_142) ?v_145) ?v_143) (= x_54 x_43)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_52 0) (< x_32 x_7)) ?v_146) (= x_49 (+ x_38 1))) (= x_45 x_37)) (= x_48 (+ x_37 1))) (= x_46 (store x_35 x_37 x_32))) ?v_147) (= x_50 (store x_39 x_37 x_34))) ?v_152) (and (and (and (and (and (and (and (and (and (and (= x_52 1) (= x_32 x_7)) ?v_148) (= x_51 x_34)) (= x_45 x_42)) ?v_146) ?v_149) ?v_147) ?v_150) ?v_151) ?v_154)) (and (and (and (and (and (and (and (and (and (and (= x_52 2) (= x_32 ?v_12)) ?v_148) ?v_146) ?v_153) ?v_149) ?v_147) ?v_150) ?v_151) (= x_50 (store x_39 x_40 x_42))) ?v_152)) (and (and (and (and (and (and (and (and (and (= x_52 3) (= x_32 x_44)) ?v_146) ?v_153) ?v_149) ?v_147) ?v_150) ?v_151) (= x_50 (store x_39 x_34 x_40))) ?v_152)) (and (and (and (and (and (and (and (and (and (= x_52 4) (not (<= x_32 x_44))) ?v_153) ?v_149) ?v_147) ?v_150) ?v_151) ?v_154) ?v_152) (= x_43 x_32)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_41 0) (< x_21 x_7)) ?v_155) (= x_38 (+ x_27 1))) (= x_34 x_26)) (= x_37 (+ x_26 1))) (= x_35 (store x_24 x_26 x_21))) ?v_156) (= x_39 (store x_28 x_26 x_23))) ?v_161) (and (and (and (and (and (and (and (and (and (and (= x_41 1) (= x_21 x_7)) ?v_157) (= x_40 x_23)) (= x_34 x_31)) ?v_155) ?v_158) ?v_156) ?v_159) ?v_160) ?v_163)) (and (and (and (and (and (and (and (and (and (and (= x_41 2) (= x_21 ?v_12)) ?v_157) ?v_155) ?v_162) ?v_158) ?v_156) ?v_159) ?v_160) (= x_39 (store x_28 x_29 x_31))) ?v_161)) (and (and (and (and (and (and (and (and (and (= x_41 3) (= x_21 x_33)) ?v_155) ?v_162) ?v_158) ?v_156) ?v_159) ?v_160) (= x_39 (store x_28 x_23 x_29))) ?v_161)) (and (and (and (and (and (and (and (and (and (= x_41 4) (not (<= x_21 x_33))) ?v_162) ?v_158) ?v_156) ?v_159) ?v_160) ?v_163) ?v_161) (= x_32 x_21)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_30 0) (< x_6 x_7)) ?v_164) (= x_27 (+ x_15 1))) (= x_23 x_14)) (= x_26 (+ x_14 1))) (= x_24 (store x_10 x_14 x_6))) ?v_165) (= x_28 (store x_16 x_14 x_9))) ?v_170) (and (and (and (and (and (and (and (and (and (and (= x_30 1) (= x_6 x_7)) ?v_166) (= x_29 x_9)) (= x_23 x_20)) ?v_164) ?v_167) ?v_165) ?v_168) ?v_169) ?v_172)) (and (and (and (and (and (and (and (and (and (and (= x_30 2) (= x_6 ?v_12)) ?v_166) ?v_164) ?v_171) ?v_167) ?v_165) ?v_168) ?v_169) (= x_28 (store x_16 x_17 x_20))) ?v_170)) (and (and (and (and (and (and (and (and (and (= x_30 3) (= x_6 x_22)) ?v_164) ?v_171) ?v_167) ?v_165) ?v_168) ?v_169) (= x_28 (store x_16 x_9 x_17))) ?v_170)) (and (and (and (and (and (and (and (and (and (= x_30 4) (not (<= x_6 x_22))) ?v_171) ?v_167) ?v_165) ?v_168) ?v_169) ?v_172) ?v_170) (= x_21 x_6)))) (or (or (or (or (and (and (and (and (and (and (and (and (and (= x_19 0) (< x_0 x_7)) ?v_174) (= x_15 (+ x_3 1))) (= x_9 x_1)) (= x_14 (+ x_1 1))) (= x_10 (store x_11 x_1 x_0))) ?v_175) (= x_16 (store x_4 x_1 x_2))) ?v_180) (and (and (and (and (and (and (and (and (and (and (= x_19 1) (= x_0 x_7)) ?v_176) (= x_17 x_2)) (= x_9 x_5)) ?v_174) ?v_177) ?v_175) ?v_178) ?v_179) ?v_182)) (and (and (and (and (and (and (and (and (and (and (= x_19 2) (= x_0 ?v_12)) ?v_176) ?v_174) ?v_181) ?v_177) ?v_175) ?v_178) ?v_179) (= x_16 (store x_4 x_18 x_5))) ?v_180)) (and (and (and (and (and (and (and (and (and (= x_19 3) (= x_0 x_8)) ?v_174) ?v_181) ?v_177) ?v_175) ?v_178) ?v_179) (= x_16 (store x_4 x_2 x_18))) ?v_180)) (and (and (and (and (and (and (and (and (and (= x_19 4) (not (<= x_0 x_8))) ?v_181) ?v_177) ?v_175) ?v_178) ?v_179) ?v_182) ?v_180) (= x_6 x_0)))) (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (or (and (not (<= x_219 0)) (= x_221 (- 1))) (and (not (<= x_208 0)) ?v_183)) (and (not (<= x_197 0)) ?v_184)) (and (not (<= x_186 0)) ?v_185)) (and (not (<= x_175 0)) ?v_186)) (and (not (<= x_164 0)) ?v_187)) (and (not (<= x_153 0)) ?v_188)) (and (not (<= x_142 0)) ?v_189)) (and (not (<= x_131 0)) ?v_190)) (and (not (<= x_120 0)) ?v_191)) (and (not (<= x_109 0)) ?v_192)) (and (not (<= x_98 0)) ?v_193)) (and (not (<= x_87 0)) ?v_194)) (and (not (<= x_76 0)) ?v_195)) (and (not (<= x_65 0)) ?v_196)) (and (not (<= x_54 0)) ?v_197)) (and (not (<= x_43 0)) ?v_198)) (and (not (<= x_32 0)) ?v_199)) (and (not (<= x_21 0)) ?v_200)) (and (not (<= x_6 0)) ?v_201)) (and (not (<= x_0 0)) ?v_173))))))))))))))))))))))))
(check-sat)
(exit)
