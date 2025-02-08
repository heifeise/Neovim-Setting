return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP 补全源
		"onsails/lspkind-nvim", -- 美化自动提示
		"hrsh7th/cmp-buffer", -- 缓冲区补全源
		"hrsh7th/cmp-nvim-lua", -- lua api
		"octaltree/cmp-look", -- 英语单词补全
		"hrsh7th/cmp-calc", -- 自动计算表达式
		"f3fora/cmp-spell", -- 拼写建议
		"hrsh7th/cmp-emoji", -- 表情包
		"hrsh7th/cmp-path", -- 文件路径补全源
		"hrsh7th/cmp-cmdline", -- 命令行补全源
		"L3MON4D3/LuaSnip", -- 代码片段插件
		"saadparwaiz1/cmp_luasnip", -- LuaSnip 补全源
		"rafamadriz/friendly-snippets", -- 代码段集合
	},
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- 使用 LuaSnip 扩展代码片段
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4), -- 上滚动文档
				["<C-f>"] = cmp.mapping.scroll_docs(4), -- 下滚动文档
				["<C-Space>"] = cmp.mapping.complete(), -- 显示补全建议
				["<C-e>"] = cmp.mapping.abort(), -- 取消补全
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- 确认补全
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP 补全源
				{ name = "luasnip" }, -- 代码片段补全源
			}, {
				{ name = "buffer" }, -- 缓冲区补全源
				{ name = "path" }, -- 文件路径补全源
			}),
		})

		-- 为命令行模式（/ 和 :）设置补全
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})
	end,
}
