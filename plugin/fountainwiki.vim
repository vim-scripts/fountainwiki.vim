" Vim plugin for Fountain screenplay files 
" Plugin Name:	Fountainwiki & Indentation
" Version:	1.3 
" Last Change:	2012 Feb 24
" Reference: 	http://fountain.io/
" Maintainer:	Carson Fire <carsonfire@gmail.com>

"{{{ Check user settings, load defaults

" Indentation settings
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
exe 'au FileType fountain,spmd setlocal tw='.g:FountainWiki_Textwidth
exe 'au FileType fountain,spmd setlocal tabstop='.g:FountainWiki_Tabstop 

" Wiki settings
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
	let FountainWiki_Filename_Token = ''
endif
if !exists('FountainWiki_Card_StayOpen')
	let FountainWiki_Card_StayOpen = 0
endif

"}}}

"{{{ Create functions

function FountainWikiIndent()
	" When triggered, this function indents an entire Fountain doc.
	normal mvgg}mt
	let g:Safety = "'t,$"
	" We bookmark our current location, then bookmark the first blank
	" line.
	exe g:Safety.'s/^\s*\(\L*\)$/'.g:FountainWiki_Character_Indent.'\1/ge'
	exe g:Safety.'s/^\s*\(.*\) TO:$/'.g:FountainWiki_Transition_Indent.'\1 TO:/ge'
	exe g:Safety.'s/^\s*> \(.*\)$/'.g:FountainWiki_Transition_Indent.'> \1/ge'
	exe g:Safety.'s/^\s*>\(.*\)</'.g:FountainWiki_Centered_Indent.'>\1</ge'
	exe g:Safety.'s/^\s*(\(.*\))$/'.g:FountainWiki_Parenthetical_Indent.'(\1)/ge'
	" The range 't,$ protects the Fountain title page block; if there is
	" no title page block, the first line will probably be a header that
	" doesn't need to be indented anyway.
	exe '%s/^\s*\(\.\|INT\.\|EXT\.\|INT \|EXT \|INT\/\|I\/E \)/\1/ge'
	" Fix section headers mistaken for character names.
	exe '%s/^\s*$//ge'
	" Remove accidental tabs/spaces from otherwise blank lines.
	normal 'v
	" We return the user to the spot where he began.
endfunction

function FountainHeaderDown()
	" Move header down (add one #, no more than six)
	exe '.s/^\(\s*\)\(#*\)\(\s*\)/\1\2# /ge'
	exe '.s/#\{7\}/######/ge'
endfunction

function FountainHeaderUp()
	" Move header up (remove one #)
	exe '.s/^\(\s*\)\(#\s*\)/\1/ge'
endfunction

function FountainWikiCards()
	" This opens a FountainWikiWord if there's a match.
	set noignorecase
	" Searches are case-sensitive.
	if g:FountainWiki_Card_Extension == "wiki" && exists("g:wiki.path")
		let g:wiki.path = expand("%:p:h")
	elseif g:FountainWiki_Card_Extension == "wiki"
		let wiki = {}
		let g:wiki.path = expand("%:p:h")
	endif
	" We temporarily hijack Vimwiki's home path, if applicable.
	if g:FountainWiki_Card_Only < 1 && g:FountainWiki_Card_StayOpen < 1
		only
	endif
	" If using the sidebar option, we close all windows but the screenplay
	" before opening the sidebar. The use of the word 'card' throughout
	" reflects the original idea of making 'index cards' open in the
	" sidebar. It soon became clear that following the wiki model makes
	" more sense. So 'card' is short for 'wiki reference file'.
	let g:Text = getline('.')
	" We grab the current line and begin evaluating it for the presence of
	" a FountainWikiWord.
	let g:Text = substitute(g:Text,"^\s*","","g")
	" We remove spaces, as they have no bearing on identifying
	" FountainWikiWord.
	if g:Text =~ "[["
		let g:Comment = substitute(g:Text,".*\\[\\[\\(.*\\)\\]\\].*","\\1","g")
		let g:Comment = substitute(g:Text,"\\A*","","g")
		let g:Section = g:Comment
		let g:Character = g:Comment
		" If the string contains [[, good bet it's a comment!
	else
		let g:Comment = ""
		let g:Character = substitute(g:Text,"\\U*","","g")
		let g:Section = substitute(g:Text,"\\A*","","g")
		" Definitely not a comment, but it might be a character name
		" or section header.
	endif
	if ( g:Character == g:Section || matchstr(g:Text,"^#") == "#" ) && g:Text != ""
		" If the string passes the first test, it's a
		" FountainWikiWord. If the string fails the first test, but
		" begins with a hashmark, it's a section header
		" FountainWikiWord. If the string is blank, we toss it out.
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
			exe 'vertical resize '.g:FountainWiki_Card_Width
			" We open the card/wiki file, in place of the
			" screenplay, or as a 'sidebar' window, on the right
			" or left, and resize if desired.
		endif
	endif
