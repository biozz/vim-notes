" Exit when the app has already been loaded (or "compatible" mode set)
if exists("g:loaded_notes") || &cp
  finish
endif
let g:loaded_notes = 1

" Configuration variables
let s:notes_home = "~/Notes/"
if exists("g:notes_home")
  if g:notes_home[-1] != "/"
    let g:notes_home = g:notes_home . "/"
  endif
  let s:notes_home = fnameescape(g:notes_home)
endif
let s:notes_auto_init = 1
if exists("g:notes_auto_init")
  let s:notes_auto_init = g:notes_auto_init
endif
let s:notes_init_prompt = 1
if exists("g:notes_init_prompt")
  let s:notes_init_prompt = g:notes_init_prompt
endif

let s:notes_journal_dir = "journal/"
if exists("g:notes_journal_dir")
  let s:notes_journal_dir = g:notes_journal_dir
endif
let s:notes_journal_file_name = "%Y_%m_%d"
if exists("g:notes_journal_file_name")
  let s:notes_journal_file_name = g:notes_journal_file_name
endif
let s:notes_date_format = "%Y-%m-%d"
if exists("g:notes_date_format")
  let s:notes_date_format = g:notes_date_format
endif
let s:notes_resources_dir = "3_resources/"
if exists("g:notes_resources_dir")
  let s:notes_resources_dir = g:notes_resources_dir
endif
let s:notes_drawer_dir = "3_resources/drawer/"
if exists("g:notes_drawer_dir")
  let s:notes_drawer_dir = g:notes_drawer_dir
endif
let s:notes_drawer_file_name_prefix = "drawer_"
if exists("g:notes_drawer_file_name_prefix")
  let s:notes_drawer_file_name_prefix = g:notes_drawer_file_name_prefix
endif
let s:notes_people_dir = "3_resources/people/"
if exists("g:notes_people_dir")
  let s:notes_people_dir = g:notes_people_dir
endif
let s:notes_inbox_dir = "inbox/"
if exists("g:notes_inbox_dir")
  let s:notes_inbox_dir = g:notes_inbox_dir
endif
let s:notes_inbox_file_name = "%Y-%m-%d-%H-%M-%S"
if exists("g:notes_inbox_file_name")
  let s:notes_inbox_file_name = g:notes_inbox_file_name
endif

" Constructed internal variables
let s:notes_journal_file_title = "# " . s:notes_date_format
let s:notes_journal_home = s:notes_home . s:notes_journal_dir
let s:notes_resources_home = s:notes_home . s:notes_resources_dir
let s:notes_drawer_home = s:notes_home . s:notes_drawer_dir
let s:notes_people_home = s:notes_home . s:notes_people_dir
let s:notes_inbox_home = s:notes_home . s:notes_inbox_dir

" Utility functions
function! s:createDirectoryIfNotExists(p)
  if !isdirectory(expand(a:p))
    call mkdir(expand(a:p))
    echomsg "Created new directory " . a:p
  endif
endfunction

function! NotesInit()
  call s:createDirectoryIfNotExists(s:notes_home)
  " Change current directory to "s:notes_home"
  exe "chdir " . s:notes_home
  " Extending path for "gf" to work properly for any file inside Notes
  " directory.
  exe "set path+=" . fnameescape(s:notes_home) . "**"
endfunction

" Create a file with "s:notes_journal_file_name" and
" "s:notes_journal_file_title" if doesn't exsit. Then open it for editing.
function! NotesJournal()
  call s:createDirectoryIfNotExists(s:notes_journal_home)
  let journal_file = strftime(s:notes_journal_file_name) . ".md"
  let journal_file_path = s:notes_journal_home . journal_file
  if !filereadable(expand(journal_file_path))
    call writefile([strftime(s:notes_journal_file_title)], expand(journal_file_path), "a")
  endif
  exe "e " . journal_file_path
endfunction

" Interactively create "resource" type file. Open the file if it exists
" already.
function! NotesResource()
  call s:createDirectoryIfNotExists(s:notes_resources_home)
  let slug = input("Slug: ")
  let resource_file_path = s:notes_resources_home . slug . ".md"
  let exists = filereadable(expand(resource_file_path))

  if exists
    exe "e " . resource_file_path
    return 1
  endif

  let title = input("Title: ")
  call writefile(["# " . title], expand(resource_file_path), "a")
  exe "e " . resource_file_path
endfunction

" Interactively create "person" type file. Open the file if it exists
" already.
function! NotesPerson()
  call s:createDirectoryIfNotExists(s:notes_people_home)
  let slug = input("Slug: ")
  let person_file_path = s:notes_people_home . slug . ".md"
  let exists = filereadable(expand(person_file_path))

  if exists
    exe "e " . person_file_path
    return 1
  endif

  let name = input("Name: ")
  let position = input("Position: ")
  let birthday = input("Birthday: ")
  call writefile([
        \ "---",
        \ "birthday: \"". birthday ."\"",
        \ "position: \"" . discovered_at . "\"",
        \ "---",
        \ "# " . name,
        \ ""
        \ ], expand(person_file_path), "a")
  exe "e " . person_file_path
