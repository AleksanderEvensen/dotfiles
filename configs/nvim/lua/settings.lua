vim.opt.number = true
vim.opt.relativenumber = true

-- Default tabstop: 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Auto detect indentation
vim.opt.smartindent = true

-- No line wrapping
vim.opt.wrap = false

-- Disable backup files. We're using git
vim.opt.swapfile = false
vim.opt.backup = false

-- Setting undo directory
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Incremental search
vim.opt.incsearch = true

-- True color support
vim.opt.termguicolors = true

-- Scroll offset
vim.opt.scrolloff = 8

-- Format line
vim.opt.colorcolumn = "80"
-- Line symbol column
vim.opt.signcolumn = "yes"

-- Update time 500ms
vim.opt.updatetime = 500










