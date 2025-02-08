return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()
		-- Here you can configure LSP settings
		local lspconfig = require("lspconfig")

		vim.diagnostic.config({
			virtual_text = true, -- 在代码行内显示错误信息
			signs = true, -- 在左侧显示错误符号
			underline = true, -- 在错误代码下方显示下划线
			update_in_insert = true, -- 在插入模式下更新诊断信息
			severity_sort = true, -- 按错误严重程度排序
		})
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			callback = function()
				vim.diagnostic.open_float(nil, {
					focusable = false,
					close_events = { "CursorMoved", "InsertEnter" },
					border = "rounded",
					source = "always", -- 显示修复建议
				})
			end,
		})
		-- 通用 LSP 配置
		local on_attach = function(client, bufnr)
			-- 启用补全
			require("cmp").setup.buffer({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
				},
			})
			-- 绑定快捷键
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "跳转到定义" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "查找引用" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "显示文档" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "重命名" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "代码操作" })
			vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "显示诊断信息" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "上一个诊断" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "下一个诊断" })
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- 配置 jdtls
		local jdk_path = os.getenv("JAVA_HOME")
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = vim.fn.expand("~/.local/share/nvim/lsp_servers/jdtls/workspace/") .. project_name
		local jdtls_path = vim.fn.stdpath("data") .. "/mason/share/jdtls"
		lspconfig.jdtls.setup({
			cmd = {
				"java", -- 确保系统中安装了 Java
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xms1g",
				"-Xmx2g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				vim.fn.expand(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"), -- 替换为实际的 launcher jar 路径
				"-configuration",
				vim.fn.expand(jdtls_path .. "/config"), -- 根据操作系统选择 config_linux、config_mac 或 config_win
				"-data",
				--vim.fn.expand("~/.local/share/nvim/lsp_servers/jdtls/workspace"), -- 工作区目录
				workspace_dir,
			},
			root_dir = lspconfig.util.root_pattern(".git", "pom.xml", "build.gradle"), -- 项目根目录标识
			settings = {
				java = {
					signatureHelp = { enabled = true },
					contentProvider = { preferred = "fernflower" },
					completion = {
						favoriteStaticMembers = {
							"org.junit.Assert.*",
							"org.junit.jupiter.api.Assertions.*",
							"org.mockito.Mockito.*",
						},
					},
					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},
					configuration = {
						runtimes = {
							{
								name = "jdk_path",
								path = jdk_path, -- 替换为你的 JDK 路径
							},
						},
					},
				},
			},
		})
		--jdtls end
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
		--clangd
		-- 获取标准库头文件路径
		local function get_std_include_paths()
			local handle = io.popen("echo | gcc -E -v - 2>&1")
			local result = handle:read("*a")
			handle:close()

			local include_paths = {}
			local capture = false

			for line in result:gmatch("[^\r\n]+") do
				if line:match("#include <...> search starts here:") then
					capture = true
				elseif line:match("End of search list.") then
					capture = false
				elseif capture and line:match("^%s*/") then
					table.insert(include_paths, line:match("^%s*(.-)%s*$"))
				end
			end

			return include_paths
		end
		lspconfig.clangd.setup({
			-- cmd = { "clangd", "--header-insertion=never" },  -- 禁止自动插入头文件
			cmd = { "clangd" },
			capabilities = capabilities,
			filetypes = { "c", "cpp", "h", "objc", "objcpp" }, -- You can add more filetypes if needed
			root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"), -- 项目根目录标识
			-- args = {
			-- 	"--compile-commands-dir=.", -- 设置编译命令所在的目录
			-- 	"--extra-arg=-I/C:/MinGW/include/c++/9.2.0", -- 指定标准库头文件路径
			-- 	"--extra-arg=-I/C:/MinGW/include", -- C++ 标准库头文件路径
			-- 	-- "--extra-arg=-I/path/to/project/include"  -- 项目头文件路径
			-- },
			settings = {
				clangd = {
					fallbackFlags = get_std_include_paths(), -- 动态添加标准库头文件路径
				},
			},
		})
		-- 应用到所有 LSP 客户端
		lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
			on_attach = on_attach,
		})
	end,
}
