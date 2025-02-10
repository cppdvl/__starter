require "nvchad.options"

-- add yours here!

local o     = vim.o
local g     = vim.g
local bo    = vim.bo

-- misconfigurations for me
o.number    = true
o.swapfile  = false
o.mouse     = "a"

-- indenting (4 spaces, spaces)
o.autoindent  = true
o.tabstop     = 4
o.shiftwidth  = 4
o.softtabstop = 4
o.expandtab   = true

vim.keymap.set("n", "<leader>ind", function()
    local ts = 2
    if bo.tabstop == 2 then ts = 4 end
    o.tabstop       = ts
    o.shiftwidth    = ts
    o.softtabstop   = ts
    print("indent is " .. ts .. " spaces")
end)



