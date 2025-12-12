" tetris_paste.vim - Paste like TETRIS
" Maintainer: Rasukarusan
" License: MIT

if exists('g:loaded_tetris_paste')
  finish
endif
let g:loaded_tetris_paste = 1

let s:save_cpo = &cpo
set cpo&vim

" Commands
command! TetrisPaste call tetris_paste#paste()

" Default mapping (can be disabled with g:tetris_paste_no_default_key)
if !exists('g:tetris_paste_no_default_key') || !g:tetris_paste_no_default_key
  nnoremap <silent> T :TetrisPaste<CR>
endif

let &cpo = s:save_cpo
unlet s:save_cpo
