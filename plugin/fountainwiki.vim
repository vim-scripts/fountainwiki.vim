" Vim plugin for Fountain screenplay files 
" Plugin Name:	FountainWiki & Indentation
" Version:	1.2 
" Last Change:	2012 Feb 21
" Reference: 	http://fountain.io/
" Maintainer:	Carson Fire <carsonfire@gmail.com>

if exists("g:wiki_1.path")
	exe 'command WikiReset let g:wiki_1.path = "'.g:wiki_1.path.'"'
elseif exists("g:wiki.path")
	exe 'command WikiReset let g:wiki.path = "'.g:wiki.path.'"'
endif
if !exists('FountainWiki_Auto_Indent')
	let FountainWiki_Auto_Indent = 1
endif
if !exists('FountainWiki_Tabstop')
	let FountainWiki_Tabstop = 8
endif
if !exists('FountainWiki_Textwidth')
	let FountainWiki_Textwidth = 0
endif
if !exists('FountainWiki_Character_Indent')
	let FountainWiki_Character_Indent = '\t\t'
endif
if !exists('FountainWiki_Parenthetical_Indent')
	let FountainWiki_Parenthetical_Indent = '\t'
endif
if !exists('FountainWiki_Transition_Indent')
	let FountainWiki_Transition_Indent = '\t\t\t\t\t\t'
endif
if !exists('FountainWiki_Centered_Indent')
	let FountainWiki_Centered_Indent = '\t\t\t\t'
endif
if !exists('FountainWiki_Card_Extension')
	let FountainWiki_Card_Extension = 'txt'
endif
if !exists('FountainWiki_Card_Width')
	let FountainWiki_Card_Width = 48
endif
if !exists('FountainWiki_Card_Right')
	let FountainWiki_Card_Right = 0
endif
if !exists('FountainWiki_Card_Only')
	let FountainWiki_Card_Only = 1
endif
if !exists('FountainWiki_Lowercase_Filename')
	let FountainWiki_Lowercase_Filename = 1
endif
if !exists('FountainWiki_Filename_Token')
	let FountainWiki_Filename_Token = '.fnx'
endif
if !exists('FountainWiki_Card_StayOpen')
	let FountainWiki_Card_StayOpen = 0
endif

function FountainWikiIndent()
	normal mvgg}mt
	"'t,$s/^\s*//ge
	exe '%s/^\s*\(\L*\)$/'.g:FountainWiki_Character_Indent.'\1/ge'
	exe '%s/^\s*\(.*\) TO:$/'.g:FountainWiki_Transition_Indent.'\1 TO:/ge'
	exe '%s/^\s*> \(.*\)$/'.g:FountainWiki_Transition_Indent.'> \1/ge'
	exe '%s/^\s*>\(.*\)</'.g:FountainWiki_Centered_Indent.'>\1</ge'
	exe '%s/^\s*(\(.*\))$/'.g:FountainWiki_Parenthetical_Indent.'(\1)/ge'
	't,$s/^\s*\(\.\|INT\. \|EXT\. \|INT\.\/EXT\. \|INT\/EXT\. \|INT \|EXT \|INT\/EXT \|I\/E \|int\. \|ext\. \|int\.\/ext\. \|int\/ext\. \|int \|ext \|int\/ext \|i\/e \)/\1/ge
	't,$s/^\s*$//ge
	normal 'v
endfunction

function FountainWikiCards()
	set noignorecase
	if exists("g:wiki_1.path")
		let g:wiki_1.path = expand("%:p:h")
	elseif exists("g:wiki.path")
		let g:wiki.path = expand("%:p:h")
	else
		let wiki = {}
		let g:wiki.path = expand("%:p:h")
	endif
	if g:FountainWiki_Card_Only < 1 && g:FountainWiki_Card_StayOpen < 1
		only
	endif
	lcd %:p:h
	let g:Text = getline('.')
	let g:Text = substitute(g:Text,"^\s*","","g")
	if g:Text =~ "[["
		let g:Comment = substitute(g:Text,".*\\[\\[\\(.*\\)\\]\\].*","\\1","g")
		let g:Comment = substitute(g:Text,"\\A*","","g")
		let g:Section = g:Comment
		let g:Character = g:Comment
	else
		let g:Comment = ""
		let g:Character = substitute(g:Text,"\\U*","","g")
		let g:Section = substitute(g:Text,"\\A*","","g")
	endif
	if ( g:Character == g:Section || matchstr(g:Text,"^#") == "#" ) && g:Text != ""
		if g:FountainWiki_Lowercase_Filename > 0
			let g:Section = tolower(g:Section)
		endif
		if g:FountainWiki_Card_Only > 0
			exe 'e '.g:Section.g:FountainWiki_Filename_Token.'.'.g:FountainWiki_Card_Extension
		else
			exe 'vsplit '.g:Section.g:FountainWiki_Filename_Token.'.'.g:FountainWiki_Card_Extension
			if g:FountainWiki_Card_Right > 0
				wincmd r
			endif
		endif
		exe 'vertical resize '.g:FountainWiki_Card_Width
	endif
endfunction

function ScreenplayHome()
	let g:FountainWiki_Home = expand("%:p")
	let g:FountainWiki_Home = substitute(g:FountainWiki_Home," ","\\\\ ","g")
	exe 'command! FountainWiki e '.g:FountainWiki_Home
	exe 'command! FW e '.g:FountainWiki_Home
	nnoremap <leader>fw <esc>:FountainWiki<cr>
	au BufRead *.wiki nmap <backspace> <esc>:FountainWiki<cr> 
endfunction

command FountainWikiCursorJump wincmd w
command FountainWikiDisableAuto au! BufWrite *.fountain,*.spmd
command FountainWikiEnableAuto au BufWrite *.fountain,*.spmd silent call FountainWikiIndent()
command FountainWikiIndent silent call FountainWikiIndent()
au BufWrite *.fountain,*.spmd FountainWikiIndent
au BufWrite *.fountain,*.spmd FountainWikiCursorJump
au BufRead *.fountain,*.spmd nnoremap <buffer> <c-cr> <esc>:FountainWikiIndent<cr>
command FountainWikiCards silent call FountainWikiCards()
au BufRead *.fountain,*.spmd nnoremap <buffer> <cr> <esc>:FountainWikiCards<cr>
exe 'au BufRead *.fountain,*.spmd set tw='.g:FountainWiki_Textwidth
exe 'au BufRead *.fountain,*.spmd set tabstop='.g:FountainWiki_Tabstop 
exe 'au BufRead *.fountain,*.spmd,*'.g:FountainWiki_Filename_Token.g:FountainWiki_Card_Extension.' nnoremap <buffer> <tab> <c-w>w'
au BufRead *.fountain,*.spmd call ScreenplayHome()
