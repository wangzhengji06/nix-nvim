local filetypes = {
	"c",
	"python",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"nix",
}

local function is_big_file(bufnr)
	local max_filesize = 100 * 1024
	local name = vim.api.nvim_buf_get_name(bufnr)

	if name == "" then
		return false
	end

	local uv = vim.uv or vim.loop
	local ok, stat = pcall(uv.fs_stat, name)

	return ok and stat and stat.size > max_filesize
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,

		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", {
					clear = true,
				}),
				pattern = filetypes,
				callback = function(args)
					if not is_big_file(args.buf) then
						pcall(vim.treesitter.start, args.buf)
					end
				end,
			})
		end,
	},
}
