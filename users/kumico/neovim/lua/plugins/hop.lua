return {
  "phaazon/hop.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "f", function() require("hop").hint_char1() end },
  },
  opts = {
    multi_windows = true,
  },
}
