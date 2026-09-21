return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = { 'bash', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "vb",            -- Start incremental selection
                    node_incremental = "vb",          -- Expand to the next node or scope
                    scope_incremental = "vB",         -- Expand to the next scope (optional, for larger jumps)
                    node_decremental = "v<BS>",       -- Shrink the selection (mapped to Backspace)
                }, 
            },

        },
        config = function(_, opts)
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter').setup(opts)

            -- Fix nvim 0.12 compatibility: nvim-treesitter@master's query_predicates use
            -- old directive signature (match: TSNode[]), but nvim 0.12 passes
            -- captures: table<integer, TSNode[]> where each value is a *list*.
            -- That causes `node:range` nil error on markdown `(#set-lang-from-info-string! @_lang)`
            -- which is triggered by render-markdown.nvim. Patch the directives to handle both.
            if vim.fn.has('nvim-0.12') == 1 then
                pcall(function()
                    local query = require('vim.treesitter.query')
                    local function norm(val)
                        if not val then return nil end
                        -- new API: captures[id] = TSNode[] (list)
                        if type(val) == 'table' and val[1] and type(val[1]) == 'userdata' then
                            return val[1]
                        end
                        -- old API already single node
                        if type(val) == 'userdata' then return val end
                        return nil
                    end
                    local function get_parser_from_markdown_info_string(alias)
                        local m = vim.filetype.match({ filename = 'a.' .. alias })
                        local aliases = { ex = 'elixir', pl = 'perl', sh = 'bash', uxn = 'uxntal', ts = 'typescript' }
                        return m or aliases[alias] or alias
                    end

                    query.add_directive('set-lang-from-info-string!', function(captures, _, bufnr, pred, metadata)
                        local id = pred[2]
                        local raw = captures[id] or captures[tonumber(id)] or captures[tostring(id)]
                        local node = norm(raw)
                        if not node or not node.range then return end
                        local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
                        if not ok or not text or text == '' then return end
                        metadata['injection.language'] = get_parser_from_markdown_info_string(text:lower())
                    end, { force = true })

                    query.add_directive('set-lang-from-mimetype!', function(captures, _, bufnr, pred, metadata)
                        local id = pred[2]
                        local raw = captures[id] or captures[tonumber(id)]
                        local node = norm(raw)
                        if not node or not node.range then return end
                        local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
                        if not ok or not text then return end
                        if text == 'importmap' or text == 'module' then
                            metadata['injection.language'] = 'json'
                        elseif text:find('javascript') then
                            metadata['injection.language'] = 'javascript'
                        else
                            metadata['injection.language'] = vim.split(text, '/', {})[#vim.split(text, '/', {})]
                        end
                    end, { force = true })

                    query.add_directive('downcase!', function(captures, _, bufnr, pred, metadata)
                        local id = pred[2]
                        local raw = captures[id] or captures[tonumber(id)]
                        local node = norm(raw)
                        if not node or not node.range then return end
                        local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr, { metadata = metadata[id] })
                        if not ok then return end
                        text = text or ''
                        if not metadata[id] then metadata[id] = {} end
                        metadata[id].text = string.lower(text)
                    end, { force = true })
                end)
            end

            -- There are additional nvim-treesitter modules that you can use to interact
            -- with nvim-treesitter. You should go explore a few and see what interests you:
            --
            --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
            --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
            --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        end,
    },
}
