return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "切换文件树" })
		vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile<CR>", { desc = "打开文件树并定位当前文件" })
		require("nvim-tree").setup({
			view = {
				width = 30, -- 侧边栏宽度
				side = "left", -- 侧边栏位置（'left' 或 'right'）
			},
			renderer = {
				icons = {
					glyphs = {
						default = "", -- 默认文件图标
						symlink = "", -- 符号链接图标
						folder = {
							arrow_closed = "", -- 折叠文件夹图标
							arrow_open = "", -- 展开文件夹图标
							default = "", -- 默认文件夹图标
							open = "", -- 打开文件夹图标
							empty = "", -- 空文件夹图标
							empty_open = "", -- 打开的空文件夹图标
						},
					},
				},
			},
			actions = {
				open_file = {
					quit_on_open = true, -- 打开文件后自动关闭侧边栏
				},
			},
		})
	end,
}
