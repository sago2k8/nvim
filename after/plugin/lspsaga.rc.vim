if !exists('g:loaded_lspsaga') | finish | endif

lua << EOF
local saga = require 'lspsaga'

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

EOF

nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>
"nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
nnoremap <silent> gp :Lspsaga preview_definition<CR>
"" Hover Doc
"nnoremap <silent>K :Lspsaga hover_doc<CR>
"
"" Async Lsp Finder
"nnoremap <silent> gh :Lspsaga lsp_finder<CR>
"
"" Signature Help
"nnoremap <silent> gs :Lspsaga signature_help<CR>
"
"nnoremap <silent> gp :Lspsaga preview_definition<CR>
"
"" Code Action
"nnoremap <silent><leader>ca :Lspsaga code_action<CR>
"vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
"
"" show diagnistic
"nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>
"
"" only show diagnostic if cursor is over the area
"nnoremap <silent><leader>cc <cmd>lua
"
"" jump diagnistic
"nnoremap <silent> [e :Lspsaga diagnostic_jump_next<CR>
"nnoremap <silent> ]e :Lspsaga diagnostic_jump_prev<CR>

