" クリップボードウィンドウの存在判定
function s:is_exist_clipboard_window() 
    return get(g:, 'win_id_clipboard') != 0 && nvim_win_is_valid(g:win_id_clipboard) == v:true
endfunction

" クリップボードウィンドウの作成
function s:create_clipboard_window() abort
    if s:is_exist_clipboard_window()
        return
    endif 
    let buf = nvim_create_buf(v:true, v:true)
    let opts = {
        \ 'relative': 'editor',
        \ 'row': 5,
        \ 'col': 200,
        \ 'width': 50,
        \ 'height': 20,
        \ 'anchor': 'NW',
        \ 'style': 'minimal',
    \}
    let g:win_id_clipboard = nvim_open_win(buf, v:false, opts)
    hi board_color guifg=#ffffff guibg=#cd4e38
    echo "クリップボードを作成:" . g:win_id_clipboard
    echo win_id2win(g:win_id_clipboard)
    call nvim_win_set_option(g:win_id_clipboard, 'winhighlight', 'Normal:board_color')
    call nvim_win_set_option(g:win_id_clipboard, 'winblend', 30)
    call nvim_win_set_config(g:win_id_clipboard, opts)
endfunction

function s:move_floating_window(win_id, relative, row, col)
  let newConfig = {
    \ 'relative': a:relative,
    \ 'row': a:row,
    \ 'col': a:col,
    \}
  call nvim_win_set_config(a:win_id, newConfig)
  redraw!
endfunction

call s:create_clipboard_window()

nnoremap <silent>A :echo win_id2win(g:win_id_clipboard)<CR>
