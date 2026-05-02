local parsers = {
	"c",
	"python",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"nix",
}

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

local function start_treesitter(bufnr)
	if is_big_file(bufnr) then
		return
	end

	pcall(vim.treesitter.start, bufnr)
end

return {
	{
		"nvim-treesitter/nvim-treesitter",

		-- nvim-treesitter should not be lazy-loaded.
		lazy = false,

		-- Keep parsers in sync when Lazy updates the plugin.
		build = ":TSUpdate",

		-- Needed by the current nvim-treesitter setup.
		dependencies = {
			"neovim-treesitter/treesitter-parser-registry",
		},

		config = function()
			local ok, treesitter = pcall(require, "nvim-treesitter")
			if not ok then
				return
			end

			-- Optional, but harmless with defaults.
			if type(treesitter.setup) == "function" then
				treesitter.setup()
			end

			-- Current nvim-treesitter API.
			if type(treesitter.install) == "function" then
				treesitter.install(parsers)
			end

			local group = vim.api.nvim_create_augroup("UserTreesitter", {
				clear = true,
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = filetypes,
				callback = function(args)
					start_treesitter(args.buf)
				end,
			})
		end,
	},
}
