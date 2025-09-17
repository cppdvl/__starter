# Neovim Development Environment

A complete Neovim configuration built on NvChad with GitHub Copilot, C++ development tools, and CMake integration.

## ✨ Features

### 🤖 **AI Development**
- **GitHub Copilot** with intuitive keymaps (`Tab` to accept)
- **Copilot Chat** integration with quick actions
- Smart code explanation, review, and optimization

### 🔨 **C++ Development**  
- Complete **CMake compilation system** with smart error handling
- **Multiple compiler support** (gcc/clang/mingw/msvc/custom)
- **TreeSitter** and **LSP** integration (clangd)
- Object file management and build cleaning

### 🎨 **Visual Enhancements**
- **Intense green comments** (`#00ff66`)
- **2-space indentation** by default
- **Hidden file search** in Telescope

### ⌨️ **Enhanced Keybindings**
- **Multiple escape options** (Esc, jk, Ctrl+[, Ctrl+C)
- **Intuitive shortcuts** for all development tasks
- **Quick access** to compilation and AI features

## 🚀 Quick Start

### 1. **Setup Copilot**
```bash
:Copilot auth
```

### 2. **C++ Development Workflow**
```bash
<leader>gcs  # Select compiler (gcc/clang/etc)
<leader>G++  # Generate CMake config
<leader>g++  # Compile current file
<leader>g+r  # Compile and run
```

### 3. **AI Assistance**
```bash
<leader>cc   # Toggle Copilot Chat
<leader>ce   # Explain selected code
<leader>cr   # Review code for issues
<leader>cf   # Fix problems
```

## 📚 Key Shortcuts

### **Copilot**
| Shortcut | Action |
|----------|--------|
| `Tab` | Accept AI suggestion |
| `Ctrl+Right` | Accept word |
| `Ctrl+]` / `Ctrl+[` | Navigate suggestions |
| `<leader>cc` | Toggle Chat |
| `<leader>ce` | Explain code |
| `<leader>cr` | Review code |

### **C++ Compilation**
| Shortcut | Action |
|----------|--------|
| `<leader>g++` | Compile current file |
| `<leader>g+r` | Compile and run |
| `<leader>G++` | Generate CMake config |
| `<leader>gcs` | Select compiler |
| `<leader>g--` | Clean current objects |
| `<leader>G--` | Clean all |

### **Enhanced Navigation**
| Shortcut | Action |
|----------|--------|
| `<leader>tff` | Find files (includes hidden) |
| `<leader>tfh` | Find hidden files |
| `<leader>tlg` | Live grep (includes hidden) |
| `jk` | Escape to normal mode |

## 📁 Configuration Structure

### **Core Files**
- `init.lua` - Main configuration entry
- `lua/chadrc.lua` - Theme and UI (green comments)
- `lua/options.lua` - Editor settings (2-space indent)
- `lua/mappings.lua` - All keymaps
- `lua/plugins/init.lua` - Plugin configuration

### **Development Tools**
- `lua/configs/lspconfig.lua` - Language server setup
- `lua/local/` - Git-ignored local configurations
  - `cpp-config.lua` - C++ development setup
  - `cmake-compile.lua` - Compilation system
  - `plugins.lua` - Local plugin configs

### **Documentation**
- `README.md` - This overview
- `copilot.readme.md` - Comprehensive usage guide

## 🛠️ Smart Features

### **Compilation System**
- **Success**: Modal notifications (clean, non-intrusive)
- **Errors**: Detailed buffer with full compiler output
- **Multi-compiler**: Easy switching between toolchains
- **CMake integration**: Uses exact project build settings

### **AI Integration**
- **Context-aware**: Understands your project structure
- **Code analysis**: Explain, review, optimize any selection
- **Learning tool**: Ask questions about algorithms and patterns
- **Documentation**: Auto-generate comments and tests

### **Enhanced Search**
- **Hidden files**: Searches dotfiles and config files
- **Smart ignore**: Respects .gitignore while showing hidden files
- **Fast navigation**: Ivy theme with fuzzy matching

## 📖 Detailed Documentation

For comprehensive guides and troubleshooting, see:
- **[copilot.readme.md](copilot.readme.md)** - Complete usage guide
- **[Configuration Changes](copilot.readme.md#configuration-changes)** - What's been customized

## 🏗️ Built With

### **Base Framework**
- **[NvChad](https://github.com/NvChad/NvChad)** - Beautiful, fast Neovim configuration
- **[Lazy.nvim](https://github.com/folke/lazy.nvim)** - Modern plugin manager

### **Key Plugins**
- **[copilot.lua](https://github.com/zbirenbaum/copilot.lua)** - GitHub Copilot integration
- **[CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim)** - AI chat interface
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Syntax highlighting
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - Language server support

## 🎯 Usage Philosophy

This configuration prioritizes:
- **Developer productivity** with AI assistance
- **C++ development** with professional tooling  
- **Clean visual design** with meaningful colors
- **Intuitive keybindings** that make sense
- **Smart error handling** that helps, doesn't hinder
- **Modular organization** for easy customization

---

*Built for efficient C++ development with AI assistance* 🚀
