require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "<C-c>", "<ESC>", { desc = "Alternative escape" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape terminal mode" })

-- FORCE ESC TO WORK EVERYWHERE
map("i", "<Esc>", "<C-\\><C-n>", { desc = "Force escape to normal mode", noremap = true, silent = true })
map("v", "<Esc>", "<Esc>", { desc = "Force escape in visual mode", noremap = true, silent = true })
map("s", "<Esc>", "<Esc>", { desc = "Force escape in select mode", noremap = true, silent = true })
map("x", "<Esc>", "<Esc>", { desc = "Force escape in visual block", noremap = true, silent = true })
map("c", "<Esc>", "<C-c>", { desc = "Force escape in command mode", noremap = true, silent = true })
map("o", "<Esc>", "<Esc>", { desc = "Force escape in operator pending", noremap = true, silent = true })

-- telescope
map("n", "<leader>tlgc", "<cmd>Telescope live_grep args=--case-sensitive<CR>", { desc = "telescope live grep" })
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
map("n", "<leader>tfh", "<cmd>Telescope find_files hidden=true no_ignore=true<CR>", { desc = "telescope find files (including hidden)" })
map("n", "<leader>tfa", "<cmd>Telescope find_files hidden=true no_ignore=true follow=true<CR>", { desc = "telescope find all files" })
map("n", "<leader>tvo", "<cmd>Telescope vim_options<CR>", { desc = "telescope vim options"})

-- CMake compilation keymaps
local cmake_ok, cmake_compile = pcall(require, "local.cmake-compile")
if cmake_ok then
  map("n", "<leader>g++", cmake_compile.compile_current_file, { desc = "Compile current C++ file using CMake commands" })
  map("n", "<leader>g+r", cmake_compile.compile_and_run, { desc = "Compile and run current C++ file" })
  map("n", "<leader>G++", cmake_compile.generate_compile_commands, { desc = "Generate compile_commands.json" })
  map("n", "<leader>g--", cmake_compile.clean_current_object, { desc = "Clean object file for current compilation unit" })
  map("n", "<leader>G--", cmake_compile.clean_all, { desc = "Clean entire build directory" })
  
  -- Compiler selection keymaps
  map("n", "<leader>gcs", cmake_compile.select_compiler, { desc = "Select compiler (gcc/clang/mingw/etc.)" })
  map("n", "<leader>gci", cmake_compile.get_current_compiler_info, { desc = "Show current compiler info" })
  map("n", "<leader>gcc", cmake_compile.setup_custom_compiler, { desc = "Setup custom compiler paths" })
  
  -- Custom CMake command
  map("n", "<leader>cmk", cmake_compile.custom_cmake_command, { desc = "Execute custom CMake command" })
end

-- Copilot Chat keymaps
map("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle Copilot Chat" })
map("n", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain selected code" })
map("n", "<leader>cr", "<cmd>CopilotChatReview<cr>", { desc = "Review selected code" })
map("n", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Fix selected code" })
map("n", "<leader>co", "<cmd>CopilotChatOptimize<cr>", { desc = "Optimize selected code" })
map("n", "<leader>cd", "<cmd>CopilotChatDocs<cr>", { desc = "Add documentation" })
map("n", "<leader>ct", "<cmd>CopilotChatTests<cr>", { desc = "Generate tests" })
map("v", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle Copilot Chat" })
map("v", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain selected code" })
map("v", "<leader>cr", "<cmd>CopilotChatReview<cr>", { desc = "Review selected code" })
map("v", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Fix selected code" })
map("v", "<leader>co", "<cmd>CopilotChatOptimize<cr>", { desc = "Optimize selected code" })
map("v", "<leader>cd", "<cmd>CopilotChatDocs<cr>", { desc = "Add documentation" })
map("v", "<leader>ct", "<cmd>CopilotChatTests<cr>", { desc = "Generate tests" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
