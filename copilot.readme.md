# Neovim Configuration Guide

A comprehensive guide to your complete Neovim development environment including GitHub Copilot, C++ development, and CMake integration.

## Table of Contents
- [Configuration Changes](#configuration-changes)
- [Setup & Authentication](#setup--authentication)
- [Copilot Shortcuts](#copilot-shortcuts)
- [C++ Compiling Shortcuts](#c-compiling-shortcuts)
- [Copilot Completions](#copilot-completions)
- [Copilot Chat](#copilot-chat)
- [Keymaps Reference](#keymaps-reference)
- [Troubleshooting](#troubleshooting)
- [Pro Tips](#pro-tips)

---

## Configuration Changes

### Files Modified/Created

#### **Core Configuration Files**
- **`lua/chadrc.lua`** - Comment color set to intense green (`#00ff66`)
- **`lua/options.lua`** - 2-space indentation by default, enhanced Esc key fixes
- **`lua/plugins/init.lua`** - Copilot enabled, CopilotChat added, Codeium removed, Telescope hidden files
- **`lua/mappings.lua`** - CMake compilation keymaps, Copilot Chat shortcuts, enhanced escapes
- **`lua/configs/lspconfig.lua`** - C++ LSP integration with clangd and cmake-language-server
- **`init.lua`** - Plugin loading system updated for local configurations

#### **Local Development Configuration (Git-Ignored)**
- **`lua/local/cpp-config.lua`** - Complete C++ development setup
- **`lua/local/cmake-compile.lua`** - Advanced CMake compilation system with smart error handling
- **`lua/local/plugins.lua`** - Local plugin configuration for C++ development
- **`.gitignore`** - Excludes local configurations from git tracking

#### **Documentation**
- **`copilot.readme.md`** - This comprehensive guide

### Key Features Added
- **🤖 AI Development**: GitHub Copilot with intuitive keymaps, Copilot Chat integration
- **🔨 C++ Development**: Complete CMake system, multiple compiler support, smart error handling
- **🎨 Visual**: Intense green comments, 2-space indentation
- **🔍 Enhanced Search**: Telescope searches hidden files
- **⌨️ Fixed Keybindings**: Multiple escape options, intuitive shortcuts

---

## Setup & Authentication

### First Time Setup

1. **Authenticate with GitHub**:
   ```bash
   :Copilot auth
   ```
   This opens your browser and asks you to sign in to GitHub.

2. **Check Status**:
   ```bash
   :checkhealth copilot
   ```
   Verifies everything is working correctly.

3. **Requirements**:
   - Active GitHub Copilot subscription (GitHub Pro, Team, or Enterprise)
   - Internet connection
   - Authenticated GitHub account

---

## Copilot Shortcuts

### Quick Reference

| Shortcut | Action | Description |
|----------|--------|-------------|
| **`Tab`** | Accept suggestion | Accept the entire AI suggestion |
| **`Ctrl+Right`** | Accept word | Accept only the next word |
| **`Ctrl+L`** | Accept line | Accept only the current line |
| **`Ctrl+]`** | Next suggestion | Cycle to next alternative |
| **`Ctrl+[`** | Previous suggestion | Cycle to previous alternative |
| **`Ctrl+E`** | Dismiss | Hide current suggestion |

### Chat Shortcuts

| Shortcut | Action | Description |
|----------|--------|-------------|
| **`<leader>cc`** | Toggle Chat | Open/close Copilot Chat window |
| **`<leader>ce`** | Explain | Explain selected code |
| **`<leader>cr`** | Review | Review selected code for issues |
| **`<leader>cf`** | Fix | Fix problems in selected code |
| **`<leader>co`** | Optimize | Optimize selected code |
| **`<leader>cd`** | Document | Add documentation |
| **`<leader>ct`** | Tests | Generate unit tests |

### Chat Window Navigation

| Key | Mode | Action |
|-----|------|--------|
| **`Enter`** | Normal | Submit question |
| **`Ctrl+S`** | Insert | Submit question |
| **`q`** | Normal | Close chat |
| **`Ctrl+C`** | Insert | Close chat |
| **`Ctrl+R`** | Both | Reset chat history |

---

## C++ Compiling Shortcuts

### Compilation Commands

| Shortcut | Action | Description |
|----------|--------|-------------|
| **`<leader>g++`** | Compile | Compile current C++ file using CMake commands |
| **`<leader>g+r`** | Compile & Run | Compile and run current C++ file |
| **`<leader>G++`** | Generate | Generate `compile_commands.json` |
| **`<leader>cmk`** | Custom CMake | Prompt for custom CMake command |

### Cleaning Commands

| Shortcut | Action | Description |
|----------|--------|-------------|
| **`<leader>g--`** | Clean Current | Clean object file for current compilation unit |
| **`<leader>G--`** | Clean All | Clean entire build directory |

### Compiler Management

| Shortcut | Action | Description |
|----------|--------|-------------|
| **`<leader>gcs`** | Select Compiler | Choose compiler (gcc/clang/mingw/msvc/custom) |
| **`<leader>gci`** | Compiler Info | Show current compiler information |
| **`<leader>gcc`** | Custom Compiler | Setup custom compiler paths |

### Compilation Workflow

```bash
# 1. Select your compiler
<leader>gcs  # Choose gcc, clang, mingw, etc.

# 2. Generate CMake configuration
<leader>G++  # Creates compile_commands.json

# 3. Compile your code
<leader>g++  # Smart output: modal on success, buffer on error

# 4. Or compile and run
<leader>g+r  # Compile first, then run if successful

# 5. Clean when needed
<leader>g--  # Clean current file's objects
<leader>G--  # Clean entire build
```

### Smart Error Handling

- **✅ Success**: Shows modal notification (e.g., "✓ Compiled successfully: main.o")
- **❌ Error**: Opens detailed error buffer with:
  - Exact command executed
  - Full compiler output
  - Line numbers and error details
  - Easy navigation (`q` or `Esc` to close)

---

## Copilot Completions

### How It Works

Copilot analyzes your code context and provides AI-powered suggestions as you type. Suggestions appear as gray "ghost text" that you can accept or cycle through.

### Completion Keymaps

| Key | Action | Description |
|-----|--------|-------------|
| **`Tab`** | Accept suggestion | Accept the entire suggestion |
| **`Ctrl+Right`** | Accept word | Accept only the next word |
| **`Ctrl+L`** | Accept line | Accept only the current line |
| **`Ctrl+]`** | Next suggestion | Cycle to next alternative |
| **`Ctrl+[`** | Previous suggestion | Cycle to previous alternative |
| **`Ctrl+E`** | Dismiss | Hide current suggestion |

### Usage Examples

#### Basic Completion
```cpp
// You type:
int factorial(int n) {
    if (n <= 1) return 1;
    // Copilot suggests: return n * factorial(n - 1);

// Press Tab to accept the entire suggestion
// Press Ctrl+Right to accept just "return"
// Press Ctrl+] to see alternative implementations
```

#### Comment-Driven Development
```cpp
// Write descriptive comments first:
// Function to sort an array using quicksort algorithm
void quicksort(int arr[], int low, int high) {
    // Copilot will suggest the entire quicksort implementation
}
```

#### Partial Acceptance
```cpp
// Copilot suggests: std::vector<int> numbers = {1, 2, 3, 4, 5};
std::vector<int> num|  // cursor here

// Press Ctrl+Right → accepts "numbers"
// Press Ctrl+Right again → accepts " = {1,"
// Press Tab → accepts rest of suggestion
```

### Supported Languages

Copilot is enabled for:
- **C/C++** (primary development)
- **Lua** (Neovim configuration)
- **Python, JavaScript, TypeScript**
- **Markdown** (documentation)

---

## Copilot Chat

### Opening Chat

| Method | Command/Keymap | Description |
|--------|----------------|-------------|
| **Keymap** | `<leader>cc` | Toggle chat window |
| **Command** | `:CopilotChat` | Open chat interface |
| **Command** | `:CopilotChatToggle` | Toggle chat window |

### Chat Interface

```
┌─────────────────────────────────────┐
│ Your code (main window)             │
│                                     │
├─────────────────────────────────────┤
│ [Copilot Chat]                      │
│                                     │
│ ## User                             │
│ How do I optimize this algorithm?   │
│                                     │
│ ## Copilot                          │
│ Here are several optimization...    │
│ 1. Use std::sort instead            │
│ 2. Implement quicksort              │
│ 3. Consider parallel sorting        │
│                                     │
│ > Type your question here...        │
└─────────────────────────────────────┘
```

### Chat Navigation

| Key | Mode | Action |
|-----|------|--------|
| **`Enter`** | Normal | Submit question |
| **`Ctrl+S`** | Insert | Submit question |
| **`q`** | Normal | Close chat |
| **`Ctrl+C`** | Insert | Close chat |
| **`Ctrl+R`** | Both | Reset chat history |
| **`Tab`** | Insert | Autocomplete (`@<Tab>` or `/<Tab>`) |

### Quick Actions with Code

Select code in visual mode, then use these keymaps:

| Keymap | Action | Description |
|--------|--------|-------------|
| **`<leader>ce`** | Explain | Explain selected code |
| **`<leader>cr`** | Review | Review code for issues |
| **`<leader>cf`** | Fix | Fix problems in code |
| **`<leader>co`** | Optimize | Optimize performance |
| **`<leader>cd`** | Document | Add documentation |
| **`<leader>ct`** | Test | Generate unit tests |

### Usage Workflows

#### 1. General Questions
```bash
# Open chat
<leader>cc

# Type questions like:
"How do I implement a binary search tree in C++?"
"What's the difference between malloc and new?"
"How can I optimize this algorithm?"

# Press Enter to submit
```

#### 2. Code Analysis
```cpp
// Select this code in visual mode:
void bubbleSort(int arr[], int n) {
    for (int i = 0; i < n-1; i++) {
        for (int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                swap(arr[j], arr[j+1]);
            }
        }
    }
}

// Then use quick actions:
<leader>ce  // "Explain this sorting algorithm"
<leader>cr  // "Review this code for issues"
<leader>co  // "How can I optimize this?"
<leader>ct  // "Generate unit tests"
```

#### 3. Debugging Help
```cpp
// Problematic code:
char* getString() {
    char buffer[100];
    strcpy(buffer, "Hello World");
    return buffer;  // BUG: returning local array
}

// Select code, press <leader>cf
// Copilot will identify the stack memory issue and suggest fixes
```

#### 4. Learning & Documentation
```cpp
// Select a complex function
<leader>ce  // Get detailed explanation
<leader>cd  // Add proper documentation comments
```

---

## Keymaps Reference

### Copilot Completions
```
Tab         - Accept entire suggestion
Ctrl+Right  - Accept next word
Ctrl+L      - Accept current line
Ctrl+]      - Next suggestion
Ctrl+[      - Previous suggestion
Ctrl+E      - Dismiss suggestion
```

### Copilot Chat
```
<leader>cc  - Toggle chat window
<leader>ce  - Explain selected code
<leader>cr  - Review selected code
<leader>cf  - Fix selected code
<leader>co  - Optimize selected code
<leader>cd  - Add documentation
<leader>ct  - Generate tests
```

### Chat Window Navigation
```
Enter       - Submit (normal mode)
Ctrl+S      - Submit (insert mode)
q           - Close chat
Ctrl+C      - Close chat (insert mode)
Ctrl+R      - Reset chat
Tab         - Autocomplete
```

### Escape Keys (Multiple Options)
```
Esc         - Standard escape
jk          - Custom escape mapping
Ctrl+[      - Universal Vim escape
Ctrl+C      - Force interrupt
```

---

## Troubleshooting

### Common Issues

#### 1. Copilot Not Working
```bash
# Check authentication
:Copilot auth

# Check health
:checkhealth copilot

# Verify status
:Copilot status
```

#### 2. No Suggestions Appearing
- Ensure you're in insert mode
- Check if you have an active internet connection
- Verify your GitHub Copilot subscription is active
- Try typing more context (comments, function signatures)

#### 3. Chat Not Responding
```bash
# Check if chat window is focused
# Try alternative submit keys:
Ctrl+S      # Instead of Enter
:CopilotChatToggle  # Restart chat
```

#### 4. Escape Key Issues
Multiple escape options available:
- `jk` (custom mapping)
- `Ctrl+[` (universal)
- `Ctrl+C` (force)

#### 5. Plugin Conflicts
```bash
# Check what's mapped to a key
:verbose map <key>

# Check for conflicting plugins
:map <Esc>
:imap <Tab>
```

### Debug Commands

```bash
:checkhealth copilot        # Overall health check
:CopilotChatToggle         # Restart chat
:verbose map <key>         # Check key mappings
:Copilot status           # Check Copilot status
```

---

## Pro Tips

### 1. Better Suggestions
- **Write descriptive comments** before functions
- **Use meaningful variable names**
- **Be consistent with coding style**
- **Provide context** in comments

### 2. Effective Chat Usage
- **Be specific** in questions
- **Provide context** about your problem
- **Ask follow-up questions** for clarification
- **Use code selection** for targeted help

### 3. Workflow Optimization
```cpp
// 1. Write comment describing what you want
// Function to calculate fibonacci numbers efficiently

// 2. Start typing function signature
int fibonacci(int n) {

// 3. Let Copilot suggest implementation
// 4. Use chat for optimization questions
```

### 4. Learning Approach
- Use `<leader>ce` to understand unfamiliar code
- Use `<leader>cr` to learn best practices
- Ask "why" questions in chat for deeper understanding

### 5. Code Quality
- Use `<leader>cr` for code reviews
- Use `<leader>ct` to ensure good test coverage
- Use `<leader>cd` for proper documentation

---

## Example Workflows

### Complete Development Cycle

```cpp
// 1. Start with a comment
// Implement a thread-safe singleton pattern

// 2. Let Copilot suggest the class structure
class Singleton {
    // Copilot suggests implementation
};

// 3. Select the code and review it
<leader>cr  // "Review this singleton implementation"

// 4. Ask for improvements
<leader>co  // "How can I make this more thread-safe?"

// 5. Generate tests
<leader>ct  // "Generate unit tests for this singleton"

// 6. Add documentation
<leader>cd  // "Add proper documentation comments"
```

### Debugging Session

```cpp
// 1. Identify problematic code
int divide(int a, int b) {
    return a / b;  // Potential division by zero
}

// 2. Ask for fixes
<leader>cf  // Copilot suggests error handling

// 3. Learn about the issue
<leader>ce  // "Explain why this code is problematic"

// 4. Get comprehensive solution
// Open chat: "How do I handle division by zero in C++?"
```

---

## Configuration Notes

This setup includes:
- **Intuitive keymaps** (Tab for accept, Ctrl+combinations)
- **Multiple escape options** (Esc, jk, Ctrl+[, Ctrl+C)
- **Smart chat integration** with quick actions
- **Comprehensive language support**
- **Robust error handling** and fallbacks

For configuration details, see:
- `lua/plugins/init.lua` - Plugin configuration
- `lua/mappings.lua` - Keymap definitions  
- `lua/options.lua` - General options and autocmds
- `lua/configs/lspconfig.lua` - LSP configuration
- `lua/local/` - Local development configurations (git-ignored)
- `lua/chadrc.lua` - Theme and UI customizations

---

*Happy coding with AI assistance! 🚀*
