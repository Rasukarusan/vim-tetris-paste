function Init()
    " 空のバッファを作る
    let buf = nvim_create_buf(v:false, v:true)
    " そのバッファを使って floating windows を開く
    let height = float2nr(&lines * 0.5)
    let width = float2nr(&columns * 1.0)
    let row = float2nr((&columns - width) / 2)
    let col = float2nr((&columns - height) / 2)
    let opts = {
        \ 'relative': 'editor',
        \ 'row': 15,
        \ 'col': 50,
        \ 'width': 20,
        \ 'height': 10,
        \ 'anchor': 'NW',
        \ 'style': 'minimal',
    \}
    let g:win_id = nvim_open_win(buf, v:true, opts)
    hi mycolor guifg=#ffffff guibg=#ffee06
    call nvim_win_set_option(g:win_id, 'winhighlight', 'Normal:mycolor')

    " terminal
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

function s:main()
    call Init()
    let i = 1
    let MAX_NUM = 50
    while i < MAX_NUM
      let config = nvim_win_get_config(g:win_id)
      call s:move_floating_window(g:win_id, config.relative, config.row, config.col+1)
      " call nvim_win_set_width(g:win_id, i)
      call setline(i, i)
      let i += 1
    endwhile

    let i = 1
    let MAX_NUM = 50
    while i < MAX_NUM
      " sleep 50ms
      call nvim_win_set_option(g:win_id, 'winblend', i*3)
      redraw!
      let i += 1
    endwhile
endfunction

let g:contents = Get_current_buffer_contents()

function! Main()
    " カーソル位置をFloatingWindowの位置まで移動
    let fw_pos = nvim_win_get_position(g:win_id)
    let row = fw_pos[0]
    let column = fw_pos[1]
    let visible_first_line = line("w0")
    let pos = {'line' : visible_first_line + row, 'column' : column}
    call cursor(pos.line, pos.column)

    " FloatingWindowの位置で文字を挿入できるようスペースで埋める
    let expand_num = column - col("$") - 2
    if expand_num > 0
        call ExpandBySpace(pos.line, pos.column, expand_num)
    endif
    " FloatingWindowの文字列を取得
    execute ":normal i" . g:contents[0]
    " FloatingWindowの文字列を本Windowに挿入する
    call nvim_win_close(g:win_id, 1)
endfunction

function ExpandBySpace(line, column, num)
    call cursor(a:line, a:column)
    execute ":normal " . string(a:num) . "a" . " "
endfunction

function Get_current_buffer_contents()
    let lines = getline(0, line("$"))
    let contents = []
    for line in lines
        call add(contents, line)
    endfor
    return contents
endfunction


nnoremap <silent> M :call <SID>main()<CR>



