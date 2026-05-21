return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "", right = "" }
      opts.sections.lualine_a = {
        {
          "mode",
          fmt = function(str)
            return " " .. str
          end,
        },
      }
    end,
  },
}
