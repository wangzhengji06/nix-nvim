return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"c",
				"python",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local max_filesize = 100 * 1024
					local name = vim.api.nvim_buf_get_name(args.buf)
					local ok, stats = pcall(vim.loop.fs_stat, name)

					if ok and stats and stats.size > max_filesize then
						return
					end

					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},
}
