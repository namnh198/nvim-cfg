-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Turn off paste mode when leaving insert
autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- BufferDeletePost User
autocmd("BufDelete", {
  group = augroup("buf_del_post"),
  desc = "BufDeletePost User autocmd",
  callback = function()
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "BufDeletePost",
      })
    end)
  end,
})

-- Show Dashboard if all buffers deleted
autocmd("User", {
  pattern = "BufDeletePost",
  group = augroup("dashboard_delete_buffers"),
  desc = "Open Dashboard when no available buffers",
  callback = function(ev)
    local deleted_name = vim.api.nvim_buf_get_name(ev.buf)
    local deleted_ft = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
    local deleted_bt = vim.api.nvim_get_option_value("buftype", { buf = ev.buf })
    local dashboard_on_empty = deleted_name == "" and deleted_ft == "" and deleted_bt == ""
    if dashboard_on_empty then
      Snacks.dashboard.open()
    end
  end,
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
