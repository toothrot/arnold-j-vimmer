syntax enable
set shell=/bin/bash
set tabstop=2
set expandtab
set shiftwidth=2
set autoindent
set incsearch
set cindent
set smartindent
set showmatch
set mat=5
set wildmenu
color desert
set mouse=a
set number
set hidden
" yank ring:
set viminfo^=!
set hlsearch

autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
map <c-w><c-f> :FirstExplorerWindow<cr>
map <c-w><c-b> :BottomExplorerWindow<cr>
map <c-w><c-t> :WMToggle<cr>

let g:BASH_AuthorName   = 'Alexander Rakoczy'
let g:BASH_AuthorRef    = ''
let g:BASH_Email        = 'scissorjammer@gmail.com'
let g:BASH_Company      = ''

function! Find(name)
  let l:_name = substitute(a:name, "\\s", "*", "g")
  let l:list=system("find . -iname '*".l:_name."*' -not -name \"*.class\" -and -not -name \"*.swp\" | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (<enter>=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":e ".l:line
endfunction
command! -nargs=1 Find :call Find("<args>")

map ,f :Fi 

function! Git_diff_windows(vertsplit, auto, opts)
    if a:vertsplit
        rightbelow vnew
    else
        rightbelow new
    endif
    silent! setlocal ft=diff previewwindow bufhidden=delete nobackup noswf nobuflisted nowrap buftype=nofile
    exe "normal :r!LANG=C git diff --stat -p --cached ".a:opts."\no\<esc>1GddO\<esc>"
    setlocal nomodifiable
    noremap <buffer> q :bw<cr>
    if a:auto
        redraw!
        wincmd p
        redraw!
    endif
endfunction

map ,gd :call Git_diff_windows(1,1,"-C")<cr>

" au! BufRead,BufNewFile COMMIT_EDITMSG     setf git

au! BufRead,BufNewFile *.haml         setfiletype haml

let g:git_diff_spawn_mode = 2

set nocompatible
autocmd BufEnter * let &titlestring = "[vim(" . expand("%:t") . ")]"
if &term == "screen"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm"
  set title
endif
if has("gui_running")
  set fuoptions=maxvert,maxhorz
"  au GUIEnter * set fullscreen
endif

"au! CursorHold *.rb nested call PreviewWord()
func PreviewWord()
  if &previewwindow			" don't do this in the preview window
    return
  endif
  let w = expand("<cword>")		" get the word under cursor
  if w =~ '\a'			" if the word contains a letter

    " Delete any existing highlight before showing another tag
    silent! wincmd P			" jump to preview window
    if &previewwindow			" if we really get there...
      match none			" delete existing highlight
      wincmd p			" back to old window
    endif

    " Try displaying a matching tag for the word under the cursor
    try
       exe "ptag " . w
    catch
      return
    endtry

    silent! wincmd P			" jump to preview window
    if &previewwindow		" if we really get there...
	 if has("folding")
	   silent! .foldopen		" don't want a closed fold
	 endif
	 call search("$", "b")		" to end of previous line
	 let w = substitute(w, '\\', '\\\\', "")
	 call search('\<\V' . w . '\>')	" position cursor on match
	 " Add a match highlight to the word at this position
      hi previewWord term=bold ctermbg=green guibg=green
	 exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
      wincmd p			" back to old window
    endif
  endif
endfun

set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%03l,%03v][%p%%]\ [%Llines]
set laststatus=2

let mapleader = ","
