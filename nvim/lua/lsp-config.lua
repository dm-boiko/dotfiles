local ok_lsp_zero, lsp_zero = pcall(require, 'lsp-zero')
if not ok_lsp_zero then return end

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  local opts = {buffer = bufnr}

  lsp_zero.default_keymaps(opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('i', '<C-l>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
  vim.keymap.set('n', 'gm', '<cmd>Telescope lsp_document_symbols theme=dropdown<cr>', opts)

end)

pcall(function() require('mason').setup({}) end)
pcall(function()
  require('mason-lspconfig').setup({
    handlers = {
      lsp_zero.default_setup,
    },
  })
end)

local ok_cmp, cmp = pcall(require, 'cmp')
if not ok_cmp then return end
local ok_cmp_action, cmp_action_mod = pcall(function() return require('lsp-zero').cmp_action() end)
local cmp_action = ok_cmp_action and cmp_action_mod or nil

cmp.setup({

  mapping = cmp.mapping.preset.insert((function()
    local m = {
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({select = false}),
      -- Ctrl+Space to trigger completion menu
      ['<C-Space>'] = cmp.mapping.complete(),
      -- Scroll up and down in the completion documentation
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }
    if cmp_action then
      m['<C-f>'] = cmp_action.luasnip_jump_forward()
      m['<C-b>'] = cmp_action.luasnip_jump_backward()
    end
    return m
  end)()),
})
-- require "lsp_signature".setup()
