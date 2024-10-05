return {
    "linrongbin16/gitlinker.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = "GitLink",
    event = "ModeChanged",
    config = function()
        require("gitlinker").setup({
            message = false,
        })
    end
}
