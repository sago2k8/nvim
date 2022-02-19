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
local function lsp_handlers()
  local function lspSymbol(name, icon)
      local hl = "DiagnosticSign" .. name
      vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
   end

   lspSymbol("Error", "")
   lspSymbol("Info", "")
   lspSymbol("Hint", "")
   lspSymbol("Warn", "")

   vim.diagnostic.config {
      virtual_text = {
         prefix = "",
         spacing = 0,
      },
      signs = true,
      underline = true,
      update_in_insert = false,
   }

   vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
   })
   vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
   })

   -- suppress error messages from lang servers
   vim.notify = function(msg, log_level)
      if msg:match "exit code" then
         return
      end
      if log_level == vim.log.levels.ERROR then
         vim.api.nvim_err_writeln(msg)
      else
         vim.api.nvim_echo({ { msg } }, true, {})
      end
   end
end

local function lspconfig_mappers()
  local m = {
    declaration = "gD",
    definition = "gd",
    hover = "K",
    implementation = "gi",
    signature_help = "gk",
    add_workspace_folder = "<leader>wa",
    remove_workspace_folder = "<leader>wr",
    list_workspace_folders = "<leader>wl",
    type_definition = "<leader>D",
    rename = "<leader>rn",
    code_action = "<leader>ca",
    references = "gr",
    float_diagnostics = "ge",
    goto_prev = "[d",
    goto_next = "]d",
    set_loclist = "<leader>q",
    formatting = "<leader>fm",
  }

  map("n", m.declaration, "<cmd>lua vim.lsp.buf.declaration()<CR>")
  map("n", m.definition, "<cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", m.hover, "<cmd>lua vim.lsp.buf.hover()<CR>")
  map("n", m.implementation, "<cmd>lua vim.lsp.buf.implementation()<CR>")
  map("n", m.signature_help, "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  map("n", m.add_workspace_folder, "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
  map("n", m.remove_workspace_folder, "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
  map("n", m.list_workspace_folders, "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
  map("n", m.type_definition, "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  map("n", m.rename, "<cmd>lua vim.lsp.buf.rename()<CR>")
  map("n", m.code_action, "<cmd>lua vim.lsp.buf.code_action()<CR>")
  map("n", m.references, "<cmd>lua vim.lsp.buf.references()<CR>")
  map("n", m.float_diagnostics, "<cmd>lua vim.diagnostic.open_float()<CR>")
  map("n", m.goto_prev, "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  map("n", m.goto_next, "<cmd>lua vim.diagnostic.goto_next()<CR>")
  map("n", m.set_loclist, "<cmd>lua vim.diagnostic.setloclist()<CR>")
  map("n", m.formatting, "<cmd>lua vim.lsp.buf.formatting()<CR>") 
end

lsp_handlers()

local function on_attach(_, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

   -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  lspconfig_mappers()
end


local nvim_lsp = require('lspconfig')
local protocol = require'vim.lsp.protocol'


local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
   properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
   },
}

nvim_lsp.flow.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  capabilities = capabilities
}

nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'markdown', 'pandoc' },
  init_options = {
    linters = {
      eslint = {
        command = 'eslint_d',
        rootPatterns = { '.git' },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint_d',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
      },
    },
    filetypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint',
    },
    formatters = {
      eslint_d = {
        command = 'eslint_d',
        rootPatterns = { '.git' },
        args = { '--stdin', '--stdin-filename', '%filename', '--fix-to-stdout' },
        rootPatterns = { '.git' },
      },
      prettier = {
        command = 'prettier_d_slim',
        rootPatterns = { '.git' },
        -- requiredFiles: { 'prettier.config.js' },
        args = { '--stdin', '--stdin-filepath', '%filename' }
      }
    },
    formatFiletypes = {
      css = 'prettier',
      javascript = 'prettier',
      javascriptreact = 'prettier',
      json = 'prettier',
      scss = 'prettier',
      less = 'prettier',
      typescript = 'prettier',
      typescriptreact = 'prettier',
      json = 'prettier',
      markdown = 'prettier',
    }
  }
}

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    -- This sets the spacing and the prefix, obviously.
    virtual_text = {
      spacing = 4,
      prefix = ''
    }
  }
)

