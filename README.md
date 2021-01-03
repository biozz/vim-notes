# notes.vim

`notes.vim` is an opinionated solution to manage notes in a roam-research-like way.

The approach is inspired by [PARA](https://fortelabs.co/blog/para/) method and wiki-notation markdown links.

Table of contents:

- [notes.vim](#notesvim)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [vim-plug](#vim-plug)
  - [Usage](#usage)
  - [Limitations](#limitations)
  - [Configuration](#configuration)
  - [File types](#file-types)
    - [Resource](#resource)
    - [Drawer](#drawer)
    - [Person](#person)
  - [Roadmap](#roadmap)

## Requirements

A recent version of Vim (or its flavor). There are no external depencies for now, but I might add [`fzf`](https://github.com/junegunn/fzf.vim) at some point.

## Installation

### vim-plug

Add this to your `.vimrc`:

```vimscript
Plug 'biozz/vim-notes'
```

More information at [vim-plug](https://github.com/junegunn/vim-plug).

## Usage

Following commands are available:

- `:Notes` - initializes notes in the current vim instance by adding all markdown files to vim's `path`, so they can be navigated with [`gf`](https://vim.fandom.com/wiki/Open_file_under_cursor) when standing on a `[[link]]`
- `:Journal` - creates and/or opens today's journal file (like in [Obsidian.md](https://obsidian.md/))
- `:Resource` - creates and/or opens [`resource`](#resource) file for editing
- `:Drawer` - creates and/or opens [`drawer`](#drawer) file
- `:Person` - creates [`person`](#person) file

## Limitations

- file navigation with `gf` works only if your wiki-links are single words

```
[[my awesome link]]
  └── if your cursor is here, then it will
      try to open my.md and not "my awesome link.md"
```

## Configuration

Following configuration options are available:

- `g:notes_home` - notes root directory, default is `~/Notes/`, must end with trailing slash
- `g:notes_journal_dir` - where to store journal files, default is `journal/`, must end with trailing slash
- `g:notes_journal_file_name` - how to name journal files, default is `%Y_%m_%d` (`.md` extension is always added), formatted with [strftime](https://strftime.org/)
- `g:notes_date_format` - what format to use in `completed_at` and `discovered_at` dates in [`drawer`](#drawer) files, default is `%Y-%m-%d`, formatted with [strftime](https://strftime.org/)

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

## Roadmap

- [ ] Add `:Backlinks` command which uses `fzf` to list files which are linked to the current one
- [ ] Example script or jupyter notebook which builds statistics on [drawer](#drawer) files
- [ ] Provide more customization options (add all leftover variables)
- [ ] Provide a way to customize metadata options
- [ ] Add default key mappings