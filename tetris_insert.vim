function! s:move_floating_window(win_id, relative, row, col)
  let newConfig = {
    \ 'relative': a:relative,
    \ 'row': a:row,
    \ 'col': a:col,
    \}
  call nvim_win_set_config(a:win_id, newConfig)
  redraw
endfunction

function! s:create_window(config)
    let buf = nvim_create_buf(v:false, v:true)
    let win_id = nvim_open_win(buf, v:true, a:config)
    hi mycolor guifg=#ffffff guibg=#dd6900
    call nvim_win_set_option(win_id, 'winhighlight', 'Normal:mycolor')
    call nvim_win_set_option(win_id, 'winblend', 40)
    return win_id
endfunction

function! s:transparency_window(win_id)
    let i = 0
    while i <= 50
        call nvim_win_set_option(a:win_id, 'winblend', i*2)
        let i += 1
        redraw
    endwhile
endfunction

function! s:get_col() 
    " 行番号を非表示にしている場合は調整不要なので0を返す
    if &number == 0
        return 0
    endif
    " カレントバッファの最大行数から、その桁数をcolの開始位置として返す
    " +2しているのは行番号表示用ウィンドウの行頭/末のスペース分
    return strlen(line("w$")) + 2
endfunction

" クリップボードの文字列の長さをwidthとして返す
function! s:get_width() 
    return strlen(@*)
endfunction

function! s:main()
    let start_row = 1
    let col = s:get_col()
    let width = s:get_width()
    let config = { 'relative': 'editor', 'row': start_row, 'col': col, 'width': width, 'height': 1, 'anchor': 'NW', 'style': 'minimal',}
    let win_id = s:create_window(config)

    " floating windowにクリップボードの内容をペースト
    execute 'normal p'
    " フォーカスをカレントウィンドウに戻す
    execute "0windo " . ":"

    " floating windowを上から降らす
    let line = line('.')
    let move_y = line(".") - line("w0") - start_row
    let i = 0
    while i <= move_y
        call s:move_floating_window(win_id, config.relative, config.row + i + 1, config.col)
        sleep 10ms
        let i += 1
    endwhile

    " 空行を挿入
    execute 'normal o'
    " floating windowを透明化
    call s:transparency_window(win_id)
    " カレントウィンドウにクリップボードの内容をペースト
    let @* = substitute(@*,"\n","","g")
    execute 'normal p'

    call nvim_win_close(win_id, v:true)
endfunction

nnoremap <silent> T :call <SID>main()<CR>
