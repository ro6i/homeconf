hi! link scalaSquareBracketsBrackets Typedef
hi! link scalaKeywordModifier StorageClass
hi! link scalaInstanceDeclaration Typedef
hi! link scalaCapitalWord Typedef
hi! link scalaInterpolation Macro
hi! link scalaInterpolationBoundary Macro

syn match scalaTodo "\vTODO|FIXME|XXX|NOTE|YANKME|DELETEME" contained
syn match post_brac       /[()]/         | hi post_brac ctermfg=8
syn match post_bracket    /[{}]$/        | hi post_bracket ctermfg=8
syn match post_bracket_b  /^\s*[{}]/     | hi post_bracket_b ctermfg=8
syn match post_dot        /[.,]/         | hi post_dot ctermfg=3
syn match post_sep        /[_]/          | hi post_sep ctermfg=12
syn match post_at         /[@]/          | hi link post_at Operator
syn match post_eq_gt      / [=][>]/      | hi post_eq_gt ctermfg=8
syn match post_op         / \([:][:]\|[:][:][:]\|[+][+]\|[+][+][:]\|[\-][\-]\)$/   | hi post_op ctermfg=8
syn match post_op_        / \([:][:]\|[:][:][:]\|[+][+]\|[+][+][:]\|[\-][\-]\) /   | hi post_op_ ctermfg=8
syn match post_eq         / [=] /        | hi post_eq ctermfg=8
syn match post_exc_eq     / [!][=] /     | hi post_exc_eq ctermfg=8
syn match post_eq_gt      / [=][=] /     | hi post_eq_gt ctermfg=8
syn match post_lt_dash    / [<][\-]/     | hi post_lt_dash ctermfg=8
syn match post_lt_eq      / [<][=]/      | hi post_lt_eq ctermfg=8
syn match post_dash_gt    / [\-][>] /    | hi post_dash_gt ctermfg=8
syn match post_plus       /[+\-\*]/      | hi post_plus ctermfg=8
