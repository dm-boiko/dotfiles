return {
    {
        "christoomey/vim-tmux-navigator",
        init = function()
            -- Already set in init.lua; keep for lazy load safety
            vim.g.tmux_navigator_disable_netrw_workaround = 1
        end,
    }
}