endfunction

" Interactively create "drawer" type file. Open the file if it exists
" already.
function! NotesDrawer()
  call s:createDirectoryIfNotExists(s:notes_drawer_home)
  let slug = input("Slug: ")
  let drawer_file_path = s:notes_drawer_home . s:notes_drawer_file_name_prefix . slug . ".md"
  let exists = filereadable(expand(drawer_file_path))

  if exists
    exe "e " . drawer_file_path
    return 1
  endif

  let url = input("URL: ")
  let discovered_at = input("Discovered at: ")
  let default_completed_at = strftime(s:notes_date_format)
  let completed_at = input("Completed at (" . default_completed_at .  "): ")
  let title = input("Title: ")

  if completed_at == ""
    let completed_at = default_completed_at
  endif

  call writefile([
        \ "---",
        \ "url: " . url,
        \ "discovered_at: " . discovered_at,
        \ "completed_at: " . completed_at,
        \ "---",
        \ "# " . title,
        \ ""
        \ ], expand(drawer_file_path), "a")
  exe "e " . drawer_file_path

endfunction

" Create a file with "s:notes_inbox_file_name"
" if doesn't exsit. Then open it for editing.
function! NotesInbox()
  call s:createDirectoryIfNotExists(s:notes_inbox_home)
  let inbox_file = strftime(s:notes_inbox_file_name) . ".md"
  let inbox_file_path = s:notes_inbox_home . inbox_file
  if !filereadable(expand(inbox_file_path))
    call writefile([], expand(inbox_file_path), "a")
  endif
  exe "e " . inbox_file_path
endfunction

" Omnicompletion function for notes file names in g:notes_home directory
" To be used like this:
" set completefunc=NotesCompleteFilename
" set omnifunc=NotesCompleteFilename
function! NotesCompleteFilename(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\w'
      let start -= 1
    endwhile
    return start
  else
    " find months matching with "a:base"
    let res = []
    " this find command will list all files in the current directory
    " recursively
    " then it will remove directory path with first sed
    " and strip file extension with the second sed
    let cmd = "find " . g:notes_home . " -path '*/\.*' -prune -o -type f -print -o -type l -print | sed 's!.*/!!' | sed 's/\.[^.]*$//'"
    for m in split(system(cmd), '\n')
      if m =~ '^' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfunction

" Find random note file.
" Uses standard unix tools: find, sort, tail
" trim is for removing trailing / from notes_home path,
" otherwise it produces ugly paths like: ~/Notes//test.md
function! NotesRandomNote()
  exe "e " . system("find " . trim(g:notes_home, "/") . " -regex '.*\.md' | sort -R | tail -1")
endfunction

" Notes commands definition.
exe "command! Notes call NotesInit()"
exe "command! Journal call NotesJournal()"
exe "command! Resource call NotesResource()"
exe "command! Drawer call NotesDrawer()"
exe "command! Person call NotesPerson()"
exe "command! Inbox call NotesInbox()"
exe "command! RandomNote call NotesRandomNote()"

" Backlinks is a command which displays files
" linked to the current one based on file name
" expand("%:t:r") - get filename without extension
" \[\[...\]\] - wrap filename into double squer brackets
" pass it all to silver_searcher (ag)
command! -bang -nargs=* Backlinks call fzf#vim#ag('\[\['.expand("%:t:r").'\]\]')

augroup notes
  " This makes `gf` command autoappend `.md` and makes easier to navigate
  " [[links]]].
  exe "autocmd BufEnter,BufRead,BufNewFile " . s:notes_home . "*.md set includeexpr=v:fname.'.md'"
  " Normally I don't want wrapping, but notes are usually open in split screen
  " and it gets annoying without.
  exe "autocmd BufEnter,BufRead,BufNewFile " . s:notes_home . "*.md set wrap"
  " Enable completfunc/omnifunc for markdown files in notes directory
  exe "autocmd BufEnter,BufRead,BufNewFile " . s:notes_home . "*.md set completefunc=NotesCompleteFilename"
  exe "autocmd BufEnter,BufRead,BufNewFile " . s:notes_home . "*.md set omnifunc=NotesCompleteFilename"
augroup END

" Automatic init sequence
if fnameescape(getcwd() . "/") == s:notes_home
  if s:notes_auto_init
    call NotesInit()
    if s:notes_init_prompt
      echomsg "You are in Notes directory"
      echomsg "Notes initialized automatically, to disable add: let g:notes_auto_init = 0"
      echomsg "And let g:notes_init_prompt = 0 to hide this message"
    endif
  else
    if s:notes_init_prompt
      echomsg "You are in Notes directory, call :Notes to initialize"
      echomsg "or set g:notes_auto_init to 1 if you want this to be done automatically"
      echomsg "You can also disable this prompt: let g:notes_init_prompt = 0"
    endif
  endif
endif

if get(g:, 'notes_no_maps')
  finish
endif
