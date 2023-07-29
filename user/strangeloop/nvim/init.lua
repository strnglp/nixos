-- [[ Set the basics ]]
vim.cmd([[ 
colorscheme pencil 
set background=light
hi Normal guibg=NONE ctermbg=NONE
let g:loaded_perl_provider = 0
]])

-- [[ Plugin initialization ]]
require('lualine').setup {
  options = { theme = 'auto' }
}
require("trouble").setup()
require("null-ls").setup {
  sources = {
    require("null-ls").builtins.completion.luasnip
  }
}
require("nvim-tree").setup()
require("auto-dark-mode").setup({})
require("auto-dark-mode").init()


local opt = vim.opt

-- [[ Theme ]]
opt.syntax = 'on'
opt.termguicolors= true

-- mouse in all modes
opt.mouse='a'
-- yank to clipboard and primary selection (mouse 3)
opt.clipboard:prepend {'unnamedplus'}

-- file handling
opt.modelines = 0
opt.encoding = 'utf-8'
opt.formatoptions = 'qrn1'

-- pane 
opt.hidden = true
opt.mousehide = true
opt.lazyredraw = true
opt.visualbell = true

-- tabs 
opt.tabstop= 2
opt.shiftwidth= 2
opt.softtabstop= 2
opt.expandtab = true
opt.autoindent = true

-- scrolling and gutter
opt.wrap = true
opt.scrolloff = 3
opt.laststatus = 2
opt.textwidth = 79
opt.relativenumber = true
opt.number = true

-- status line
opt.ruler = true
opt.showcmd = true
opt.showmode = true
opt.cursorline = true

-- menu
opt.wildmenu = true
opt.wildmode = 'list:longest'

-- undo and swap files
opt.undofile = true
opt.directory= '/tmp'

-- search
opt.hlsearch = true
opt.smartcase = true
opt.incsearch = true
opt.showmatch = true
opt.ignorecase = true

-- for autocompletion snippets
opt.completeopt = {'menu', 'menuone', 'noselect'}

-- make gutter use signs instead of letters
local signs = { Error = "", Warn = "", Hint = "󰌶", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- [[ snippets.lua ]]

-- Completion related config
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local select_opts = {behavior = cmp.SelectBehavior.Select}
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
cmp.setup({
  snippet = { -- required, defines snippet engine (luasnip)
  expand = function(args)
    luasnip.lsp_expand(args.body)
  end,
},
window = {
  completion = cmp.config.window.bordered(),
  documentation = cmp.config.window.bordered()
},
formatting = { -- popup window config
format = lspkind.cmp_format({
  mode = "symbol",
  maxwidth = 50,
  ellipsis_char = "…",
}),
                },
                -- [[ keys.lua ]]
                mapping = {
                  ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
                  ['<Down>'] = cmp.mapping.select_next_item(select_opts),

                  ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
                  ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

                  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-d>'] = cmp.mapping.scroll_docs(4),

                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({select = false}),

                  ['<Tab>'] = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1

                    if cmp.visible() then
                      cmp.select_next_item(select_opts)
                    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                      fallback()
                    else
                      cmp.complete()
                    end
                  end, {'i', 's'}),

                  ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                      cmp.select_prev_item(select_opts)
                    else
                      fallback()
                    end
                  end, {'i', 's'}),
                },
                sources = { -- buffers to load snippets from
                {name = 'path'},
                {name = 'nvim_lsp', keyword_length = 3},
                {name = 'buffer', keyword_length = 3},
                {name = 'luasnip', keyword_length = 2},
              },
            })

            vim.cmd( [[ set completeopt=menu,menuone,noselect ]] )

            --[[ keys.lua ]]
            local map = vim.api.nvim_set_keymap
            vim.g.mapleader = ","

            -- ; for :
            map("n", ";", ":", { noremap = true })

            -- Toggle nvim-tree-lua
            map("", "<F1>", [[:NvimTreeToggle<CR>]], {})

            -- regex sanity - this didn't carry over well to neovim, some bug with unicode?
            --map('n', '/', '/\v', { noremap = true })
            --map('v', '/', '/\v', { noremap = true })

            -- clear search with space comma
            map("n", "<leader><space>", [[:noh<CR>]], { noremap = true })

            -- match pairs
            map("n", "<tab>", "%", { noremap = true })
            map("v", "<tab>", "%", { noremap = true })

            -- enable repaste
            map("x", "p", "pgvy", { noremap = true })

            -- browse buffers with ctrl-j|k
            map("n", "<C-j>", [[:bn<CR>]], { noremap = true })
            map("n", "<C-k>", [[:bp<CR>]], { noremap = true })

            -- close buffer with ctrl-x
            map("n", "<C-x>", [[:bd<CR>]], { noremap = true })

            -- fuzz find with telescope.vim
            map(
            "n",
            "<leader>t",
            '<cmd>lua require("telescope.builtin").find_files({ no_ignore = false, hidden = true })<CR>',
            { noremap = true }
            )
            map("n", "<leader>r", '<cmd>lua require("telescope.builtin").live_grep()<CR>', { noremap = true })

            -- [ lsp.lua ]
            -- Language server config

            -- Enable (broadcasting) snippet capability for completion
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            require("mason").setup()
            require("mason-lspconfig").setup()

            require("lsp-format").setup {}
            local lspconfig = require("lspconfig")

            -- Use a loop to conveniently call 'setup' on multiple servers and
            -- map buffer local keybindings when the language server attaches
            local servers = { 'cssls', 'eslint', 'html', 'jsonls', 'tsserver', 'pyright', 'vimls', 'nil_ls', 'lua_ls' }

            for _, lsp in pairs(servers) do
              lspconfig[lsp].setup {
                capabilities = capabilities,
                on_attach = require("lsp-format").on_attach
              }
            end

            lspconfig.lua_ls.setup {
              settings = {
                Lua = {
                  runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                  },
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'},
                  },
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  -- Do not send telemetry data containing a randomized but unique identifier
                  telemetry = {
                    enable = false,
                  },
                },
              },
              capabilities = capabilities,
              on_attach = require("lsp-format").on_attach,
              root_dir = vim.loop.cwd
            }

            lspconfig.nil_ls.setup {
              settings = {
                ['nil'] = {
                  formatting = {
                    command = { "nixpkgs-fmt" },
                  },
                },
              },
            }
