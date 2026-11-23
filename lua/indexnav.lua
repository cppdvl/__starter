-- indexnav: jump between "indexable" items (identifiers) using treesitter.
--
--   t.     next identifier (same line first, then following lines)
--   t..    first identifier of the next line (that has one) inside the current function
--   t...   name of the next function
--   ttlg   Telescope live_grep for the identifier under the cursor
--   t+     go to definition (C/C++: declaration, usually the header)
--   t, t,, t,,,   same as t. t.. t... but backwards
--   t-     go back to where the last t+ came from (stack of t+ jumps)

local M = {}

local api = vim.api

-- Node types considered "indexable".
local function is_ident(node)
  local t = node:type()
  return t:match "identifier$" ~= nil or t == "name" or t == "word"
end

local function is_function(node)
  local t = node:type()
  if t:match "call" or t:match "parameter" or t:match "declarator" or t:match "type$" then
    return false
  end
  return t:match "function" ~= nil
    or t:match "method_definition" ~= nil
    or t:match "method_declaration" ~= nil
    or t:match "lambda" ~= nil
    or t == "function_item" -- rust
    or t == "arrow_function"
end

local function get_root(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return nil
  end
  parser:parse(true)
  return parser
end

-- All identifier leaves within [srow, erow] (0-based, inclusive), sorted by position.
local function collect_idents(bufnr, srow, erow)
  local parser = get_root(bufnr)
  if not parser then
    return nil
  end
  local out = {}
  parser:for_each_tree(function(tree)
    local root = tree:root()
    local function walk(node)
      local nsr, _, ner, _ = node:range()
      if ner < srow or nsr > erow then
        return
      end
      if node:named_child_count() == 0 then
        if is_ident(node) then
          local r, c = node:start()
          out[#out + 1] = { r, c, node }
        end
        return
      end
      for child in node:iter_children() do
        if child:named() then
          walk(child)
        end
      end
    end
    walk(root)
  end)
  table.sort(out, function(a, b)
    return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2])
  end)
  -- dedupe (injected trees may overlap)
  local res, last = {}, nil
  for _, it in ipairs(out) do
    local key = it[1] .. ":" .. it[2]
    if key ~= last then
      res[#res + 1] = it
      last = key
    end
  end
  return res
end

local function cursor()
  local pos = api.nvim_win_get_cursor(0)
  return pos[1] - 1, pos[2]
end

local function jump(row, col, push_jumplist)
  if push_jumplist then
    vim.cmd "normal! m'"
  end
  api.nvim_win_set_cursor(0, { row + 1, col })
end

local function enclosing_function(node)
  while node do
    if is_function(node) then
      return node
    end
    node = node:parent()
  end
end

local function node_at_cursor()
  local ok, node = pcall(vim.treesitter.get_node, { ignore_injections = false })
  return ok and node or nil
end

-- t. / t, ------------------------------------------------------------------
-- Next/previous identifier; when the line runs out, continue on the following
-- (or preceding) lines. Scans in chunks so huge files stay fast.
local CHUNK = 200

local function words_in_line(r)
  local line = api.nvim_buf_get_lines(0, r, r + 1, false)[1] or ""
  local out, init = {}, 1
  while true do
    local s, e = line:find("[%a_][%w_]*", init)
    if not s then
      return out
    end
    out[#out + 1] = { r, s - 1 }
    init = e + 1
  end
end

local function items_in(srow, erow)
  local items = collect_idents(0, srow, erow)
  if items then
    return items
  end
  local out = {} -- no treesitter: plain words
  for r = srow, erow do
    vim.list_extend(out, words_in_line(r))
  end
  return out
end

local function after(it, row, col)
  return it[1] > row or (it[1] == row and it[2] > col)
end

local function before(it, row, col)
  return it[1] < row or (it[1] == row and it[2] < col)
end

function M.next_in_line()
  local row, col = cursor()
  local last = api.nvim_buf_line_count(0) - 1
  local srow = row
  while srow <= last do
    local erow = math.min(last, srow + CHUNK - 1)
    for _, it in ipairs(items_in(srow, erow)) do
      if after(it, row, col) then
        return jump(it[1], it[2])
      end
    end
    srow = erow + 1
  end
end

function M.prev_in_line()
  local row, col = cursor()
  local erow = row
  while erow >= 0 do
    local srow = math.max(0, erow - CHUNK + 1)
    local items = items_in(srow, erow)
    for i = #items, 1, -1 do
      if before(items[i], row, col) then
        return jump(items[i][1], items[i][2])
      end
    end
    erow = srow - 1
  end
end

-- t.. -----------------------------------------------------------------------
function M.next_in_function()
  local row = cursor()
  local fn = enclosing_function(node_at_cursor())
  local srow, erow
  if fn then
    srow, _, erow, _ = fn:range()
  else
    srow, erow = row, api.nvim_buf_line_count(0) - 1
  end
  local items = collect_idents(0, row + 1, erow)
  if not items then
    return vim.notify("indexnav: no treesitter parser for this buffer", vim.log.levels.WARN)
  end
  for _, it in ipairs(items) do
    if it[1] > row and it[1] <= erow then
      return jump(it[1], it[2], true)
    end
  end
end

-- t,, -----------------------------------------------------------------------
function M.prev_in_function()
  local row = cursor()
  local fn = enclosing_function(node_at_cursor())
  local srow = fn and select(1, fn:range()) or 0
  if row == 0 then
    return
  end
  local items = collect_idents(0, srow, row - 1)
  if not items then
    return vim.notify("indexnav: no treesitter parser for this buffer", vim.log.levels.WARN)
  end
  -- first identifier of the closest previous line that has one
  local target_row
  for i = #items, 1, -1 do
    if items[i][1] < row and items[i][1] >= srow then
      target_row = items[i][1]
      break
    end
  end
  if not target_row then
    return
  end
  for _, it in ipairs(items) do
    if it[1] == target_row then
      return jump(it[1], it[2], true)
    end
  end
end

-- Name node of a function (handles C/C++ nested declarators).
local function function_name(fn)
  local node = fn
  for _ = 1, 6 do
    local name = node:field("name")[1]
    if name then
      -- e.g. C++ qualified_identifier: take the last identifier
      if name:named_child_count() > 0 then
        local last
        for child in name:iter_children() do
          if child:named() and is_ident(child) then
            last = child
          end
        end
        return last or name
      end
      return name
    end
    local decl = node:field("declarator")[1]
    if not decl then
      break
    end
    if is_ident(decl) and decl:named_child_count() == 0 then
      return decl
    end
    node = decl
  end
  -- fallback: first identifier inside fn that isn't a type
  local r = fn:start()
  local items = collect_idents(0, r, r) or {}
  for _, it in ipairs(items) do
    if not it[3]:type():match "type" and fn:child_with_descendant(it[3]) ~= nil then
      return it[3]
    end
  end
  return fn
end

-- t... ----------------------------------------------------------------------
function M.next_function()
  local row = cursor()
  local parser = get_root(0)
  if not parser then
    return vim.notify("indexnav: no treesitter parser for this buffer", vim.log.levels.WARN)
  end
  local best
  parser:for_each_tree(function(tree)
    local function walk(node)
      local nsr, _, ner, _ = node:range()
      if ner <= row then
        return
      end
      if nsr > row and is_function(node) then
        if not best or nsr < select(1, best:start()) then
          best = node
        end
        return -- don't descend; the outer function is the "next" one
      end
      for child in node:iter_children() do
        if child:named() then
          walk(child)
        end
      end
    end
    walk(tree:root())
  end)
  if not best then
    return vim.notify("indexnav: no next function", vim.log.levels.INFO)
  end
  local r, c = function_name(best):start()
  jump(r, c, true)
end

-- t,,, ---------------------------------------------------------------------
function M.prev_function()
  local row = cursor()
  local parser = get_root(0)
  if not parser then
    return vim.notify("indexnav: no treesitter parser for this buffer", vim.log.levels.WARN)
  end
  local best
  parser:for_each_tree(function(tree)
    local function walk(node)
      local nsr = node:range()
      if nsr >= row then
        return
      end
      if is_function(node) and (not best or nsr > select(1, best:start())) then
        best = node
      end
      for child in node:iter_children() do
        if child:named() then
          walk(child)
        end
      end
    end
    walk(tree:root())
  end)
  if not best then
    return vim.notify("indexnav: no previous function", vim.log.levels.INFO)
  end
  local r, c = function_name(best):start()
  jump(r, c, true)
end

-- ttlg ----------------------------------------------------------------------
function M.grep_item()
  local node = node_at_cursor()
  local text
  if node and is_ident(node) then
    text = vim.treesitter.get_node_text(node, 0)
  else
    text = vim.fn.expand "<cword>"
  end
  if text == "" then
    return
  end
  require("telescope.builtin").live_grep { default_text = text }
end

-- t+ / t- ------------------------------------------------------------------
-- Positions t+ jumped away from, so t- can walk back exactly through them.
local back_stack = {}

local function remember(origin)
  vim.cmd "normal! m'"
  back_stack[#back_stack + 1] = origin
end

local function here()
  local p = api.nvim_win_get_cursor(0)
  return { buf = api.nvim_get_current_buf(), file = api.nvim_buf_get_name(0), row = p[1], col = p[2] }
end

function M.go_back()
  while #back_stack > 0 do
    local o = table.remove(back_stack)
    local cur = here()
    if not (o.buf == cur.buf and o.row == cur.row and o.col == cur.col) then
      vim.cmd "normal! m'"
      if api.nvim_buf_is_valid(o.buf) then
        api.nvim_set_current_buf(o.buf)
      elseif o.file ~= "" then
        vim.cmd.edit(vim.fn.fnameescape(o.file))
      else
        goto continue
      end
      pcall(api.nvim_win_set_cursor, 0, { o.row, o.col })
      return
    end
    ::continue::
  end
  vim.notify("indexnav: nothing to go back to", vim.log.levels.INFO)
end

local C_FT = { c = true, cpp = true, objc = true, objcpp = true, cuda = true }
local HEADER_GLOBS = { "*.h", "*.hh", "*.hpp", "*.hxx", "*.inl" }

local function same_loc(loc, bufnr, row)
  local uri = loc.uri or loc.targetUri
  local range = loc.range or loc.targetSelectionRange
  return uri == vim.uri_from_bufnr(bufnr) and range ~= nil and range.start.line == row
end

local function item_under_cursor()
  local node = node_at_cursor()
  if node and is_ident(node) then
    return vim.treesitter.get_node_text(node, 0)
  end
  return vim.fn.expand "<cword>"
end

local function project_root(bufnr)
  return vim.fs.root(bufnr, { "compile_commands.json", "CMakePresets.json", ".git", "pyproject.toml", "package.json" })
    or vim.fn.getcwd()
end

-- Fallback when the LSP can't resolve the symbol (e.g. clangd without compile_commands.json):
-- ripgrep the project for the whole word. C/C++ searches headers first.
-- One hit -> jump straight there; several -> Telescope picker.
local function grep_fallback(bufnr, word, reason, origin)
  if word == "" then
    return
  end
  local root = project_root(bufnr)
  local is_c = C_FT[vim.bo[bufnr].filetype]
  local globs = is_c and HEADER_GLOBS or {}
  local function rg(gl)
    local cmd = { "rg", "--vimgrep", "-w", "-F", "--hidden", "--glob", "!.git/*" }
    for _, g in ipairs(gl) do
      vim.list_extend(cmd, { "--glob", g })
    end
    vim.list_extend(cmd, { "--", word, root })
    local res = vim.system(cmd, { text = true }):wait()
    return vim.split(vim.trim(res.stdout or ""), "\n", { trimempty = true }), gl
  end
  local lines, used = rg(globs)
  if #lines == 0 and #globs > 0 then
    lines, used = rg {}
  end
  if #lines == 0 then
    return vim.notify(("indexnav: '%s' not found (%s)"):format(word, reason), vim.log.levels.INFO)
  end
  -- A unique type/macro definition (not a forward declaration) wins outright.
  local defs = {}
  for _, ln in ipairs(lines) do
    local text = ln:match "^.-:%d+:%d+:(.*)$" or ""
    for _, kw in ipairs { "class", "struct", "union", "enum", "enum class", "namespace", "#%s*define", "def", "function" } do
      if text:match("^%s*" .. kw .. "%s+[%w_]*%s*" .. vim.pesc(word) .. "%f[^%w_]") and not text:match ";%s*$" then
        defs[#defs + 1] = ln
        break
      end
    end
  end
  if #defs == 1 then
    lines = defs
  end
  if #lines == 1 then
    local file, l, c = lines[1]:match "^(.-):(%d+):(%d+):"
    remember(origin)
    vim.cmd.edit(vim.fn.fnameescape(file))
    return api.nvim_win_set_cursor(0, { tonumber(l), tonumber(c) - 1 })
  end
  vim.notify(("indexnav: %s - grepping '%s'"):format(reason, word), vim.log.levels.INFO)
  remember(origin)
  require("telescope.builtin").grep_string {
    search = word,
    word_match = "-w",
    cwd = root,
    prompt_title = ("t+ %s%s"):format(word, #used > 0 and " (headers)" or ""),
    additional_args = function()
      local a = { "--hidden", "--glob", "!.git/*" }
      for _, g in ipairs(used) do
        vim.list_extend(a, { "--glob", g })
      end
      return a
    end,
  }
end

-- C++: is the cursor on a method declared inside a class/struct body?
-- Text-based (treesitter gets confused by export macros like `class DLLEXPORT Foo`).
-- Returns { class = "Foo", method = "bar" | "~Foo" } or nil.
local function class_member_at_cursor()
  local row, col = cursor()
  local line = api.nvim_get_current_line()
  -- word under cursor and what follows it
  local s, e = 1, 0
  repeat
    s, e = line:find("[%a_][%w_]*", e + 1)
  until not s or e > col
  if not s or s - 1 > col then
    return nil
  end
  local method = line:sub(s, e)
  if not line:sub(e + 1):match "^%s*%(" then
    return nil -- not a function declaration (data member, type, ...)
  end
  if line:sub(1, s - 1):match "~%s*$" then
    method = "~" .. method
  end
  -- walk backwards to the unmatched '{' that encloses the cursor
  local depth = 0
  local lines = api.nvim_buf_get_lines(0, math.max(0, row - 3000), row + 1, false)
  local base = math.max(0, row - 3000)
  for i = #lines, 1, -1 do
    local l = lines[i]
    if i == #lines then
      l = l:sub(1, s - 1)
    end
    l = l:gsub("//.*$", ""):gsub('"[^"]*"', ""):gsub("'[^']*'", "")
    for j = #l, 1, -1 do
      local ch = l:sub(j, j)
      if ch == "}" then
        depth = depth + 1
      elseif ch == "{" then
        if depth == 0 then
          -- header of this block: text before '{' on this line plus up to 3 previous lines
          local head = l:sub(1, j - 1)
          -- brace on its own line (Allman style): pull in the preceding declaration lines
          for k = i - 1, math.max(1, i - 3), -1 do
            if head:match "[%w_]" and not head:match "^%s*:" then
              break
            end
            local prev = lines[k]:gsub("//.*$", "")
            if prev:match "[;{}]%s*$" then
              break
            end
            head = prev .. " " .. head
          end
          head = head:gsub("%b<>", "") -- drop template args
          local _, kwe = head:find "%f[%w_]class%s"
          if not kwe then
            _, kwe = head:find "%f[%w_]struct%s"
          end
          if not kwe then
            return nil -- enclosing block is a namespace / function / ...
          end
          local decl = head:sub(kwe + 1):gsub("%s*:[^:].*$", ""):gsub("%f[%w_]final%f[^%w_]", "")
          local cls
          for w in decl:gmatch "[%a_][%w_]*" do
            cls = w -- last word wins: skips export macros
          end
          return cls and { class = cls, method = method, row = base + i - 1 } or nil
        end
        depth = depth - 1
      end
    end
  end
end

local SOURCE_GLOBS = { "*.cpp", "*.cc", "*.cxx", "*.c++", "*.c", "*.mm", "*.m", "*.inl", "*.tpp", "*.ipp", "*.h", "*.hh", "*.hpp", "*.hxx" }

-- Jump if there is one hit, otherwise show exactly these hits in Telescope.
local function jump_or_pick(hits, title, origin)
  if #hits == 1 then
    local file, l, c = hits[1]:match "^(.-):(%d+):(%d+):"
    remember(origin)
    vim.cmd.edit(vim.fn.fnameescape(file))
    return api.nvim_win_set_cursor(0, { tonumber(l), tonumber(c) - 1 })
  end
  remember(origin)
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local make_entry = require "telescope.make_entry"
  pickers
    .new(require("telescope.themes").get_ivy(), {
      prompt_title = title,
      finder = finders.new_table { results = hits, entry_maker = make_entry.gen_from_vimgrep {} },
      previewer = conf.grep_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

-- Number of parameters in the first (...) after `name`, or nil if it isn't closed on this line.
local function param_count(text, name)
  local _, e = text:find(vim.pesc(name) .. "%s*%(")
  if not e then
    return nil
  end
  local inner = text:sub(e):match "^(%b())"
  if not inner then
    return nil
  end
  inner = inner:sub(2, -2):gsub("%b()", ""):gsub("%b<>", ""):gsub("%b{}", "")
  if inner:match "^%s*$" or inner:match "^%s*void%s*$" then
    return 0
  end
  return select(2, inner:gsub(",", "")) + 1
end

-- Find `Class::method(` definitions (not calls) in the project.
local function find_implementation(bufnr, member, origin)
  local root = project_root(bufnr)
  local qual = member.class .. "(<[^>]*>)?::" .. member.method:gsub("~", "~\\s*")
  local cmd = { "rg", "--vimgrep", "--hidden", "--glob", "!.git/*", "-e", "\\b" .. qual .. "\\s*\\(" }
  for _, g in ipairs(SOURCE_GLOBS) do
    vim.list_extend(cmd, { "--glob", g })
  end
  vim.list_extend(cmd, { "--", root })
  local res = vim.system(cmd, { text = true }):wait()
  local hits = {}
  for _, ln in ipairs(vim.split(vim.trim(res.stdout or ""), "\n", { trimempty = true })) do
    local text = ln:match "^.-:%d+:%d+:(.*)$" or ""
    local before = text:match("^(.-)%f[%w_]" .. vim.pesc(member.class)) or ""
    -- a definition: nothing like `x = `, `foo(`, `return ` before it, and no trailing `;`
    if not before:match "[=(,]" and not before:match "%f[%w_]return%f[^%w_]" and not text:match ";%s*$" then
      hits[#hits + 1] = ln
    end
  end
  if #hits == 0 then
    return vim.notify(
      ("indexnav: no implementation of %s::%s found (inline, pure virtual or defaulted?)"):format(member.class, member.method),
      vim.log.levels.INFO
    )
  end
  -- Overloads: keep the ones whose parameter count matches the declaration
  if #hits > 1 then
    local want = param_count(api.nvim_get_current_line(), member.method:gsub("^~", ""))
    if want then
      local same = vim.tbl_filter(function(ln)
        return param_count(ln:match "^.-:%d+:%d+:(.*)$" or "", member.class .. "::" .. member.method) == want
      end, hits)
      if #same >= 1 then
        hits = same
      end
    end
  end
  jump_or_pick(hits, ("t+ %s::%s implementation"):format(member.class, member.method), origin)
end

function M.goto_definition()
  local bufnr = api.nvim_get_current_buf()
  local word = item_under_cursor()
  local origin = here()
  local clients = vim.lsp.get_clients { bufnr = bufnr, method = "textDocument/definition" }
  local member = C_FT[vim.bo[bufnr].filetype] and vim.bo[bufnr].filetype ~= "c" and class_member_at_cursor()

  if member then
    -- Method declared in a class/struct: go to its implementation.
    local client = clients[1]
    if not client then
      return find_implementation(bufnr, member, origin)
    end
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    return client:request("textDocument/definition", params, function(err, result)
      local loc = not err and result and not vim.tbl_isempty(result) and (vim.islist(result) and result[1] or result)
      -- Trust the server only if it lands on a line that really is `...Class::method...`
      -- (without compile_commands.json clangd may parse a .h as C and answer nonsense).
      local ok_target = false
      if loc and not same_loc(loc, bufnr, params.position.line) then
        local fname = vim.uri_to_fname(loc.uri or loc.targetUri)
        local range = loc.range or loc.targetSelectionRange
        local b = vim.fn.bufadd(fname)
        vim.fn.bufload(b)
        local text = api.nvim_buf_get_lines(b, range.start.line, range.start.line + 1, false)[1] or ""
        ok_target = text:find(member.class .. "::", 1, true) ~= nil
          and text:find(member.method:gsub("^~", ""), 1, true) ~= nil
      end
      if ok_target then
        remember(origin)
        return vim.lsp.util.show_document(loc, client.offset_encoding, { focus = true })
      end
      find_implementation(bufnr, member, origin)
    end, bufnr)
  end

  if #clients == 0 then
    return grep_fallback(bufnr, word, "no LSP attached", origin)
  end
  local client = clients[1]
  local want_decl = C_FT[vim.bo[bufnr].filetype] and client:supports_method("textDocument/declaration", bufnr)
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  local row = params.position.line

  local function first(result)
    if not result or vim.tbl_isempty(result) then
      return nil
    end
    return vim.islist(result) and result[1] or result
  end

  -- Jump only if the server found somewhere *else*; otherwise fall back to grep.
  local function go_or_fallback(loc, reason)
    if not loc or same_loc(loc, bufnr, row) then
      return grep_fallback(bufnr, word, reason, origin)
    end
    remember(origin)
    vim.lsp.util.show_document(loc, client.offset_encoding, { focus = true })
  end

  local function definition()
    client:request("textDocument/definition", params, function(err, result)
      go_or_fallback(not err and first(result) or nil, client.name .. " could not resolve it")
    end, bufnr)
  end

  if not want_decl then
    return definition()
  end
  -- C/C++: prefer the declaration (header). If we're already on it, go to the definition.
  client:request("textDocument/declaration", params, function(err, result)
    local loc = not err and first(result) or nil
    if not loc or same_loc(loc, bufnr, row) then
      return definition()
    end
    go_or_fallback(loc)
  end, bufnr)
end

function M.setup()
  local map = vim.keymap.set
  map("n", "t.", M.next_in_line, { desc = "indexnav: next item in line" })
  map("n", "t..", M.next_in_function, { desc = "indexnav: next item in function" })
  map("n", "t...", M.next_function, { desc = "indexnav: next function" })
  map("n", "ttlg", M.grep_item, { desc = "indexnav: live_grep item under cursor" })
  map("n", "t+", M.goto_definition, { desc = "indexnav: go to definition/header" })
  map("n", "t,", M.prev_in_line, { desc = "indexnav: previous item in line" })
  map("n", "t,,", M.prev_in_function, { desc = "indexnav: previous item in function" })
  map("n", "t,,,", M.prev_function, { desc = "indexnav: previous function" })
  map("n", "t-", M.go_back, { desc = "indexnav: back to where t+ came from" })
end

return M
