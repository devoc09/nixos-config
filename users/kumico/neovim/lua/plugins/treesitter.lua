return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
        { "RRethy/nvim-treesitter-endwise" },
	},
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			highlight = {
				enable = true,
			},
			endwise = {
				enable = true,
			},
      indent = {
        enable = true,
      },
		})
	end,
}
