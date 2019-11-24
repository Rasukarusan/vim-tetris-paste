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
endfunction

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
    execute ":normal " . string(a:num) . "A" . " "
endfunction

function Get_current_buffer_contents()
    let lines = getline(0, line("$"))
    let contents = []
    for line in lines
        call add(contents, line)
    endfor
    return contents
endfunction

function s:create_clipboard_window() abort
    if get(g:, 'win_id_clipboard') != 0 && nvim_win_is_valid(g:win_id_clipboard) == v:true
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

" win_id,win_num,bufnr等の各種変換に参考になるサイト
" http://koturn.hatenablog.com/entry/2018/02/14/000000

" call Init()

call s:create_clipboard_window()

function Tetris_insert()
    let buf = nvim_create_buf(v:false, v:true)
    let startRow = 1
    let opts = {
        \ 'relative': 'editor',
        \ 'row': startRow,
        \ 'col': 10,
        \ 'width': 20,
        \ 'height': 1,
        \ 'anchor': 'NW',
        \ 'style': 'minimal',
        \}
    let win_id = nvim_open_win(buf, v:false, opts)
    hi mycolor guifg=#ffffff guibg=#dd6900
    call nvim_win_set_option(win_id, 'winhighlight', 'Normal:mycolor')
    call nvim_win_set_option(win_id, 'winblend', 40)

    let line = line('.')
    let move_y = line(".") - line("w0") - startRow
    let i = 0
    while i <= move_y
        call s:move_floating_window(win_id, opts.relative, opts.row + i + 1, opts.col)
        " sleep 50ms
        let i += 1
    endwhile
    call append(expand('.'), '')

    let win = win_id2win(g:win_id_clipboard)
    echo win
    execute win . "windo " . "call setline(1,'hogehoge')"

    " execute 'normal p'

    " call nvim_win_close(win_id, 1)
endfunction

nnoremap <silent> M :call <SID>main()<CR>
nnoremap <silent> T :call Tetris_insert()<CR>
nnoremap <silent>A :echo win_id2win(g:win_id_clipboard)<CR>
