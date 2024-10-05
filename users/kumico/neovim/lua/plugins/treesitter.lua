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
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "go", "zig", "rust", "python", "yaml", "nix" },
			highlight = {
				enable = true,
			},
			endwise = {
				enable = true,
			},
		})
	end,
}
