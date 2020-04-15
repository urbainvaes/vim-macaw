let groups = ["Boolean", "Character", "ColorColumn", "Comment",
            \ "Conditional", "Constant", "CursorLine", "CursorLineNr",
            \ "Debug", "Define", "Delimiter", "DiffAdd",
            \ "DiffChange", "DiffDelete", "DiffText", "Error",
            \ "ErrorMsg", "Exception", "Float", "FoldColumn",
            \ "Folded", "Function", "Identifier", "Ignore",
            \ "IncSearch", "Include", "Keyword", "Label",
            \ "LineNr", "Macro", "MatchParen", "ModeMsg",
            \ "NonText", "Number", "Operator", "Pmenu",
            \ "PmenuSbar", "PmenuSel", "PmenuThumb", "PreCondit",
            \ "PreProc", "Repeat", "Search", "SignColumn",
            \ "Special", "SpecialChar", "SpecialComment", "SpellBad",
            \ "SpellCap", "SpellLocal", "SpellRare", "Statement",
            \ "StatusLine", "StatusLineNC", "StatusLineTerm", "StatusLineTermNC",
            \ "StorageClass", "String", "Structure", "TabLine",
            \ "TabLineFill", "TabLineSel", "Tag", "Todo",
            \ "Type", "Typedef", "Underlined", "VertSplit",
            \ "Visual", "WildMenu"]

for group in groups
    exe 'syntax match '.group.' "^'.group.'"'
endfor
