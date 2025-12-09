-- based on https://github.com/SvenBroeckling/nvim-0.12-config

vim.pack.add({
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
})
require("oil").setup()
require("lualine").setup()

--: disable things
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0

--: keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.colorcolumn = "80"
vim.opt.relativenumber = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.cmd [[ set noswapfile ]]
vim.cmd [[ set termguicolors ]]

--Line numbers
vim.wo.number = true

-- Disable arrow keys
vim.keymap.set('n', '<Up>', '<Nop>')
vim.keymap.set('n', '<Down>', '<Nop>')
vim.keymap.set('n', '<Left>', '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
-- vim.keymap.set('n', '<c-_>', ':ZenMode<CR>')

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set('n', '<c-_>', ':NoNeckPain<CR>')

vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })


-- plugins

vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim.git", name = "catppuccin" },
})
vim.cmd.colorscheme "catppuccin"



--: treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require('nvim-treesitter.configs').setup {
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "javascript", "typescript", "python", "c", "lua", "vim", "vimdoc", "query", "go" },
	sync_install = false,
	auto_install = true,
	ignore_install = {},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

--: lsp and mason
--: autocompletion
vim.pack.add({
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim.git" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
})
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "basedpyright", "rust_analyzer", "emmet_ls", "eslint", "ts_ls", "tailwindcss", "gopls" },
  handlers = {
    function(server_name)
      vim.lsp.enable(server_name, {
        capabilities = capabilities,
      })
    end,
    -- Опционально: кастомная настройка для lua_ls
    lua_ls = function()
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = {
                [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                [vim.fn.stdpath "config" .. "/lua"] = true,
              },
            },
          },
        },
      })
      vim.lsp.enable('lua_ls')
    end,
  },
})

vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  signs = true,
})

--: noneckpain
vim.pack.add({
  { src = "https://github.com/shortcuts/no-neck-pain.nvim" },
})
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

--: gitfugitive

vim.pack.add({
  { src = "https://github.com/tpope/vim-fugitive" },
})

--: telescope
vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
})
require('telescope').setup({
  file_ignore_patterns = { "node%_modules/.*" },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "-g", "!.git" }
    },
  }
})
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<Space><Space>', builtin.oldfiles, {})
vim.keymap.set('n', '<Space>fg', builtin.live_grep, {})
vim.keymap.set('n', '<Space>ff', builtin.find_files, {})
vim.keymap.set('n', '<Space>fh', builtin.help_tags, {})

--: blankline ident
vim.pack.add({
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
})
require("ibl").setup({
  indent = {
    char = '│',
  },
  whitespace = {
    remove_blankline_trail = false,
  },
})

--: undotree

vim.pack.add({
  { src = "https://github.com/mbbill/undotree" },
})
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)


--: trouble display
vim.pack.add({
  { src = "https://github.com/folke/trouble.nvim" },
})
require("trouble").setup()

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)



vim.filetype.add({
  extension = {
    tsx = "typescriptreact",
  },
})
