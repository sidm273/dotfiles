local M = {}
-- Source: https://github.com/guruela/float-help.nvim/blob/a864dff23197da2183033af219c81d8370f965c5/lua/float-help.lua
M.buf = nil
M.win = nil

local defaults = {
  width = 0.8,
  height = 0.8,
  border = "rounded",
  title = "float-help.nvim",
  title_pos = "center",
  focus = true,
}

local config = defaults
local current_tag = nil
local view = nil

local show_error = function(err)
  local message = tostring(err):match("Vim:(E%d+:[^\n]+)") or tostring(err)

  vim.api.nvim_echo({
    { "float-help.nvim: " .. message, "ErrorMsg" },
  }, true, {})
end

local run_help = function(tag)
  if tag and tag ~= "" then
    vim.cmd.help(tag)
  else
    vim.cmd.help()
  end
end

local create_help_buffer = function(tag)
  local previous_win = vim.api.nvim_get_current_win()
  local previous_wins = {}

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    previous_wins[win] = true
  end

  vim.cmd.new()

  local ok, err = pcall(run_help, tag)
  local help_buf = ok and vim.api.nvim_get_current_buf() or nil

  if help_buf then
    vim.bo[help_buf].bufhidden = "hide"
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if not previous_wins[win] and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  if vim.api.nvim_win_is_valid(previous_win) then
    vim.api.nvim_set_current_win(previous_win)
  end

  if not ok then
    show_error(err)
  end

  return help_buf
end

local create_window = function(opts)
  -- The float is positioned relative to the editor, so its dimensions must
  -- also be derived from the editor. Using the current window here makes the
  -- float shrink and shifts it left or right when opened from a split.
  local max_height = vim.o.lines - vim.o.cmdheight
  local max_width = vim.o.columns
  local height = math.floor(max_height * opts.height)
  local width = math.floor(max_width * opts.width)
  local col = math.floor((max_width - width) / 2)
  local row = math.floor((max_height - height) / 2)

  M.win = vim.api.nvim_open_win(M.buf, opts.focus, {
    relative = "editor",
    height = height,
    width = width,
    row = row,
    col = col,
    border = opts.border,
    title = opts.title,
    title_pos = opts.title_pos,
  })

  if view then
    vim.api.nvim_win_call(M.win, function()
      vim.fn.winrestview(view)
    end)
  end
end

local show_tag = function(tag)
  local ok, err = pcall(vim.api.nvim_win_call, M.win, function()
    run_help(tag)
  end)

  if not ok then
    show_error(err)
    return
  end

  M.buf = vim.api.nvim_win_get_buf(M.win)
  vim.bo[M.buf].bufhidden = "hide"
  current_tag = tag
  view = nil
end

M.hide = function()
  if not (M.win and vim.api.nvim_win_is_valid(M.win)) then
    return
  end

  view = vim.api.nvim_win_call(M.win, function()
    return vim.fn.winsaveview()
  end)

  vim.api.nvim_win_close(M.win, true)
  M.win = nil
end

M.close = function()
  M.hide()

  if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
    vim.api.nvim_buf_delete(M.buf, { force = true })
  end

  M.win = nil
  M.buf = nil
  current_tag = nil
  view = nil
end

M.open = function(tag)
  if not (M.buf and vim.api.nvim_buf_is_valid(M.buf)) then
    M.buf = create_help_buffer(tag)

    if not M.buf then
      return
    end

    current_tag = tag
  end

  if not (M.win and vim.api.nvim_win_is_valid(M.win)) then
    create_window(config)
  end

  if tag and tag ~= current_tag then
    show_tag(tag)
  end
end

M.toggle = function(tag)
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    if tag and tag ~= current_tag then
      show_tag(tag)
    else
      M.hide()
    end
  else
    M.open(tag)
  end
end

M.setup = function(opts)
  config = vim.tbl_extend("force", defaults, opts or {})

  vim.api.nvim_create_user_command("Fh", function(command)
    M.toggle(command.args)
  end, {
    nargs = "?",
    complete = "help",
    desc = "Toggle floating help",
    force = true,
  })
end

return M
