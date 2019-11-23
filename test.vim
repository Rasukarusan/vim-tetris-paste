" 空のバッファを作る
let buf = nvim_create_buf(v:false, v:true)
" そのバッファを使って floating windows を開く
let height = float2nr(&lines * 0.5)
let width = float2nr(&columns * 1.0)
let horizontal = float2nr((&columns - width) / 2)
let vertical = float2nr((&columns - height) / 2)
let opts = {
    \ 'relative': 'cursor',
    \ 'row': vertical,
    \ 'col': horizontal,
    \ 'width': width,
    \ 'height': height,
    \ 'anchor': 'NW',
\}
let g:win_id = nvim_open_win(buf, v:true, opts)
hi mycolor guifg=#ffffff guibg=#ffee06
call nvim_win_set_option(win_id, 'winhighlight', 'Normal:mycolor')

" terminal
set number

function s:hoge(i)
  let myconfig = {
    \ 'relative': 'cursor',
    \ 'row': 15,
    \ 'col': 50 + (a:i),
    \ 'width': 20,
    \ 'height': 10,
    \ 'anchor': 'NW',
    \ 'style': 'minimal',
\}
  let reset_config = nvim_win_set_config(g:win_id, myconfig)
endfunction

let i = 1
let MAX_NUM = 50
while i < MAX_NUM
  " echo i
  call s:hoge(i)
  " sleep 50ms
  call nvim_win_set_width(g:win_id, i*2)
  call nvim_win_set_option(win_id, 'winblend', i*2)
  call setline(i, i)
  redraw!
  let i += 1
endwhile

let g:contents = Get_current_buffer_contents()
" call Main()

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
    
    " call nvim_win_close(g:win_id, 1)
endfunction

function ExpandBySpace(line, column, num)
    call cursor(a:line, a:column)
    execute ":normal " . string(a:num) . "a" . " "
endfunction

function Get_current_buffer_contents()
    let lines = getline(0, line("$"))
    let contents = []
    for line in lines
        " contents = contents . line . "\r"
        call add(contents, line)
    endfor
    return contents
endfunction

nnoremap M :call Main()<CR>
