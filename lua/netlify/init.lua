local M = {}

function M.show_netlify_dashboard()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Welcome to Netlify Dashboard" })
	local get_status_command = "netlify status --json"

	-- Execute the command and capture the output
	local statusResponse = vim.fn.system(get_status_command)

	local statusJson = vim.fn.json_decode(statusResponse)

	if statusJson == nil then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No Netlify site found" })
		return
	end
	local siteId = statusJson["siteData"]["site-id"]

	local siteResponse = vim.fn.system("netlify api getSite --data '{\"siteId\": \"" .. siteId .. "\"}'")

	local siteJson = vim.fn.json_decode(siteResponse)

	if siteJson == nil then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No Netlify site found" })
		return
	end

	local siteName = siteJson["name"]
	local siteUrl = siteJson["url"]
	local siteAdminUrl = siteJson['published_deploy']["admin_url"]

	local status = "Site: " .. siteName .. "\n"
	status = status .. "URL: " .. siteUrl .. "\n"
	status = status .. "Admin URL: " .. siteAdminUrl .. "\n"

	local deployResponse = vim.fn.system("netlify api listSiteDeploys --data '{\"siteId\": \"" .. siteId .. "\"}'")

	local deployJson = vim.fn.json_decode(deployResponse)

	if deployJson == nil then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No Netlify site found" })
		return
	end

	local deployUrl = deployJson[1]["deploy_ssl_url"]
	local deployAdminUrl = deployJson[1]["admin_url"]
	local deployState = deployJson[1]["state"]

	status = status .. "Deploy: " .. deployState .. "\n"
	status = status .. "URL: " .. deployUrl .. "\n"
	status = status .. "Admin URL: " .. deployAdminUrl .. "\n"



	-- Set the lines of the buffer to the output of the command
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(status, "\n"))
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
