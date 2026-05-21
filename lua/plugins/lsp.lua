return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if not opts.servers then
        opts.servers = {}
      end
      opts.servers.gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true, -- This enables auto-import
            gofumpt = true,
          },
        },
      }
      opts.servers.html = {}
      opts.servers.cssls = {
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      }
      return opts
    end,
  },
}
