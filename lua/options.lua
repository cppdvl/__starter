require "nvchad.options"

-- add yours here!

local o     = vim.o
local g     = vim.g
local bo    = vim.bo

-- misconfigurations for me
o.number    = true
o.swapfile  = false
o.mouse     = "a"

-- indenting (2 spaces, spaces)
o.autoindent  = true
o.tabstop     = 2
o.shiftwidth  = 2
o.softtabstop = 2
o.expandtab   = true

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.keymap.set("n", "<leader>ind", function()
    local ts = 4
    if bo.tabstop == 4 then ts = 2 end
    o.tabstop       = ts
    o.shiftwidth    = ts
    o.softtabstop   = ts
    print("indent is " .. ts .. " spaces")
end)

-- FORCE ESC TO ALWAYS WORK - NUCLEAR OPTION
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    -- Force escape mappings for every buffer
    vim.keymap.set("i", "<Esc>", "<C-\\><C-n>", { buffer = true, noremap = true, silent = true })
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = true, noremap = true, silent = true })
  end,
})

-- Auto-reload buffers when files change outside of Neovim
vim.opt.autoread = true

-- Reduce the time before CursorHold triggers (optional, affects responsiveness)
-- vim.opt.updatetime = 250

-- Trigger checktime to detect external changes more aggressively
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Notification when file changes
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN)
  end,
})


