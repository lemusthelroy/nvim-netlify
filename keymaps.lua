local keymap = vim.api.nvim_set_keymap

keymap('n', '<leader>nt', ':lua require("netlify").show_netlify_dashboard()<CR>', { noremap = true, silent = true })
