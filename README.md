# Neovim 0.12+ Config (by drone)

A minimal, single-file `init.lua` setup for Neovim 0.12+, leveraging native package management (`vim.pack`) and a curated suite of modern plugins.

![Neovim](https://img.shields.io/badge/Neovim-0.12+-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

---

## 📋 Requirements

* **Neovim 0.12** or newer (required for `vim.pack` API)
* **`git`** installed and available in your `PATH`
* **[Nerd Font](https://www.nerdfonts.com/font-downloads)** — for icons in `lualine`, `oil.nvim`, `telescope`
* **`ripgrep` (`rg`)** — for `telescope live_grep` functionality
* **Node.js** — for installing formatters (`prettier`, `eslint`) via Mason

---

## ✨ Configuration Highlights

### 🗂 Architecture
| Feature | Description |
|---------|-------------|
| **Native `vim.pack`** | No external plugin managers (lazy/packer). Plugins registered via `vim.pack.add()` and auto-loaded |
| **Single-file setup** | Entire config lives in `init.lua` — easy to copy, version, and port |
| **Deferred initialization** | Heavy plugins (LSP, UI) initialize on `VimEnter` event for faster startup |
| **Safe loading** | `pcall()` guards for optional plugins (e.g., `conform.nvim`) |
| **TypeScript/JS-first** | Priority support for TS/JS/React via treesitter, LSP, and Prettier |

### ⚙️ Behavior & Interface
```lua
-- Leader key: space
-- Arrow keys disabled in normal mode (encourages hjkl navigation)
-- relative number + cursorline for better navigation
-- Auto-write on focus loss (autowrite)
-- Color column at 80 characters
-- Tabs = 2 spaces, always expanded to spaces
-- True color support in terminal (termguicolors)
```

### 🎨 Visual Enhancements
* **Gruvbox** theme with transparent background (`transparent_mode = true`)
* **Indent-blankline** with `│` character for visual indentation guides
* **NoNeckPain** — centers the editor (width: 160), reduces eye strain
* **Lualine** — minimal statusline showing current file path
* **Treesitter-context** — displays function/class context in top line

---

## 🔌 Plugins Overview

### 🎨 UI / Navigation
| Plugin | Purpose | Keybinding / Note |
|--------|---------|------------------|
| `nvim-web-devicons` | Filetype icons | Dependency for lualine/oil |
| `lualine.nvim` | Statusline | Auto-loaded after VimEnter |
| `oil.nvim` | File explorer (vim-style) | `-` — open current directory |
| `no-neck-pain.nvim` | Editor centering | `<c-_>` — toggle |
| `indent-blankline.nvim` | Indentation guides | Auto-configured via `ibl` |
| `undotree` | Undo history visualization | `<leader>u` — toggle |
| `trouble.nvim` | Diagnostics/errors list | `<leader>d` — show float diagnostic |

### 🔀 Git
| Plugin | Purpose |
|--------|---------|
| `vim-fugitive` | Full Git integration: `:G`, `:Git`, `:Gdiff`, etc. |

### 🧠 Completion & LSP Stack
| Plugin | Purpose |
|--------|---------|
| `nvim-cmp` | Completion engine |
| `cmp-nvim-lsp` | LSP source for cmp |
| `mason.nvim` | Package manager for LSP servers & tools |
| `mason-lspconfig.nvim` | Bridge between Mason and nvim-lspconfig |
| `nvim-lspconfig` | LSP client configurations |
| `conform.nvim` | Code formatting (Prettier, stylua) |

**Supported LSP servers (auto-installed via Mason):**
```
lua_ls, basedpyright, rust_analyzer, emmet_ls, 
eslint, ts_ls, tailwindcss, gopls
```

**Formatting rules (conform.nvim):**
```lua
-- Auto-format on save + manual via <space>f
javascript, typescript, jsx, tsx → prettier
css, html, json, yaml, markdown    → prettier
lua                               → stylua (if installed)
```

### 🔍 Search & Navigation
| Plugin | Purpose | Keybindings |
|--------|---------|-------------|
| `telescope.nvim` + `plenary` | Fuzzy finder for files, text, help | `<Space><Space>` — recent files<br>`<Space>ff` — find files<br>`<Space>fg` — live grep<br>`<Space>fh` — help tags |
| `harpoon` (v2) | Quick bookmarks for 4 files | `<leader>a` — add file<br>`<C-e>` — toggle menu<br>`<C-h/j/k/l>` — jump to slot 1/2/3/4<br>`<C-S-P>/<C-S-N>` — prev/next |

### 🌳 Syntax & Parsing
| Plugin | Purpose |
|--------|---------|
| `nvim-treesitter` | Syntax highlighting, auto-install parsers |
| `nvim-treesitter-context` | Show function/class context in top line |

**Auto-installed language parsers:**
```
javascript, typescript, python, c, lua, vim, vimdoc, query, go
```

---

## ⌨️ Keybindings Reference

### Navigation & Windows
```vim
<C-h/j/k/l>  — navigate between windows (splits)
<leader>a    — add file to Harpoon
<C-e>        — open Harpoon menu
<C-h/j/k/l>  — jump to Harpoon slot 1/2/3/4
<Space><Space> — recent files (Telescope)
<Space>ff    — find file
<Space>fg    — live grep content
-            — open oil.nvim (file explorer)
```

### Editing & Search
```vim
<leader>h    — clear search highlight
n/N          — next/prev search result (centered)
<C-d>/<C-u>  — half-page down/up (centered)
<leader>s    — substitute word under cursor in file
<leader>x    — make file executable (!chmod +x %)
<Space>f     — format file (conform + lsp fallback)
```

### LSP & Diagnostics
```vim
gd           — go to definition
gr           — find references
<leader>y    — show diagnostic in float window
```

### Buffer & Selection
```vim
<C-c> (insert)  — exit to normal mode
<leader>p (visual) — paste without yanking to register
<leader>d (n/v)  — delete to black hole (don't pollute register)
<space>y - copy selection to system clipboard (middle mouse button to paste)
<space>Y - copy whole file to system clipboard (middle mouse button to paste)
```

### Utilities
```vim
<leader>u    — toggle Undotree
<Space>fh    — search help tags
```

---

## 🚀 Installation & First Run

1. **Clone or create config**:
   ```bash
   mkdir -p ~/.config/nvim
   cp init.lua ~/.config/nvim/
   ```

2. **Launch Neovim**:
   ```bash
   nvim
   ```

3. **Wait for auto-install**: Plugins clone to `~/.local/share/nvim/site/pack/` on first run

4. **Install LSP servers & formatters via Mason**:
   ```vim
   :MasonInstall lua_ls basedpyright gopls prettier stylua
   ```

5. **Install Treesitter parsers**:
   ```vim
   :TSInstall javascript typescript lua go python
   ```

> 💡 **Tip**: If plugins fail to load, verify `git` is in PATH and you have internet access on first launch.

---

## 🔧 Customization Guide

### Add a new plugin
```lua
vim.pack.add({
  { src = "https://github.com/username/plugin.nvim", main = "plugin" },
})
```

### Modify LSP settings
Find the `mason-lspconfig` block inside `VimEnter` and extend:
```lua
gopls = function()
  vim.lsp.config("gopls", {
    capabilities = capabilities,
    settings = {
      gopls = {
        analyses = { unusedparams = true },
      },
    },
  })
end,
```

### Disable auto-format on save
```lua
format_on_save = false,  -- in conform.setup()
```

### Change colorscheme
Replace `gruvbox` with any other theme:
```lua
require("other_theme").setup()
vim.cmd("colorscheme other_theme")
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Plugins not loading | Check `git --version` and internet connectivity |
| Missing icons in statusline | Install & configure a [Nerd Font](https://www.nerdfonts.com/font-downloads) in your terminal |
| LSP not working | Run `:MasonInstall <server>` and restart Neovim |
| Prettier not formatting | Ensure Prettier is globally installed: `npm install -g prettier` |
| Telescope can't find files | Install ripgrep: `brew install ripgrep` / `sudo apt install ripgrep` |
| Slow startup | Consider lazy-loading heavy plugins or reducing `ensure_installed` lists |

---

## 📦 Directory Structure (after first run)
```
~/.local/share/nvim/site/pack/
├── opt/          → plugins installed via vim.pack
└── start/        → auto-loaded plugins (if any)

~/.cache/nvim/    → treesitter cache, lsp logs
~/.state/nvim/    → session state, harpoon markers
```

---

## 🧭 Philosophy

> Minimalism. Control. Speed.

No heavy frameworks — only what you need, loaded only when you need it.

---

## 🤝 Contributing

Found a bug? Have a suggestion? Feel free to open an issue or PR.

---

## 📄 License

MIT — feel free to use, modify, and distribute.

---

> 💡 **Pro tip**: Run `:checkhealth` and `:messages` for debugging.  
> This config requires **Neovim 0.12+** — `vim.pack` is not available in earlier versions.
