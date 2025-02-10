require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- telescope
map("n", "<leader>tlg", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>tbf", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>tht", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>tma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>tof", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>tfz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>tgc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>tgs", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>ttr", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>tff", "<cmd>Telescope find_files<CR>", { desc = "telescope find files"})
map("n", "<leader>tvo", "<cmd>Telescope vim_options<CR>", { desc = "telescope vim options"})
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
