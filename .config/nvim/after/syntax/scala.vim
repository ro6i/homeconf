" hi def link scalaSuperCapital1 Include
" hi def link scalaSuperCapital5 Title
" hi def link scalaSuperCapital4 Macro
" hi def link scalaSuperCapital3 Typedef
" hi def link scalaSuperCapital2 Type
" hi def link scalaSuperNumber Number
" hi def link scalaSuperCapitalN Constant

hi! link scalaSquareBracketsBrackets Typedef
hi! link scalaKeywordModifier StorageClass
hi! link scalaInstanceDeclaration Typedef
hi! link scalaCapitalWord Typedef
hi! link scalaInterpolation Macro
hi! link scalaInterpolationBoundary Macro

syn match post_at         /[@]/     | hi! post_at ctermfg=14
syn match post_eq         /[=]/     | hi! post_eq ctermfg=9
syn match post_eq_gt      /[=][>]/  | hi! post_eq_gt ctermfg=9
syn match post_exc_eq     /[!][=]/  | hi! post_exc_eq ctermfg=9
syn match post_lt_dash    /[<][\-]/ | hi! post_lt_dash ctermfg=9
syn match post_dash_gt    /[\-][>]/ | hi! post_dash_gt ctermfg=9
