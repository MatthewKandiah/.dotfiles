vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.hlsearch = false
vim.o.incsearch = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.scrolloff = 12
vim.o.mouse = 'a'
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect,preview'
vim.o.termguicolors = true
vim.wo.linebreak = true
vim.o.cursorline = true
vim.opt.foldcolumn = "1"

-- bootstrap package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
require('lazy').setup({
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'huyvohcmc/atlas.vim',
  'aktersnurra/no-clown-fiesta.nvim',
  'romainl/Apprentice',
  {
    'blazkowolf/gruber-darker.nvim',
    opts = {
      bold = false,
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  'folke/lua-dev.nvim',
  'folke/neodev.nvim',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'hrsh7th/nvim-cmp',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
  },
  { 'folke/which-key.nvim', opts = {} },
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',
  {
    'stevearc/oil.nvim',
    opts = {},
  },
}, {})

-- copy to clipboard and selection registers
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+Y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P')
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"*y')
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"*Y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"*p')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"*P')
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- yank group highlight
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '<F3>', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<F4>', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- Quickfix list keymaps
vim.keymap.set('n', '<F7>', function() vim.cmd('cnext') end, { desc = 'Go to next quickfix item' })
vim.keymap.set('n', '<F8>', function() vim.cmd('cprev') end, { desc = 'Go to previous quickfix item' })
vim.keymap.set('n', '<F9>', function() vim.cmd('copen') end, { desc = 'Open quickfix list' })

-- telescope config
-- search hidden files, but still ignore .git files https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
local vimgrep_arguments = { unpack(require("telescope.config").values.vimgrep_arguments) }
table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")
require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { height = 0.95 },
    vimgrep_arguments = vimgrep_arguments,
    path_display = function(opts, path)
      local tail = require("telescope.utils").path_tail(path)
      return string.format("%s (%s)", tail, path)
    end,
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
})
pcall(require('telescope').load_extension, 'fzf')
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = true,
  })
end, { desc = '[ ] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').search_history, { desc = '[S]earch [H]istory' })
vim.keymap.set('n', '<leader>sg', function()
  require('telescope.builtin').live_grep({ disable_coordinates = true })
end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })

-- cmp-nvim autocompletion config
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  completion = { autocomplete = false }, -- only autocomplete on cmp.mapping.complete call
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    cmp.m
  }),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'nvim_lsp' },
    -- { name = 'buffer', max_item_count = 3 },
  }),
})
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  },
})
cmp.setup.cmdline({ ':' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'cmdline' },
    { name = 'path' },
  },
})

-- lsp config
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(_, bufnr)
  local lsp_keymap = function(mode, keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc .. '(' .. mode .. ')'
    end
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
  end

  local nmap = function(keys, func, desc) lsp_keymap('n', keys, func, desc) end
  local imap = function(keys, func, desc) lsp_keymap('i', keys, func, desc) end

  nmap('<leader>r', vim.lsp.buf.rename, '[R]ename')
  nmap('<leader>c', vim.lsp.buf.code_action, '[C]ode Action')
  nmap('gd', function()
    require('telescope.builtin').lsp_definitions({ show_line = false })
  end, '[G]oto [D]efinition')
  nmap('gr', function()
    require('telescope.builtin').lsp_references({ show_line = false })
  end, '[G]oto [R]eferences')
  nmap('gI', function()
    require('telescope.builtin').lsp_implementations({ show_line = false })
  end, '[G]oto [I]mplementation')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('gD', function()
    require('telescope.builtin').lsp_document_symbols({ show_line = false })
  end, '[G]oto [D]ocument symbol')
  nmap('gc', function()
    require('telescope.builtin').grep_string()
  end, '[G]rep string under [c]ursor')
  imap('<C-h>', function() vim.lsp.buf.signature_help({ close_events = { 'CursorMoved', 'CursorMovedI' } }) end,
    'LSP Signature [H]elp')
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
  nmap('<leader>f', vim.lsp.buf.format, "Format current buffer with LSP")
end

-- filetype for go templ
vim.filetype.add({ extension = { templ = "templ" } })

-- lsp setup
local lspconfig = require('lspconfig')
local default_lsp_options = {
  on_attach = on_attach,
  capabilities = capabilities,
}
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup()
mason_lspconfig.setup_handlers {
  function(server_name)
    lspconfig[server_name].setup(default_lsp_options)
  end,
  lspconfig.racket_langserver.setup(default_lsp_options), -- requires racket-langserver, install with `raco pkg install racket-langserver`
  lspconfig.zls.setup(default_lsp_options),               -- requires zls on path, used because Mason installs an outdated version
  lspconfig.dartls.setup(default_lsp_options),
}

-- treesitter config
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'lua' },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
    },
  }
end, 0)

-- theme config
-- vim.cmd('colorscheme no-clown-fiesta')
vim.cmd('colorscheme apprentice')
-- vim.cmd('colorscheme gruber-darker')

-- git signs config
require('gitsigns').setup()

-- file explorer
local oil = require('oil')
local oil_actions = require('oil.actions')
oil.setup()
vim.keymap.set('n', '<leader>o', oil.open)
vim.keymap.set('n', '<leader>_', oil_actions.open_cwd.callback)

-- TODO functionality
local function insertTodoComment()
  local current_line_number = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, current_line_number, current_line_number, false, { 'TODO-Matt' })
  require('Comment.api').comment.linewise.count(2)
  require('Comment.api').uncomment.linewise.current()
  vim.cmd("normal j$")
end
vim.keymap.set({ 'n' }, '<leader>t', insertTodoComment)

-- quick uppercasing
local function upperCaseSurroundingWord()
  vim.cmd("normal gUiw")
end
local function upperCaseSurroundingBigWord()
  vim.cmd("normal gUiW")
end
vim.keymap.set({ 'n' }, '<leader>u', upperCaseSurroundingWord)
vim.keymap.set({ 'n' }, '<leader>U', upperCaseSurroundingBigWord)
