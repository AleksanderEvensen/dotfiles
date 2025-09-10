vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move selected lines DOWN
vim.keymap.set("v", "J", ":move '>+1<CR>gv=gv")

-- Move selected lines UP
vim.keymap.set("v", "K", ":move '<-2<CR>gv=gv")

-- Move down and down page with centering
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Move to next and previous search with centering
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Replace selection with default register (in any visual mode)
vim.keymap.set("x", "<leader>p", [["_dp]])

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]]) -- Copies current line


-- Delete without copying to register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
