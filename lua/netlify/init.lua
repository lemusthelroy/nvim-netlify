local M = {}

function M.show_netlify_dashboard()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Welcome to Netlify Dashboard" })
	local get_sites_command = "!netlify sites:list --json"
	-- Execute the command and capture the output
	local sites = vim.fn.system(get_sites_command)


	-- Set the lines of the buffer to the output of the command
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(sites, "\n"))
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = 40,
		height = 10,
		row = 1,
		col = 1,
		border = "single",
		title = "Netlify Dashboard",
	})

	vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
	vim.api.nvim_win_set_option(win, "wrap", false)
	vim.api.nvim_win_set_option(win, "number", false)
	vim.api.nvim_win_set_option(win, "relativenumber", false)
	vim.api.nvim_win_set_option(win, "cursorline", false)
	vim.api.nvim_win_set_option(win, "cursorcolumn", false)
	vim.api.nvim_win_set_option(win, "signcolumn", "no")
	vim.api.nvim_win_set_option(win, "foldenable", false)
	vim.api.nvim_win_set_option(win, "foldcolumn", "0")
	vim.api.nvim_win_set_option(win, "conceallevel", 0)
	vim.api.nvim_win_set_option(win, "scrolloff", 0)
	vim.api.nvim_win_set_option(win, "sidescrolloff", 0)
	vim.api.nvim_win_set_option(win, "colorcolumn", "")
	vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Normal")
	vim.api.nvim_win_set_option(win, "winblend", 0)
	vim.api.nvim_win_set_option(win, "winfixheight", false)
	vim.api.nvim_win_set_option(win, "winfixwidth", false)

	vim.api.nvim_command(
		"autocmd WinLeave <buffer=" .. buf .. "> ++once lua vim.api.nvim_win_close(" .. win .. ", true)"
	)
end

function M.setup()
	-- Map <leader>nt to show the Dashboard
	vim.api.nvim_set_keymap("n", "<leader>nt", ":lua require('netlify').show_netlify_dashboard()<CR>", {
		noremap = true,
		silent = true,
	})
end

return M
