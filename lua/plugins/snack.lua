return {
  {
    "folke/snacks.nvim",
    ---@diagnostic disable-next-line: unused-local
    opts = function(_, opts)
      local sources = opts.picker.sources or {}
      local source_names = { "files", "explorer", "grep", "grep_word", "grep_buffers" }
      local source_opts = {
        hidden = true,
        ignored = true,
        exclude = { ".git", ".DS_Store", ".vscode", ".idea", "node_modules", ".next", "vendor" },
      }

      for _, name in ipairs(source_names) do
        sources[name] = source_opts
      end
      opts.picker.sources = sources

      return opts
    end,
  },
}
