local present, telescope = pcall(require, "telescope")

if not present then
   return
end
-- if !exists('g:loaded_telescope') | finish | endif

-- nnoremap  <silent> ;f <cmd>lua require('telescope.builtin').find_files()<cr>
-- nnoremap  <silent> ;r <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap  <silent> ;b <cmd>lua require('telescope.builtin').file_browser()<cr>
-- nnoremap <silent> \\ <cmd>Telescope buffers<cr>
-- nnoremap <silent> ;; <cmd>Telescope help_tags<cr>

local function map(mode, keys, command, opt)
   local options = { noremap = true, silent = true }
   if opt then
      options = vim.tbl_extend("force", options, opt)
   end

   -- all valid modes allowed for mappings
   -- :h map-modes
   local valid_modes = {
      [""] = true,
      ["n"] = true,
      ["v"] = true,
      ["s"] = true,
      ["x"] = true,
      ["o"] = true,
      ["!"] = true,
      ["i"] = true,
      ["l"] = true,
      ["c"] = true,
      ["t"] = true,
   }

   -- helper function for M.map
   -- can gives multiple modes and keys
   local function map_wrapper(sub_mode, lhs, rhs, sub_options)
      if type(lhs) == "table" then
         for _, key in ipairs(lhs) do
            map_wrapper(sub_mode, key, rhs, sub_options)
         end
      else
         if type(sub_mode) == "table" then
            for _, m in ipairs(sub_mode) do
               map_wrapper(m, lhs, rhs, sub_options)
            end
         else
            if valid_modes[sub_mode] and lhs and rhs then
               vim.api.nvim_set_keymap(sub_mode, lhs, rhs, sub_options)
            else
               sub_mode, lhs, rhs = sub_mode or "", lhs or "", rhs or ""
               print(
                  "Cannot set mapping [ mode = '" .. sub_mode .. "' | key = '" .. lhs .. "' | cmd = '" .. rhs .. "' ]"
               )
            end
         end
      end
   end

   map_wrapper(mode, keys, command, options)
end

local function telescope_mappings()
  local m = {
    buffers = "<leader>fb",
    find_files = "<leader>ff",
    find_hiddenfiles = "<leader>fa",
    git_commits = "<leader>cm",
    git_status = "<leader>gt",
    help_tags = "<leader>fh",
    live_grep = "<leader>fw",
    oldfiles = "<leader>fo",
    themes = "<leader>th", -- NvChad theme picker
  }

-- mappings

  map("n", m.buffers, ":Telescope buffers <CR>")
  map("n", m.find_files, ":Telescope find_files <CR>")
  map("n", m.find_hiddenfiles, ":Telescope find_files follow=true no_ignore=true hidden=true <CR>")
  map("n", m.git_commits, ":Telescope git_commits <CR>")
  map("n", m.git_status, ":Telescope git_status <CR>")
  map("n", m.help_tags, ":Telescope help_tags <CR>")
  map("n", m.live_grep, ":Telescope live_grep <CR>")
  map("n", m.oldfiles, ":Telescope oldfiles <CR>")
  map("n", m.themes, ":Telescope themes <CR>")
end

telescope_mappings()

function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local telescope = require('telescope')
local actions = require('telescope.actions')


telescope.setup {
   defaults = { 
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
      vimgrep_arguments = {
         "rg",
         "--color=never",
         "--no-heading",
         "--with-filename",
         "--line-number",
         "--column",
         "--smart-case",
      },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
   },
}

local extensions = { "themes", "terms" }

pcall(function()
   for _, ext in ipairs(extensions) do
      telescope.load_extension(ext)
   end
end)
