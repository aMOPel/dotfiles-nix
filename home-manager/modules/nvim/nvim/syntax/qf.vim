if exists('b:current_syntax')
    finish
endif

syn match qfFileName /^[^|]*/ nextgroup=qfSeparatorLeft
syn match qfSeparatorLeft '|' contained nextgroup=qfLineNr
syn match qfLineNr /\d*\( col \d*\)\?/ contained nextgroup=qfError,qfWarning,qfInfo,qfNote
syn match qfError / \(error|\)\|\(| error\)/ contained nextgroup=qfText
syn match qfWarning / \(warning|\)\|\(| warning\)/ contained nextgroup=qfText
syn match qfInfo / \(info|\)\|\(| info\)/ contained nextgroup=qfText
syn match qfNote / \(note|\)\|\(| note\)/ contained nextgroup=qfText
syn match qfText /.*$/ contained nextgroup=qfText

hi def link qfFileName Directory
hi def link qfSeparatorLeft Delimiter
" hi def link qfSeparatorRight Delimiter
hi def link qfLineNr LineNr
hi def link qfError DiagnosticError
hi def link qfWarning DiagnosticWarn
hi def link qfInfo DiagnosticInfo
hi def link qfNote DiagnosticHint
hi def link qfText Normal

let b:current_syntax = 'qf'
