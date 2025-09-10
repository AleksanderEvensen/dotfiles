local function ApplyTheme(theme)
    theme = theme or "tokyonight"

    vim.cmd.colorscheme(theme)
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#51B3EC", bold = true })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#51B3EC", bold = true })
end


return {
    {

        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            ApplyTheme()
        end
    }
}
