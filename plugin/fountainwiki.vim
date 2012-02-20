" Vim plugin for Fountain screenplay files 
" Plugin Name:	FountainWiki & Indentation
" Version:	1.1 
" Last Change:	2012 Feb 20
" Reference: 	http://fountain.io/
" Maintainer:	Carson Fire <carsonfire@gmail.com>
"
" OVERVIEW
" ========
" Plugin offers light wikification of Fountain files plus indentation.
"
" FountainWiki turns CHARACTER NAMES, ## section heads and [[comments]] into
" automatic WikiWords. Simply press 'enter', and a new file opens for keeping
" notes.
"
" This also creates a portal from Fountain files to powerful tools like
" VimWiki, simply by defining the kind of notes you want to keep.
"
" The indentation is not automatic as you type, but we include optional
" automatic indentation upon saving, or by hitting 'ctrl+enter'. Use with the
" Fountain syntax file for best results.
"
" http://www.vim.org/scripts/script.php?script_id=3880
"
" INSTALLATION
" ============
" Just slip the ol' plugin file into your plugin folder. Adjust your vimrc
" file (:e $MYVIMRC) with appropriate options, below.
"
" QUICK HELP
" ==========
" When in a Fountain document, type '?' in normal mode for help.
"
" FOUNTAINWIKI
" ============
" The purpose of FountainWiki is to provide a note-taking facility that does
" not require any deviation from strict Fountain syntax.
"
" Operation is simple, and intended to emulate existing behavior of popular
" Vim plugins Voom and VimWiki. Instead of remembering a tricky shortcut, you
" simply move your cursor to a character line or scene header, or a line that
" is or contains a comment, and press *enter*. A wiki file opens as a
" sidebar to your script; either a new virtual file, or pre-existing notes.
" Once you have saved that file, use *tab* to move between the two files. If
" your wiki filetype uses tab, try ctrl+tab.
"
" FOUNTAINWIKI OPTIONS - NAMING FILES 
" -----------------------------------
" If nothing else, define the extension of your wiki files!
"
"		let g:FountainWiki_Card_Extension = 'txt'
"  
" This is already set to 'txt' by default, because text files are ubiquitous.
" However, consider using a file type with more power: Markdown is a good
" choice, since Fountain is essentially a companion syntax. With Markdown, you
" get the same kind of headers, plus lists and more.
"
" Want a metric ton more wiki power? Set your extension to 'wiki' and install
" VimWiki.
"
" VimWiki - http://www.vim.org/scripts/script.php?script_id=2226
"
" Now your wiki files become full wikis in their own right; type
" WikiWords within the wiki files in order to branch out to more notes in
" the sidebar; hit 'backspace' to return, etc. Type :VimwikiSearch /pattern/
" to search through all your notes!
"
" There's always a catch: regardless what file type you choose now, you need
" to keep your notes together with your screenplay in the same directory. And
" if you decide to change filetypes in mid-stream, the fix is up to you. To
" keep your old notes, you would need to change the existing extensions, and
" do whatever you need to do to convert your text.
"
" Since FountainWiki files use a token, you can use Renamer to batch an
" extension change with this command (example given, change to extension
" 'new'):
"
" 		:%s/\(.*\)\.fnx\.\(.*\)/\1.fnx.new/ge
"
" Renamer - http://www.vim.org/scripts/script.php?script_id=1721
"
" Another decision you'll want to make early on is whether or not to allow
" uppercase letters in your filenames. Set to 0 to turn off lowercase-only
" filenames. Default setting is 1, lowercase-only.
"
"		let g:FountainWiki_Lowercase_Filename = 0
"
" Default behavior: a character named BILLY BOB creates a file named
" 'billybob.fnx.txt'. Allow uppercase for 'BILLYBOB.fnx.txt'.
"
" Default behavior: section header '# Hero in Portland' becomes
" 'heroinportland.fnx.txt'. Set to uppercase for 'HeroinPortland.fnx.txt'.
" 
" Special characters are simply stripped out. 'BJÖRN' becomes 'bjrn.fnx.txt'.
" 'PAVLOV'S DOG' becomes 'pavlovsdog.fnx.txt'.
"
" FountainWiki does not truncate strings, unless it finds a natural linebreak;
" too-long filenames can result, and will be treated by your system in
" whatever way your system treats too-long filenames. 
"
"		let g:FountainWiki_Filename_Token = '.fnx'
"
" This is a token that can be inserted so that the files can be distinguished
" from other files in the same directory.
"
" FOUNTAINWIKI OPTIONS - ENVIRONMENT
" ----------------------------------
" You can adjust the width the wiki file opens:
"
"		let g:FountainWiki_Card_Width = 48
"
" If you prefer for the wiki file to open on the right instead of the left:
"
"		let g:FountainWiki_Card_Right = 1
" 
" By default, all windows but your Fountain screenplay and wiki file are
" closed. If you prefer to leave everything open and manually close files
" yourself, you can do this -- but be warned, it gets messy fast!
"
"		let g:FountainWiki_Card_StayOpen = 1
"
" FOUNTAIN INDENTATION
" ====================
" Indent Fountain files three different ways:
"
"		* Automatically, when saving the file.
"		* Hit 'enter' while in normal mode.
"		* Use the command :FountainWikiIndent
"
" To temporarily disable automatic indentation, use the command
"
" 		:FountainWikiDisableAuto
" 
" To turn it back on, type :FountainWikiEnableAuto		
"
" A NOTE ABOUT DIALOGUE
" ---------------------
" While characters and parentheticals are indented, dialogue is not, and for
" good reason.
"
" To properly indent an entire block, we would have to introduce line breaks.
" That's a no-no. Such line breaks will likely corrupt subsequent format
" conversion (we tested this in Screenplain; it does).
"
" And if we don't go whole hog and completely reformat your script for you,
" *one* indent at the beginning of long dialogue blocks creates an indented
" *paragraph*, and completely destroys the screenplay 'look'.
"
" Use the Fountain syntax file to help highlight dialogue from action.
"
" FOUNTAIN INDENTATION OPTIONS
" ----------------------------
" To turn off auto indent, set to '0'. The default is 1:
"
"		let g:FountainWiki_Auto_Indent = 0
"
" FOUNTAIN INDENTATION TWEAKS
" ---------------------------
" You can tweak the indentation itself.
"
" Indentation for characters and parentheticals are set to one tab and two,
" respectively. To adjust the look you want, set the tabstop preference. This
" is set independently from other files in your buffer. '8' is the default
" setting, since we're emulating the look of a screenplay, and not dealing
" with any nesting.
"
"		let g:FountainWiki_Tabstop = '8'
"
" Transitions and centered text can be a little trickier, especially if you
" change the default tabstop. Use these variables to adjust the number of
" tabs; shown here are the default number. 
"
" 		let g:FountainWiki_Transition_Indent = '\t\t\t\t\t\t\t'
" 		let g:FountainWiki_Centered_Indent = '\t\t\t'
"
" MAPPING FOUNTAINWIKI
" ====================
" There are a few commands you might wish to map.
"
" :FountainWikiCursorJump    Tabs between Fountain screenplay and wiki file.
"                            This is already mapped to 'tab', but may be
"                            overruled by other mappings.
" :FountainWikiDisableAuto   Overrules default auto indentation.
" :FountainWikiEnableAuto    Turns auto indentation on.
" :FountainWikiIndent        On call indentation.
" :FountainWikiCards         Create wiki file from text under cursor.
" :FountainWikiHelp          Prints out a quick reminder of commands
"
" Default mapping is intended to emulate existing Vim plugins, particularly
" Voom and VimWiki, and should only apply to Fountain files and the wiki
" filetype you choose. The latter filetype will bring aboard its own mappings
" and shortcuts, which is where most conflicts should arise.
" 
" TODO Some method of listing and/or indicating the existence of related wiki
" files--without interfering with Fountain syntax.

