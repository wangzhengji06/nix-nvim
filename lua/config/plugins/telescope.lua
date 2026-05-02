return {
	{
		"nvim-telescope/telescope.nvim",

		branch = "master",
		version = false,

		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},

		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				pickers = {
					find_files = {
						theme = "ivy",
					},
				},

				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			-- Use pcall so Telescope still works even if fzf-native failed to build.
			pcall(telescope.load_extension, "fzf")

			vim.keymap.set("n", "<space>fh", builtin.help_tags, {
				desc = "Telescope help tags",
			})

			vim.keymap.set("n", "<space>fd", builtin.find_files, {
				desc = "Telescope find files",
			})

			vim.keymap.set("n", "<space>en", function()
				builtin.find_files({
					cwd = vim.fn.stdpath("config"),
				})
			end, {
				desc = "Find Neovim config files",
			})

			vim.keymap.set("n", "<space>ep", function()
				builtin.find_files({
					cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
				})
			end, {
				desc = "Find lazy.nvim plugin files",
			})

			require("config.telescope.multigrep").setup()
		end,
	},
}
