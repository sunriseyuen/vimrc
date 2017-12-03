set nocompatible

"Load functions
if filereadable(expand($VIM."/_vimrc_functions"))
    :exec ":source ".$VIM."/_vimrc_functions" 
elseif filereadable(expand("~/.config/nvim/_vimrc_functions"))
    :exec ":source "."~/.config/nvim/_vimrc_functions" 
endif

"General
"{
if 1
    syntax enable                " 打开语法高亮
    filetype indent on           " 针对不同的文件类型采用不同的缩进格式
    filetype plugin on           " 针对不同的文件类型加载对应的插件
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting

    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing

    if has('clipboard')
        set clipboard=unnamed       " Always use * for copy-paste
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:option_no_autochdir = 1
    if !exists('g:option_no_autochdir')
        " Always switch to the current file directory
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    endif

    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spelllang=en                    " Spell checking on, only for english
    set hidden                          " Allow buffer switching without saving

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    "au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:option_no_restore_cursor = 1
    if !exists('g:option_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
    set backup                  " Backups are nice ...
    if has('persistent_undo')
        set undofile                " So is persistent undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif

    " To disable views add the following to your .vimrc.before.local file:
    "   let g:spf13_no_views = 1
    if !exists('g:option_no_views')
        " Add exclusions to mkview and loadview
        " eg: *.*, svn-commit.tmp
        let g:skipview_files = [
                    \ '\[example pattern\]'
                    \ ]
    endif
    " }

endif
" }

" Encoding Settings
" {
if 1
    "gvim内部编码
    set encoding=utf-8
    "当前编辑文件编码
    set fileencoding=utf-8
    "支持打开文件的编瞿
    set fileencodings=utf-8,ucs-bom,gbk,cp936,gb2312,bug5,euc-jp,euc-kr,latinl
    "解决console输出乱码
    "language messages zh_CN.utf-8

    scriptencoding utf-8

    "设置终端编码为gvim内部编码encoding
    let &termencoding=&encoding

    " 因为在windows下只能是gbk
    if !has('gui_running') && WINDOWS()
        language messages zh_CN.gbk
        let &termencoding=&encoding
    end
end
" }
let g:w3m#search_engine = 'http://www.baidu.com' 
let g:w3m#external_browser = 'chrome'

" Load Appearance
call TrySource("_vimrc_appearance")

" Load keymaping
" 需要先设置 keymaping,这个会影响插件按键的绑定
call TrySource("_vimrc_keys")

" Load plugins
call TrySource("_vimrc_plugins")
"
