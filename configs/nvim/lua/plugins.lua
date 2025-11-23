theme = theme or "tokyonight"
local function ApplyTheme(theme)
    vim.cmd.colorscheme(theme)
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#51B3EC", bold = true })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#51B3EC", bold = true })
end


vim.pack.add({"https://github.com/folke/tokyonight.nvim"})
vim.pack.add({"https://github.com/neovim/nvim-lspconfig"})
vim.pack.add({"https://github.com/nvim-treesitter/nvim-treesitter"})
vim.pack.add({"https://github.com/mason-org/mason.nvim"})

ApplyTheme(theme)

require("mason").setup({
    PATH = "append"
})

vim.lsp.config["zls"] = {
    mason = false,
};

require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "lua", "markdown", "typescript", "javascript", "rust", "zig", "git_config", "gitcommit", "git_rebase" },
    highlight = {
        enable = true,
    }
}


vim.lsp.enable("lua_ls")
vim.lsp.enable("zls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("tsgo")