function FountainWikiIndent()
	normal mvgg}mt
	't,$s/^\s*//ge
	exe '%s/\(.*\) TO:$/'.g:FountainWiki_Transition_Indent.'\1 TO:/ge'
	exe '%s/^> \(.*\)$/'.g:FountainWiki_Transition_Indent.'> \1/ge'
	exe '%s/^\s*>\(.*\)</'.g:FountainWiki_Centered_Indent.'>\1</ge'
	't,$s/^(\(.*\))$/\t(\1)/ge
	't,$s/^\(\L*\)$/\t\t\1/ge
	't,$s/^\s*\(\.\|INT\. \|EXT\. \|INT\.\/EXT\. \|INT\/EXT\. \|INT \|EXT \|INT\/EXT \|I\/E \|int\. \|ext\. \|int\.\/ext\. \|int\/ext\. \|int \|ext \|int\/ext \|i\/e \)/\1/ge
	't,$s/^\s*$//ge
	normal 'v
endfunction

function FountainWikiCards()
	set noignorecase
	if g:FountainWiki_Card_StayOpen < 1
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
		exe 'vsplit '.g:Section.g:FountainWiki_Filename_Token.'.'.g:FountainWiki_Card_Extension
		if g:FountainWiki_Card_Right > 0
			wincmd r
		endif
		exe 'vertical resize '.g:FountainWiki_Card_Width
	endif
