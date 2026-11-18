# nvim-config

A Neovim IDE configuration for Go, Rust and TypeScript, tuned for a French AZERTY (Mac) keyboard: `Space` leader, language servers installed on demand, Treesitter highlighting, fuzzy search and format on save.

## Installation

```sh
git clone https://github.com/jkuma/nvim-config.git ~/Projects/nvim-config
~/Projects/nvim-config/install.sh
nvim
```

`install.sh` symlinks the repo to `~/.config/nvim` (an existing config is kept as `.bak`), so changes made to the config land directly in the repo.

The first launch installs the plugins, language servers, formatters and Treesitter parsers. Plugin versions are pinned in `lazy-lock.json`; `:Lazy update` moves them forward and rewrites the lock file.

## Requirements

- Neovim ≥ 0.12, git, curl, unzip, make and a C compiler
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) to build parsers
- [ripgrep](https://github.com/BurntSushi/ripgrep) and [fd](https://github.com/sharkdp/fd) for search
- npm for the TypeScript tooling
- Go, and Rust with `rustfmt`, `clippy` and the standard library sources
- A [Nerd Font](https://www.nerdfonts.com/) selected in the terminal
- Clipboard: `wl-copy` or `xclip`

On Arch Linux:

```sh
sudo pacman -S --needed neovim tree-sitter-cli ripgrep fd npm go rust rust-src ttf-jetbrains-mono-nerd
```

## Layout

| Path | Content |
|---|---|
| `init.lua` | Leader key, loads the modules below |
| `lua/config/` | Options, key bindings, autocommands, plugin manager bootstrap |
| `lua/plugins/` | One file per area: `ui`, `editor`, `treesitter`, `lsp`, `completion`, `format` |
| `after/ftplugin/` | Per-language settings |

## Languages

| Language | Server | Format on save |
|---|---|---|
| Go | gopls (staticcheck) | goimports, gofmt |
| Rust | rust-analyzer (clippy) | rustfmt |
| TypeScript, JavaScript | vtsls, eslint | prettierd when the project has a prettier config, else the language server |
| Lua | lua_ls | stylua |

## Key bindings

The leader is `Space`: press it and wait for a menu of every binding.

### French Mac AZERTY

`[` and `]` need AltGr+Shift on this layout, so `ç` and `à` stand in for them: `àd` / `çd` next / previous diagnostic, `àh` / `çh` hunk, `àb` / `çb` buffer, `àq` / `çq` quickfix item. `jk` leaves Insert mode.

### Search

| Binding | Action |
|---|---|
| `-` | File explorer on the current directory (edit names, then `:w`) |
| `Space e` | File tree on the left, opened on the current file |
| `Space Space` | Find files |
| `Space f g` / `f w` | Grep the project / the word under the cursor |
| `Space f b` / `f o` | Open buffers / recent files |
| `Space f d` / `f h` / `f k` | Diagnostics / help / key bindings |
| `Space f r` | Resume the last search |
| `Space f p` | Searches of the session, reopened with their results |
| `Ctrl-s` (in grep) | Cycle case: smart / sensitive / ignore |
| `Ctrl-↑` / `Ctrl-↓` (in a search) | Previous / next query, kept across sessions |

### Code

| Binding | Action |
|---|---|
| `K` | Hover documentation |
| `gd` / `gD` | Definition / declaration |
| `grr` / `gri` / `grt` | References / implementations / type definition |
| `gO` / `gW` | Document / workspace symbols |
| `grn` or `Space c r` | Rename |
| `gra` or `Space c a` | Code actions |
| `Space c d` | Diagnostic of the current line |
| `Space c f` | Format |
| `Space t f` / `t h` | Toggle format on save / inlay hints |

### Completion

| Binding | Action |
|---|---|
| `↓` / `↑` or `Ctrl-n` / `Ctrl-p` | Next / previous item |
| `Tab` | Accept the highlighted item, else jump to the next snippet field |
| `Shift-Tab` | Previous snippet field |
| `Ctrl-Space` / `Ctrl-e` | Open / close the menu |

### Git and windows

| Binding | Action |
|---|---|
| `Space g p` / `g s` / `g r` | Preview / stage / reset hunk |
| `Space g b` / `g d` | Blame line / diff file |
| `Ctrl-h/j/k/l` | Move between windows |
| `Space w` / `Space q` | Save / quit |
