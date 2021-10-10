vim.api.nvim_set_keymap('n', ' ', "<cmd>lua require'hop'.hint_words()<cr>", {})
require'hop'.setup { create_hl_autocmd = false }
