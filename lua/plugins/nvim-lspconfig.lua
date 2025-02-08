return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Here you can configure LSP settings
		local lspconfig = require("lspconfig")

		local on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true }
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- Configure HTML language server
		lspconfig.html.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "html", "htmldjango" }, -- You can add more filetypes if needed
		})

		-- Configure CSS language server
		lspconfig.cssls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "css", "scss", "less" }, -- You can add more filetypes if needed
		})

		-- Other language servers (e.g., pyright, tsserver, clangd)
		lspconfig.pyright.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "py", "xml" }, -- You can add more filetypes if needed
		})
		lspconfig.ts_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "js", "ts" }, -- You can add more filetypes if needed
		})
		lspconfig.clangd.setup({
			-- cmd = { "clangd", "--header-insertion=never" },  -- 禁止自动插入头文件
			capabilities = capabilities,
			filetypes = { "c", "cpp", "h" }, -- You can add more filetypes if needed
			args = {
				"--compile-commands-dir=.", -- 设置编译命令所在的目录
				"--extra-arg=-I/C:/MinGW/include/c++/9.2.0", -- 指定标准库头文件路径
				"--extra-arg=-I/C:/MinGW/include", -- C++ 标准库头文件路径
				-- "--extra-arg=-I/path/to/project/include"  -- 项目头文件路径
			},
			on_attach = function(client, bufnr)
				-- 启用补全
				require("cmp").setup.buffer({
					sources = {
						{ name = "nvim_lsp" },
						{ name = "buffer" },
					},
				})
			end,
		})
	end,
}
