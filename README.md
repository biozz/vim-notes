# notes.vim

`notes.vim` is an opinionated solution to manage notes in a roam-research-like way.

The approach is inspired by [PARA](https://fortelabs.co/blog/para/) method and wiki-notation markdown links.

Table of contents:

<!-- vim-markdown-toc GFM -->

* [Requirements](#requirements)
* [Installation](#installation)
  * [vim-plug](#vim-plug)
* [Usage](#usage)
* [Limitations](#limitations)
* [Configuration](#configuration)
* [File types](#file-types)
  * [Resource](#resource)
  * [Drawer](#drawer)
  * [Person](#person)
  * [Inbox](#inbox)
* [Backlinks](#backlinks)
* [Auto-completion](#auto-completion)
* [Contributing](#contributing)
* [License](#license)

<!-- vim-markdown-toc -->

## Requirements

There are no specific requirements for basic usage, only a recent version of Vim (or its flavor).

If you want to use `:Backlinks` command:

- [`fzf`](https://github.com/junegunn/fzf.vim)
- [the_silver_searcher](https://github.com/ggreer/the_silver_searcher/)

## Installation

### vim-plug

Add this to your `.vimrc`:

```vimscript
Plug 'biozz/vim-notes'
```

More information at [vim-plug](https://github.com/junegunn/vim-plug).

## Usage

The following commands are available:

- `:Notes` - initializes notes in the current vim instance by adding all markdown files to vim's `path`, so they can be navigated with [`gf`](https://vim.fandom.com/wiki/Open_file_under_cursor) when standing on a `[[link]]`
- `:Journal` - creates and/or opens today's journal file (like in [Obsidian.md](https://obsidian.md/))
- `:Resource` - creates and/or opens [`resource`](#resource) file for editing
- `:Drawer` - creates and/or opens [`drawer`](#drawer) file
- `:Person` - creates [`person`](#person) file
- `:Backlinks` - searches for `[[current_file_name]]` references in `path`
- `:Inbox` - creates [`inbox`](#inbox) file
- `:RandomNote` - opens random note for editing (good for reviewing old notes)

There are no default key bindings, you should configure them by yourself. Here is an example:

```vim
nnoremap <leader>N :Notes<CR>
```

## Limitations

- file navigation with `gf` works only if your wiki-links are single words

```
[[my awesome link]]
  └── if your cursor is here, then it will
      try to open my.md and not "my awesome link.md"
```

## Configuration

The following configuration options are available:

- `g:notes_home` - notes root directory, default is `~/Notes/`
- `g:notes_auto_init` - calls `:Notes` command if current directory is the same as `g:notes_home`, default is `1` (enabled)
- `g:notes_init_prompt` - display initialization help messages or not, default is `1` (enabled)
- `g:notes_journal_dir` - where to store journal files, default is `journal/`
- `g:notes_journal_file_name` - how to name journal files, default is `%Y_%m_%d` (`.md` extension is always added), formatted with [strftime](https://strftime.org/)
- `g:notes_date_format` - what format to use in `completed_at` and `discovered_at` dates in [`drawer`](#drawer) files, default is `%Y-%m-%d`, formatted with [strftime](https://strftime.org/)
- `g:notes_resources_dir` - where to store resource files, default is `3_resources/`
- `g:notes_drawer_dir` - where to store [`drawer`](#drawer) files, default is `drawer/`
- `g:notes_drawer_file_name_prefix` - this will be prepended to all files inside `g:notes_drawer_dir`, default is `drawer_`
- `g:notes_people_dir` - where to store [`person`](#person) files, default is `people/` inside `g:notes_resources_dir`
- `g:notes_inbox_dir` - where to store [`inbox`](#inbox) files, default is `inbox/` inside `g:notes_home`
- `g:notes_inbox_file_name` - how to name [`inbox`](#inbox) files, default is `%Y-%m-%d-%H-%M-%S` (`.md` extension is always added), formatted with [strftime](https://strftime.org/)

_Note: all `_dir` variables must end with a trailing slash_

Example:

```vimscript
" notes.vim config
let g:notes_home = "~/my_notes/"
let g:notes_journal_dir = "my_journal/"
let g:notes_journal_file_name = "journal-%Y-%m-%d"
let g:notes_date_format = "%Y-%m-%d"
```

## File types

notes.vim has a concept of a file type. The actual file type is always `.md` and this is just a collection of rules to organize notes.

### Resource

Resource is a what goes into "R" in [PARA](https://fortelabs.co/blog/para/). By default resources are stored in `3_resources` directory.

Resource files have title only, there is no special metadata

### Drawer

Drawer file type combines a set of rules to store bits of information you discover on a regular basis.

Drawer files by default are stored in a `drawer` directory inside `3_resources` and named `drawer_<slug>.md`.

Drawer files have metadata (front-matter), which can be used to analyze how many bits of information you processed over time.

```
---
type: repository
url: "https://github.com/jamesroutley/24a2"
discovered_at: 2020-06-28
completed_at: 2020-07-01
---
```

### Person

Person files are like contact entries, but with more notes. Basically this is a regular [`resource`](#resource) but in a separate folder with some metadata.

### Inbox

Inbox files are for quick bits that you want to add, but still don't know where to properly place them.

The idea behind default file name format for inbox files comes from [GitJournal](https://github.com/GitJournal/GitJournal), because I use it on my phone.

## Backlinks

This is a simple custom `fzf` function based on [the_silver_searcher](https://github.com/ggreer/the_silver_searcher/). It wraps the current file name with `[[ ]]` and displays search results, which can further be limited down.

## Auto-completion

This plugin exposes `NotesCompleteFilename` function, which is automatically enabled for all markdown files in `g:notes_home` via `set completefunc` and `set omnifunc`. The default mapping is `<CTRL-X> <CTRL-O>`.

It uses system's `find` command with a couple of `sed`. The base of `find` is inspired by `fzf-complete-file` with an addition of file extension removal.

## Contributing

There are no particular rules. Feel free to open an issue or start a discussion.

## License

Copyright (c) Ivan Elfimov. Published under MIT license.
