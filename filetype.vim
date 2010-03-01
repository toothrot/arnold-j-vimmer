augroup filetypedetect
au BufRead,BufNewFile  *COMMIT_EDITMSG  setf git
au BufRead,BufNewFile  *COMMIT_EDITMSG  call Git_diff_windows(1,1,"-C")
au! BufRead,BufNewFile *.mkd   setfiletype mkd
au! BufRead,BufNewFile *.markdown   setfiletype mkd
augroup END