endfunction

function FountainWikiHelp()
	echo "     "
	echo "          Quick help for FountainWiki & Indentation"
	echo "     ==================================================="
	echo "     Auto indent              :w (save file)"
	echo "     Manual indent            ctrl-enter"
	echo "     ----------------------------------------------------"
	echo "     Open/create reference*   enter, on FountainWikiWords"
	echo "     Close reference          enter, anywhere else"
	echo "     FountainWikiWords        CHARACTER NAMES"
	echo "                              ## Section headers"
	echo "                              [[And notes]]"
	echo "     Switch focus             <tab> (on either file)"
	echo "     "
	echo "     ----------------VOOM (IF INSTALLED)-----------------"
	echo "     Outline                  :Voom markdown"
	echo "     Select section           <cr> (enter)"
	echo "     Switch focus only        <tab>"
	echo "     Move section up/down     <c-up/down> (ctrl-up/down)"
	echo "     "
	echo "     -------------------- NATIVE VIM---------------------"
	echo "     Change entire character line to uppercase        gUU"
	echo "     "
endfunction

if !exists('FountainWiki_Auto_Indent')
	let FountainWiki_Auto_Indent = 1
endif
if !exists('FountainWiki_Tabstop')
	let FountainWiki_Tabstop = 8
endif
if !exists('FountainWiki_Textwidth')
	let FountainWiki_Textwidth = 0
endif
if !exists('FountainWiki_Transition_Indent')
	let FountainWiki_Transition_Indent = '\t\t\t\t'
endif
if !exists('FountainWiki_Centered_Indent')
	let FountainWiki_Centered_Indent = '\t\t\t'
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
if !exists('FountainWiki_Lowercase_Filename')
	let FountainWiki_Lowercase_Filename = 1
endif
if !exists('FountainWiki_Filename_Token')
	let FountainWiki_Filename_Token = '.fnx'
endif
if !exists('FountainWiki_Card_StayOpen')
	let FountainWiki_Card_StayOpen = 0
endif

command FountainWikiCursorJump wincmd w
command FountainWikiDisableAuto au! BufWrite *.fountain,*.spmd
command FountainWikiEnableAuto au BufWrite *.fountain,*.spmd silent call FountainWikiIndent()
command FountainWikiIndent silent call FountainWikiIndent()
au BufWrite *.fountain,*.spmd FountainWikiIndent
au BufWrite *.fountain,*.spmd FountainWikiCursorJump
au BufRead *.fountain,*.spmd nnoremap <buffer> <c-cr> <esc>:FountainWikiIndent<cr>
command FountainWikiCards silent call FountainWikiCards()
au BufRead *.fountain,*.spmd nnoremap <buffer> <cr> <esc>:FountainWikiCards<cr>
command FountainWikiHelp call FountainWikiHelp()
au BufRead *.fountain,*.spmd nnoremap <buffer> ? <esc>:FountainWikiHelp<cr>
exe 'au BufRead *.fountain,*.spmd set tw='.g:FountainWiki_Textwidth
exe 'au BufRead *.fountain,*.spmd set tabstop='.g:FountainWiki_Tabstop 
exe 'au BufRead *.fountain,*.spmd,*'.g:FountainWiki_Filename_Token.g:FountainWiki_Card_Extension.' nnoremap <buffer> <tab> <c-w>w'

