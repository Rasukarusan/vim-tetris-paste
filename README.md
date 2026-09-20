# Vim TETRIS Paste

Vim paste like TETRIS.
Paste the contents of the clipboard from the top with animation.

## Demo

<img src="https://user-images.githubusercontent.com/17779386/69538032-bbfabd80-0fc4-11ea-85e2-4da46b2317b8.gif" width=700>

## Requirements

- Neovim (0.4+)
- +clipboard

This plugin uses `floating window` and Neovim API.

## Installation

### vim-plug

```vim
Plug 'Rasukarusan/vim-tetris-paste'
```

### dein.vim

```vim
call dein#add('Rasukarusan/vim-tetris-paste')
```

### packer.nvim

```lua
use 'Rasukarusan/vim-tetris-paste'
```

### lazy.nvim

```lua
{ 'Rasukarusan/vim-tetris-paste' }
```

## Usage

Press `T` in normal mode to paste clipboard content with TETRIS animation.

Supports dot-repeat (`.`) - no additional plugin required.

Or use the command:

```vim
:TetrisPaste
```

## Configuration

```vim
" Animation interval (ms) - larger is slower - default: 10
let g:tetris_paste_speed = 10

" Screen row the block starts falling from.
" When the cursor is above this row, the block falls from the top of the screen.
" default: 10
let g:tetris_paste_start_row = 10

" Highlight color - default: 'guifg=#ffffff guibg=#dd6900'
let g:tetris_paste_highlight = 'guifg=#ffffff guibg=#dd6900'

" Window transparency (0-100) - default: 40
let g:tetris_paste_winblend = 40

" Disable default key mapping (T)
let g:tetris_paste_no_default_key = 1
```

### Custom key mapping

```vim
" Disable default mapping
let g:tetris_paste_no_default_key = 1

" Set your own mapping (with dot-repeat support)
nnoremap <silent> <Leader>p :set opfunc=tetris_paste#opfunc<CR>g@l
```

## License

MIT
