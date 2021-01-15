" Exit when the app has already been loaded (or "compatible" mode set)
if exists("g:loaded_notes") || &cp
  finish
endif
let g:loaded_notes = 1

" Configuration variables
let s:notes_home = "~/Notes/"
if exists("g:notes_home")
  let s:notes_home = g:notes_home
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

" Constructed internal variables
let s:notes_journal_file_title = "# " . s:notes_date_format
let s:notes_journal_home = s:notes_home . s:notes_journal_dir
let s:notes_resources_home = s:notes_home . s:notes_resources_dir
let s:notes_drawer_home = s:notes_home . s:notes_drawer_dir
let s:notes_people_home = s:notes_home . s:notes_people_dir

function! NotesInit()
  " Change current directory to "s:notes_home"
  exe "chdir " . s:notes_home
  " Extending path for "gf" to work properly for any file inside Notes
  " directory.
  exe "set path+=" . s:notes_home . "**"
endfunction

augroup notes
  " This makes `gf` command autoappend `.md` and makes easier to navigate
  " [[links]]].
  exe "autocmd BufEnter,BufRead,BufNewFile " . s:notes_home . "*.md set includeexpr=v:fname.'.md'"
  " Normally I don't want wrapping, but notes are usually open in split screen
  " and it gets annoying without.
  exe "autocmd BufEnter,BufRead,BufNewFile " . s:notes_home . "*.md set wrap"
augroup END

" Create a file with "s:notes_journal_file_name" and
" "s:notes_journal_file_title" if doesn't exsit. Then open it for editing.
function! NotesJournal()
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


" Notes commands definition.
exe "command! Notes call NotesInit()"
exe "command! Journal call NotesJournal()"
exe "command! Resource call NotesResource()"
exe "command! Drawer call NotesDrawer()"
exe "command! Person call NotesPerson()"

" expand("%:t:r") - get filename without extension
" \[\[...\]\] - wrap filename into double squer brackets
" pass it all to silver_searcher (ag)
command! -bang -nargs=* Backlinks call fzf#vim#ag('\[\['.expand("%:t:r").'\]\]')

if get(g:, 'notes_no_maps')
  finish
endif

" TODO: add default mappings