endfunction

function ScreenplayHome()
	" This is a function for navigation.
	let g:FountainWiki_Home = substitute(expand("%:p")," ","\\\\ ","g")
	let g:FountainWiki_Path = expand("%:p:h")
	" We record the position of the current Fountain doc.
	exe 'command! FountainWiki e '.g:FountainWiki_Home
	exe 'command! FW e '.g:FountainWiki_Home
	exe 'command! FnScreenplay e '.g:FountainWiki_Home
	" Command(s) for returning to the last screenplay doc, from anywhere.
	if g:FountainWiki_Card_Extension != "wiki" && g:FountainWiki_Card_Extension != "viki" && g:FountainWiki_Card_Extension != "fountain" 
		" We grant Vimwiki-like powers to text files
		exe 'au BufRead,BufWrite,BufNewFile '.g:FountainWiki_Path.'/*.'.g:FountainWiki_Card_Extension.' nnoremap <buffer> <backspace> <c-o>'
		exe 'au BufRead,BufWrite '.g:FountainWiki_Path.'/*.'.g:FountainWiki_Card_Extension.' map <buffer> <cr> <esc>:call SpecialLink()<cr>'
	endif
endfunction

function SpecialLink()
	" Wikifies file links in non-wiki files.
	let g:FnCheck = expand("<cfile>")
	if  g:FnCheck =~ '.'.g:FountainWiki_Card_Extension
		e <cfile>
	else
		echo 'Link must be filetype "'.g:FountainWiki_Card_Extension.'"'
	endif
endfunction

if g:FountainWiki_Card_Extension == "wiki"
	" Special adjustments for Vimwiki integration.
	if exists("g:wiki.path")
		exe 'command! FnReset let g:wiki.path = "'.g:wiki.path.'"'
	else
		command! FnReset echo "No wiki reset required." 
	endif
	nnoremap <leader>ww <esc>:FnReset<cr>:VimwikiIndex<cr>
	nnoremap <leader>wt <esc>:FnReset<cr>:VimwikiTabIndex<cr>
	nnoremap <leader>w<leader>w <esc>:FnReset<cr>:VimwikiMakeDiaryNote<cr>
	" This resets Vimwiki home to its original value, so that <leader>ww
	" results in the expected behavior.
	au FileType fountain,spmd map <buffer> <backspace> <esc>:FnReset<cr>:VimwikiIndex<cr>
	" If you press 'backspace' in your Fountain doc, we reset Vimwiki home
	" to original value and send you there.
endif

"}}}

"{{{ Define commands and do stuff

" Indentation commands, restricted to Fountain files except where otherwise
" noted.
au BufWrite *.fountain,*.spmd silent call FountainWikiIndent()
" Makes indentation automatic on saving
command FountainDisableAutoIndent au! BufWrite *.fountain,*.spmd
command FnOff au! BufWrite *.fountain,*.spmd
" Turn auto indent off
command FountainEnableAutoIndent au BufWrite *.fountain,*.spmd silent call FountainWikiIndent()
command FnOn au BufWrite *.fountain,*.spmd silent call FountainWikiIndent()
" Turn auto indent back on
au FileType fountain,spmd nnoremap <buffer> <c-cr> <esc>:call FountainWikiIndent()<cr>
" CTRL-ENTER indentation shortcut, indents without saving.
command FountainIndent silent call FountainWikiIndent()
command FnIndent silent call FountainWikiIndent()
" Global-use indentation command

" Wiki commands
command FnJump wincmd w
command FnLink silent call FountainWikiCards()
command FnSublink e <cfile>
au FileType fountain,spmd nnoremap <buffer> <cr> <esc>:silent call FountainWikiCards()<cr>

" Vimwiki-like header mapping
au FileType fountain,spmd nnoremap <buffer> = <esc>:call FountainHeaderDown()<cr>
au FileType fountain,spmd nnoremap <buffer> - <esc>:call FountainHeaderUp()<cr>

" Set the latest opened Fountain screenplay as the 'home' screenplay.
au BufWinEnter *.fountain,*.spmd silent call ScreenplayHome()
" Get navigation help.
exe 'nnoremap <backspace><backspace> <esc>:FnScreenplay<cr>'
" Double-backspace guides you back to last open Fountain doc.

" Quick uppercase shift
au FileType fountain,spmd inoremap <buffer> <s-cr> <esc>gUU$a<cr>
au FileType fountain,spmd nnoremap <buffer> <s-cr> gUU$

"}}}
