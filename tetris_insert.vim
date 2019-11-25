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
    " 行数を表示している場合、行数の桁数分調整する必要がある. e.g) max_line = 100の場合3(桁)
    " +2しているのは行番号表示用ウィンドウの行頭/末のスペース分
    let max_line = line("w$")
    return strlen(max_line) + 2
endfunction

function! s:get_width() 
    return strlen(@*)
endfunction

function! s:get_height() 
    let contents = split(@*,'\n')
    return len(contents)
endfunction

function! s:paste_to_current_window(number_of_line)
    if a:number_of_line == 1
        let @* = substitute(@*,"\n","","g")
        let @* = @* . "\n"
    endif
    execute 'normal p'
endfunction

" ペーストする内容を入れる(表示する)ための空行を挿入
function! s:insert_empty_line(row)
    let i = 0
    while i < a:row
        call append(expand('.'), '')
        let i += 1
    endwhile
endfunction

function! s:delete_empty_line(row)
    execute 'normal ' . a:row . 'j'
    execute 'normal ' . a:row . '"_dd'
    execute 'normal ' . a:row . 'k'
endfunction

function! s:main()
    let start_row = 10
    let col = s:get_col()
    let width = s:get_width()
    let height = s:get_height()
    let config = { 'relative': 'editor', 'row': start_row, 'col': col, 'width': width, 'height': height, 'anchor': 'NW', 'style': 'minimal',}
    if width == 0 || height == 0
        return
    endif

    let win_id = s:create_window(config)

    " floating windowにクリップボードの内容をペースト
    execute 'normal P'
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

    " ペースト内容を表示するための空行を挿入
    call s:insert_empty_line(height)

    " floating windowを透明化
    call s:transparency_window(win_id)

    " カレントウィンドウにクリップボードの内容をペースト
    call s:paste_to_current_window(height)

    " 事前に挿入した空行を削除
    call s:delete_empty_line(height)

    " floating windowを削除
    call nvim_win_close(win_id, v:true)
endfunction

nnoremap <silent> T :call <SID>main()<CR>
