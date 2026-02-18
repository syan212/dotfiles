-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable true colours
vim.opt.termguicolors = true

-- Line numbers
vim.wo.number = true

-- Mouse
vim.g.mouse = 'a'

-- Encoding
vim.opt.encoding = 'utf-8'

-- Swapfile
vim.opt.swapfile = false

-- Scrolloff
vim.opt.scrolloff = 7

-- Tabs to spaces and stuff
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true

-- Completion
vim.o.completeopt="menu,menuone,noselect"

-- Clipboard
vim.opt.clipboard = 'unnamedplus'

-- File stuff
vim.opt.fileformat = 'unix'

-- Lazy.nvim
require('config.lazy')

-- LSPs
vim.lsp.enable('basedpyright')
vim.lsp.enable('bashls')
vim.lsp.enable('cssls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ruff')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('svelte')
vim.lsp.enable('vtsls')

-- Keymaps
require('keymaps')

-- Completions
require('cmp_config')

-- Treesitter parsers
require('nvim-treesitter').install({ 
    'zsh', 'bash', 'rust', 'javascript', 'python', 'lua', 'markdown', 'c', 'cpp',
})
