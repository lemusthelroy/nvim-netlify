local M = {}

function M.show_netlify_dashboard()
	
	local get_sites_command = "netlify sites:list --json"
	local sites = vim.fn.system(get_sites_command)
	local sites_json = vim.fn.json_decode(sites)
	local sites_list = sites_json["sites"]
	local sites_names = {}
	for _, site in ipairs(sites_list) do
		table.insert(sites_names, site["name"])
	end
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Welcome to Netlify Dashboard" })


	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = 40,
		height = 10,
		row = 1,
		col = 1,
		border = "single",
		title = "Netlify Dashboard",
	})

	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", ":lua require('netlify').open_site()<CR>", { noremap = true, silent = true })
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
