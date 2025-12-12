-- ==============================================================
-- Neovim 0.12+ init.lua (by drone)
-- ==============================================================

-- ============================================================================
-- 1. Плагины (только регистрация)
-- ============================================================================

--: UI & UX
vim.pack.add({
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
  { src = 'https://github.com/shortcuts/no-neck-pain.nvim' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim', main = 'ibl' },
  { src = 'https://github.com/mbbill/undotree' },
  { src = 'https://github.com/folke/trouble.nvim' },
})

--: Git
vim.pack.add({
  { src = 'https://github.com/tpope/vim-fugitive' },
})

--: Completion & LSP stack
vim.pack.add({
  { src = 'https://github.com/hrsh7th/nvim-cmp' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
})

--: Treesitter
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
})

--: Telescope
vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
})

-- ============================================================================
-- 2. Базовые настройки (без зависимости от плагинов)
-- ============================================================================

--: Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--: Behavior
vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.colorcolumn = '80'
vim.opt.relativenumber = true
vim.opt.number = true

--: Tabs & Indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

--: UI
vim.cmd [[ set noswapfile ]]
vim.cmd [[ set termguicolors ]]

--: Disable arrow keys
for _, key in ipairs({ '<Up>', '<Down>', '<Left>', '<Right>' }) do
  vim.keymap.set('n', key, '<Nop>')
end

-- ============================================================================
-- 3. Клавиши и простые плагины (без LSP/completion)
-- ============================================================================

--: Window navigation
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

--: Search & misc
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })
vim.keymap.set('n', '<c-_>', '<cmd>NoNeckPain<CR>')
vim.keymap.set('n', '-', require('oil').open, { desc = 'Open parent directory' })

--: Clipboard & delete
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

--: Oil, Undotree, Trouble
require('oil').setup()
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

require('trouble').setup()
vim.keymap.set('n', '<leader>y', vim.diagnostic.open_float)

-- ============================================================================
-- 4. Отложенная инициализация (после загрузки плагинов)
-- ============================================================================

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    -- ------------------------------------------------------------
    -- UI plugins
    -- ------------------------------------------------------------
    require("gruvbox").setup({
      terminal_colors = true,
      transparent_mode = true,
    })
    vim.cmd("colorscheme gruvbox")

    require('lualine').setup({
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1
    	    }
        }
      }
    })

    -- ------------------------------------------------------------
    -- Treesitter
    -- ------------------------------------------------------------
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'javascript', 'typescript', 'python', 'c', 'lua', 'vim', 'vimdoc', 'query', 'go' },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })

    -- NoNeckPain
    require("no-neck-pain").setup({
      width = 160,
      buffers = {
        colors = {
          background = "#111111",
        },
        wo = {
          fillchars = "eob: ",
        },
      },
    })

    -- ------------------------------------------------------------
    -- Completion & LSP
    -- ------------------------------------------------------------
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    require('cmp').setup({
      mapping = require('cmp').mapping.preset.insert({
        ['<C-b>'] = require('cmp').mapping.scroll_docs(-4),
        ['<C-f>'] = require('cmp').mapping.scroll_docs(4),
        ['<C-Space>'] = require('cmp').mapping.complete(),
        ['<C-e>'] = require('cmp').mapping.abort(),
        ['<CR>'] = require('cmp').mapping.confirm({ select = true }),
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
      },
    })

    --: LSP diagnostics: виртуальный текст справа
    vim.diagnostic.config({
      virtual_text = true,
      update_in_insert = false,
      underline = true,
      signs = true,
    })

    --: Mason + LSP servers
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls', 'basedpyright', 'rust_analyzer', 'emmet_ls', 'eslint', 'ts_ls', 'tailwindcss', 'gopls' },
      handlers = {
        function(server_name)
          vim.lsp.enable(server_name, { capabilities = capabilities })
        end,
        lua_ls = function()
          vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { 'vim' } },
                workspace = {
                  library = {
                    [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                    [vim.fn.stdpath 'config' .. '/lua'] = true,
                  },
                },
              },
            },
          })
          vim.lsp.enable('lua_ls')
        end,
      },
    })

    -- ------------------------------------------------------------
    -- Filetype fixes
    -- ------------------------------------------------------------
    vim.filetype.add({
      extension = {
        tsx = 'typescriptreact',
      },
    })
  end,
})

vim.keymap.set('n', '<space>f', function()
  vim.lsp.buf.format { async = true }
end, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

-- ============================================================================
-- 5. Telescope
-- ============================================================================

-- Telescope можно инициализировать сразу — он не зависит от LSP
require('telescope').setup({
  file_ignore_patterns = { 'node%_modules/.*' },
  pickers = {
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
    },
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Space><Space>', builtin.oldfiles, {})
vim.keymap.set('n', '<Space>fg', builtin.live_grep, {})
vim.keymap.set('n', '<Space>ff', builtin.find_files, {})
vim.keymap.set('n', '<Space>fh', builtin.help_tags, {})

-- ============================================================================
-- 6. Indent Blankline
-- ============================================================================

require('ibl').setup({
  indent = { char = '│' },
  whitespace = { remove_blankline_trail = false },
})

-- ============================================================================
-- 7. Provider cleanup
-- ============================================================================

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
