" tetris_paste.vim - Paste like TETRIS
" Maintainer: Rasukarusan
" License: MIT

" Default settings
if !exists('g:tetris_paste_speed')
  let g:tetris_paste_speed = 10
endif

if !exists('g:tetris_paste_start_row')
  let g:tetris_paste_start_row = 10
endif

if !exists('g:tetris_paste_highlight')
  let g:tetris_paste_highlight = 'guifg=#ffffff guibg=#dd6900'
endif

if !exists('g:tetris_paste_winblend')
  let g:tetris_paste_winblend = 40
endif

function! s:move_floating_window(win_id, relative, row, col) abort
  let newConfig = {
    \ 'relative': a:relative,
    \ 'row': a:row,
    \ 'col': a:col,
    \}
  call nvim_win_set_config(a:win_id, newConfig)
  redraw
endfunction

function! s:create_window(config) abort
  let buf = nvim_create_buf(v:false, v:true)
  let win_id = nvim_open_win(buf, v:true, a:config)
  execute 'hi TetrisPasteColor ' . g:tetris_paste_highlight
  call nvim_win_set_option(win_id, 'winhighlight', 'Normal:TetrisPasteColor')
  call nvim_win_set_option(win_id, 'winblend', g:tetris_paste_winblend)
  return win_id
endfunction

function! s:transparency_window(win_id) abort
  let i = 0
  while i <= 50
    call nvim_win_set_option(a:win_id, 'winblend', i*2)
    let i += 1
    if i % 2 == 0
      redraw
    endif
  endwhile
endfunction

function! s:get_col() abort
  if &number == 0
    return 0
  endif
  let max_line = line("$")
  return strlen(max_line) + 1
endfunction

function! s:get_width() abort
  return strlen(@*)
endfunction

function! s:get_height() abort
  let contents = split(@*,'\n')
  return len(contents)
endfunction

function! s:paste_to_current_window(number_of_line) abort
  if a:number_of_line == 1
    let @* = substitute(@*,"\n","","g")
    let @* = @* . "\n"
  endif
  execute 'normal p'
endfunction

function! s:insert_empty_line(row) abort
  let i = 0
  while i < a:row
    call append(expand('.'), '')
    let i += 1
  endwhile
endfunction

function! s:delete_empty_line(row) abort
  execute 'normal ' . a:row . 'j'
  execute 'normal ' . a:row . '"_dd'
  execute 'normal ' . a:row . 'k'
endfunction

function! tetris_paste#paste() abort
  let start_row = g:tetris_paste_start_row
  let col = s:get_col()
  let width = s:get_width()
  let height = s:get_height()
  let config = {
    \ 'relative': 'editor',
    \ 'row': start_row,
    \ 'col': col,
    \ 'width': width,
    \ 'height': height,
    \ 'anchor': 'NW',
    \ 'style': 'minimal',
    \}

  if width == 0 || height == 0
    return
  endif

  let win_id = s:create_window(config)

  " Paste clipboard content to floating window
  execute 'normal P'
  " Return focus to current window
  execute "0windo " . ":"

  " Drop floating window from top
  let move_y = line(".") - line("w0") - start_row
  let i = 0
  while i <= move_y
    call s:move_floating_window(win_id, config.relative, config.row + i + 1, config.col)
    execute 'sleep ' . g:tetris_paste_speed . 'ms'
    let i += 1
  endwhile

  " Insert empty lines for paste content
  call s:insert_empty_line(height)

  " Make floating window transparent
  call s:transparency_window(win_id)

  " Paste clipboard content to current window
  call s:paste_to_current_window(height)

  " Delete empty lines
  call s:delete_empty_line(height)

  " Close floating window
  call nvim_win_close(win_id, v:true)
endfunction
