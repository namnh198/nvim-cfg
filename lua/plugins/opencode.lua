return {
  {
    "nickjvandyke/opencode.nvim",
    dependencies = {
      {
        -- `snacks.nvim` integration is recommended, but optional
        ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {}, -- Enhances `ask()`
          picker = { -- Enhances `select()`
            actions = {
              opencode_send = function(...)
                return require("opencode").snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      local opencode_cmd = "opencode --port"
      ---@type snacks.terminal.Opts
      local snacks_terminal_opts = {
        win = {
          position = "right",
          enter = false,
        },
      }
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any; goto definition on the type or field for details
        server = {
          start = function()
            require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
          end,
        },
      }

      vim.o.autoread = true -- Required for `vim.g.opencode_opts.events.reload`

      -- Recommended/example keymaps
      vim.keymap.set({ "n", "x" }, "<C-a>", function()
        require("opencode").ask("@this: ")
      end, { desc = "Ask opencode…" })
      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        require("opencode").select()
      end, { desc = "Select opencode…" })

      vim.keymap.set({ "n", "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { desc = "Add range to opencode", expr = true })
      vim.keymap.set("n", "goo", function()
        return require("opencode").operator("@this ") .. "_"
      end, { desc = "Add line to opencode", expr = true })

      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "Scroll opencode up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "Scroll opencode down" })

      -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
      -- Can also leverage toggle functionality
      vim.keymap.set({ "n", "t" }, "<C-.>", function()
        require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
      end, { desc = "Toggle opencode" })

      -- Optionally show upon submitting prompt
      vim.api.nvim_create_autocmd("User", {
        pattern = { "OpencodeEvent:tui.command.execute" },
        callback = function(args)
          ---@type opencode.server.Event
          local event = args.data.event
          if event.properties.command == "prompt.submit" then
            local win = require("snacks.terminal").get(opencode_cmd, { create = false })
            if win then
              win:show()
            end
          end
        end,
      })

      -- Handle `opencode` events
      vim.api.nvim_create_autocmd("User", {
        pattern = "OpencodeEvent:*", -- Optionally filter event types
        callback = function(args)
          ---@type opencode.server.Event
          local event = args.data.event

          -- See the available event types and their properties
          vim.notify(vim.inspect(event))
          -- Do something useful
          if event.type == "session.idle" then
            vim.notify("`opencode` finished responding")
          end
        end,
      })
    end,
  },
}
