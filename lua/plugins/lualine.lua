return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local auto = require("lualine.themes.auto")
      local palette = require("catppuccin.palettes").get_palette("mocha")
      local modes = { "normal", "insert", "visual", "replace", "command", "inactive", "terminal" }
      for _, mode in ipairs(modes) do
        if auto[mode] and auto[mode].c then
          auto[mode].c.bg = "NONE"
        end
      end
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        theme = auto,
        component_separators = "",
        section_separators = "",
        transparent = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" }, winbar = {} },
      })

      local function separator()
        return {
          function()
            return "│"
          end,
          color = { fg = palette.surface0, bg = "NONE", gui = "bold" },
          padding = { left = 1, right = 1 },
        }
      end

      local function custom_branch()
        local gitsigns = vim.b.gitsigns_head
        local fugitive = vim.fn.exists("*FugitiveHead") == 1 and vim.fn.FugitiveHead() or ""
        local branch = gitsigns or fugitive
        if branch == nil or branch == "" then
          return ""
        else
          return " " .. branch
        end
      end

      opts.sections.lualine_a = {
        {
          "mode",
          fmt = function(str)
            return " " .. str:sub(1, 1)
          end,
          color = function()
            local mode = vim.fn.mode()
            if mode == "\22" then
              return { fg = "none", bg = palette.red, gui = "bold" }
            elseif mode == "V" then
              return { fg = palette.red, bg = "none", gui = "underline,bold" }
            else
              return { fg = palette.red, bg = "none", gui = "bold" }
            end
          end,
          padding = { left = 0, right = 0 },
        },
      }
      opts.sections.lualine_b = {
        separator(),
        {
          custom_branch,
          color = { fg = palette.green, bg = "none", gui = "bold" },
          padding = { left = 0, right = 0 },
        },
        {
          "diff",
          symbols = {
            added = LazyVim.config.icons.git.added,
            modified = LazyVim.config.icons.git.modified,
            removed = LazyVim.config.icons.git.removed,
          },
          colored = true,
          diff_color = {
            added = { fg = palette.teal, bg = "none", gui = "bold" },
            modified = { fg = palette.yellow, bg = "none", gui = "bold" },
            removed = { fg = palette.red, bg = "none", gui = "bold" },
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      }
      opts.sections.lualine_y = {
        separator(),
        { "progress", separator = " ", color = { bg = "none" }, padding = { left = 0, right = 0 } },
        separator(),
        { "location", color = { bg = "none" }, padding = { left = 0, right = 0 } },
        separator(),
        {
          "fileformat",
          color = { fg = palette.yellow, bg = "none", gui = "bold" },
          symbols = {
            unix = "",
            dos = "",
            mac = "",
          },
          padding = { left = 0, right = 0 },
        },
        {
          "encoding",
          color = { fg = palette.yellow, bg = "none", gui = "bold" },
          padding = { left = 1, right = 0 },
        },
        separator(),
      }
      opts.sections.lualine_z = {
        {
          "filetype",
          colored = true,
          color = { fg = palette.blue, bg = "none", gui = "bold" },
          padding = { left = 0, right = 1 },
        },
      }
    end,
  },
}
