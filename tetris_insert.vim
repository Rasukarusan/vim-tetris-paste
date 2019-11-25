function! s:move_floating_window(win_id, relative, row, col)
  let newConfig = {
    \ 'relative': a:relative,
    \ 'row': a:row,
    \ 'col': a:col,
    \}
  call nvim_win_set_config(a:win_id, newConfig)
  redraw!
endfunction

function! s:create_window(config)
    let buf = nvim_create_buf(v:false, v:true)
    let win_id = nvim_open_win(buf, v:true, a:config)
    hi mycolor guifg=#ffffff guibg=#dd6900
    call nvim_win_set_option(win_id, 'winhighlight', 'Normal:mycolor')
    call nvim_win_set_option(win_id, 'winblend', 40)
    call setline('.', "hoge")
    return win_id
endfunction

function! Tetris_insert()

    let config = { 'relative': 'editor', 'row': 1, 'col': 10, 'width': 20, 'height': 1, 'anchor': 'NW', 'style': 'minimal',}
    let win_id = s:create_window(config)
    " フォーカスをカレントウィンドウに戻す
    execute "0windo " . ":"

    let line = line('.')
    let move_y = line(".") - line("w0") - 1
    let i = 0
    while i <= move_y
        call s:move_floating_window(win_id, config.relative, config.row + i + 1, config.col)
        let i += 1
    endwhile

    " 空行を挿入
    " call append(expand('.'), '')

    let win = win_id2win(win_id)
    " execute win . "windo " . "call setline(1,'hogehoge')"

    " execute 'normal p'

    " call nvim_win_close(win_id, 1)
endfunction

nnoremap <silent> M :call <SID>main()<CR>
nnoremap <silent> T :call Tetris_insert()<CR>
nnoremap <silent>A :echo win_id2win(g:win_id_clipboard)<CR>
