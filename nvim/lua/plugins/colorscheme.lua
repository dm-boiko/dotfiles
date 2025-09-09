return {

    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        config = function()
            vim.cmd.colorscheme("kanagawa")
        end,
    },
    {
        "ribru17/bamboo.nvim",
        name = "bamboo",
        config = function()
            require("bamboo").setup({
                style = "light", -- Use the light variant
                -- transparent = false, -- Disable transparent background
                overrides = {
                    -- CursorLine = { bg = "#f0f0f0" }, -- Customize cursor line background
                    -- Cursor = { fg = "#000000", bg = "#FFA500", reverse=true }, -- Customize cursor color
                    -- Customize the cursor
                    Cursor = { fg = "NONE", bg = "#007ACC" }, -- Bright blue cursor

                    -- Customize the cursor line
                    CursorLine = { bg = "#F5EAD6" }, -- Subtle beige background for the cursorline

                    -- Optional: Customize the background for better contrast
                    Normal = { bg = "#FAF3E0" }, -- Light pastel background
                },
            })
            -- vim.cmd.colorscheme("bamboo-light")
        end,
    }
}

