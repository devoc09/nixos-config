-- default disabled
return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    enabled = false,
    config = function()
        require("ibl").setup()
    end
}
