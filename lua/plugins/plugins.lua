return {
  -- the colorscheme should be available when starting Neovim
  {
    "Mofiqul/vscode.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
    -- Lua:
    -- For light theme (neovim's default)
    vim.o.background = 'light'
    -- For dark theme
    vim.o.background = 'dark'

    local c = require('vscode.colors').get_colors()
    require('vscode').setup({
    -- Alternatively set style in setup
    -- style = 'light'

    -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Underline `@markup.link.*` variants
    underline_links = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
        vscLineNumber = '#FFFFFF',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
})
-- require('vscode').load()

-- load the theme without affecting devicon colors.
vim.cmd.colorscheme "vscode"
    end,
  },


  -- I have a separate config.mappings file where I require which-key.
  -- With lazy the plugin will be automatically loaded when it is required somewhere
  { "folke/which-key.nvim", lazy = true },

  {
    "nvim-neorg/neorg",
    -- lazy-load on filetype
    ft = "norg",
    -- options for neorg. This will automatically call `require("neorg").setup(opts)`
    opts = {
      load = {
        ["core.defaults"] = {},
      },
    },
  },

  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  { 'sheerun/vim-polyglot', config = function() vim.opt.shortmess:remove("A") end }, -- Syntax files for languages + work around <https://github.com/sheerun/vim-polyglot/issues/765>.
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Here you can configure LSP settings
      local lspconfig = require'lspconfig'

      local on_attach = function(client, bufnr)
        local opts = { noremap=true, silent=true }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Configure HTML language server
      lspconfig.html.setup{
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "html", "htmldjango" },  -- You can add more filetypes if needed
      }

      -- Configure CSS language server
      lspconfig.cssls.setup{
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "css", "scss", "less" },  -- You can add more filetypes if needed
      }

      -- Other language servers (e.g., pyright, tsserver, clangd)
      lspconfig.pyright.setup{}
      lspconfig.ts_ls.setup{}
      lspconfig.clangd.setup{
      -- cmd = { "clangd", "--header-insertion=never" },  -- 禁止自动插入头文件
      capabilities = capabilities,
      args = {
        "--compile-commands-dir=.",    -- 设置编译命令所在的目录
        "--extra-arg=-I/C:/MinGW/include/c++/9.2.0",  -- 指定标准库头文件路径
        "--extra-arg=-I/C:/MinGW/include",  -- C++ 标准库头文件路径
        -- "--extra-arg=-I/path/to/project/include"  -- 项目头文件路径
      },
      on_attach = function(client, bufnr)
        -- 启用补全
        require'cmp'.setup.buffer {
          sources = {
            { name = 'nvim_lsp' },
            { name = 'buffer' },
          }
        }
      end,  
      }

    end,
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',    -- LSP 补全源
      'onsails/lspkind-nvim',    -- 美化自动提示
      'hrsh7th/cmp-buffer',      -- 缓冲区补全源
      'hrsh7th/cmp-nvim-lua',      -- lua api
      'octaltree/cmp-look',      -- 英语单词补全
      'hrsh7th/cmp-calc',      -- 自动计算表达式
      'f3fora/cmp-spell',      -- 拼写建议
      'hrsh7th/cmp-emoji',      -- 表情包
      'hrsh7th/cmp-path',        -- 文件路径补全源
      'hrsh7th/cmp-cmdline',     -- 命令行补全源
      'L3MON4D3/LuaSnip',        -- 代码片段插件
      'saadparwaiz1/cmp_luasnip', -- LuaSnip 补全源
      'rafamadriz/friendly-snippets', -- 代码段集合
    },
    config = function()
      local cmp = require'cmp'

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- 使用 LuaSnip 扩展代码片段
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),   -- 上滚动文档
          ['<C-f>'] = cmp.mapping.scroll_docs(4),    -- 下滚动文档
          ['<C-Space>'] = cmp.mapping.complete(),    -- 显示补全建议
          ['<C-e>'] = cmp.mapping.abort(),           -- 取消补全
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- 确认补全
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },    -- LSP 补全源
          { name = 'luasnip' },     -- 代码片段补全源
        }, {
          { name = 'buffer' },      -- 缓冲区补全源
          { name = 'path' }         -- 文件路径补全源
        })
      })

      -- 为命令行模式（/ 和 :）设置补全
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },


  -- {
  --   "hrsh7th/nvim-cmp",
  --   -- load cmp on InsertEnter
  --   event = "InsertEnter",
  --   -- these dependencies will only be loaded when cmp loads
  --   -- dependencies are always lazy-loaded unless specified otherwise
  --   dependencies = {
  --     'hrsh7th/cmp-nvim-lsp',    -- LSP 补全源
  --     'hrsh7th/cmp-buffer',      -- 缓冲区补全源
  --     'hrsh7th/cmp-path',        -- 文件路径补全源
  --     'hrsh7th/cmp-cmdline',     -- 命令行补全源
  --     'L3MON4D3/LuaSnip',        -- 代码片段插件
  --     'saadparwaiz1/cmp_luasnip' -- LuaSnip 补全源
  --   },
  --   config = function()
  --     -- ...
  --   end,
  -- },

  -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
  -- So for api plugins like devicons, we can always set lazy=true


  -- you can use the VeryLazy event for things that can
  -- load later and are not important for the initial UI
  { "stevearc/dressing.nvim", event = "VeryLazy" },

  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  {
    "monaqa/dial.nvim",
    -- lazy-load on keys
    -- mode is `n` by default. For more advanced options, check the section on key mappings
    keys = { "<C-a>", { "<C-x>", mode = "n" } },
  },

  -- local plugins need to be explicitly configured with dir
  { dir = "~/projects/secret.nvim" },

  -- you can use a custom url to fetch a plugin
  { url = "git@github.com:folke/noice.nvim.git" },

  -- local plugins can also be configured with the dev option.
  -- This will use {config.dev.path}/noice.nvim/ instead of fetching it from GitHub
  -- With the dev option, you can easily switch between the local and installed version of a plugin
  { "folke/noice.nvim", dev = true },
}
