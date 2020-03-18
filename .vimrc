" Enable features that may not be on by default
set nocompatible
set ruler
set fileformats=unix
set ai
set hls

" Tabbing preferences
set tabstop=8 " How many spaces to render tabs as
set softtabstop=4 " How many spaces to insert/delete when pressing tab/backspc
set shiftwidth=4 " Automatic indentation width
set expandtab " Always write tabs as spaces
set background=dark
" Indent to last unclosed parenthesis in previous line
" Do not indent case label
" Align line after case with beginning of case label, not end
set cinoptions=(0,:0,l1
au FileType make setl noexpandtab " Use real tab characters in Makefile

" Enable filetype plugins
syntax on
au BufNewFile,BufRead * syn sync fromstart
filetype plugin on
filetype indent on

" Enable/disable paste
set pastetoggle=<F10>

aug sh
    let g:is_posix = 1
aug END

aug tex
    au FileType tex setl noai nocin nosi inde=
    au FileType tex if ! filereadable('Makefile') | setl makeprg=pdflatex\ -file-line-error\ -halt-on-error\ % | endif
    au FileType tex if ! filereadable('Makefile') | setl efm=%f:%l:\ %m,%-G%.%# | endif
aug END

aug ixmsketch
    au BufNewFile,BufRead *.pde setl filetype=cpp
    au BufNewFile,BufRead *.pde noremap <F8> :! sfbdl.sh .<CR>
    au BufNewFile,BufRead *.pde noremap <F9> :! sfbprog.sh<CR>
aug END

aug html
    au FileType html filetype indent off
    au FileType html setl inde=
    au FileType xhtml filetype indent off
    au FileType xhtml setl inde=
    au FileType htmldjango filetype indent off
    au FileType htmldjango setl inde=
aug END

aug python
    au FileType python set makeprg=python\ '%'
    au FileType python set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
aug END

aug php
    au BufNewFile,BufRead *.module set filetype=php
    au BufNewFile,BufRead *.inc set filetype=php
aug END

aug scheme
    au FileType scheme setl lispwords+=define-macro
    au FileType scheme setl lispwords-=if
    au FileType scheme nn <Tab> ==
    au FileType scheme vn <Tab> =
    au FileType scheme setl inde=lispindent(v:lnum)
    au FileType scheme setl indk+=!<Tab>
    au FileType scheme let &l:makeprg = 'mzscheme -i -l defmacro.ss -e \(load\ \"' . shellescape(escape(expand('%'), '"\')) . '\"\)'
    au FileType scheme setl efm=%C%.%#:%*\\d:%*\\d:%.%#,%E%f:%l:%c:\ %m,%Z>%.%#,%-G%.%#
aug END

aug haskell
    function! HaskellIncrementCols()
        let qflist = getqflist()
        for i in qflist
            let i.col += 1
        endfor
        call setqflist(qflist)
    endfunction
    au FileType haskell setl makeprg=ghci\ %
    au FileType lhaskell setl makeprg=ghci\ %
    au FileType haskell setl efm=%-G<interactive>:%.%#,%f:%l:%c:\ %m,%-G%.%#
    au FileType lhaskell setl efm=%f:%l:%c:\ %m,%-G%.%#
    au FileType haskell au QuickFixCmdPost make call HaskellIncrementCols()
    au FileType lhaskell au QuickFixCmdPost make call HaskellIncrementCols()
aug END

" Mark extra whitespace and lines that are too long in red
au BufWinEnter * match Error /\s\+$\|\%>79v.\+/
au InsertEnter * match Error /\s\+\%#\@<!$\|\%>79v.\+/
au InsertLeave * match Error /\s\+$\|\%>79v.\+/
au BufWinLeave * call clearmatches()
" Toggle red matches with F12
function! SetErrors()
    if exists('b:ErrorsDisabled') && b:ErrorsDisabled
        highlight clear Error
    else
        highlight Error ctermfg=white guifg=white ctermbg=red guibg=red
    endif
endfunction
function! ToggleErrors()
    let b:ErrorsDisabled = ! (exists('b:ErrorsDisabled') && b:ErrorsDisabled)
    call SetErrors()
endfunction
au BufWinEnter * call SetErrors()
au BufNewFile,BufRead * noremap <silent> <F12> :call ToggleErrors()<CR>
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
