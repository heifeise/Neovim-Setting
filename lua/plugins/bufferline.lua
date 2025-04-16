--标签栏
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons", 
	config = function()
		vim.opt.termguicolors = true
		vim.opt.mousemoveevent = true
		require("bufferline").setup({
			options = {
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				mode = "buffers", -- 显示缓冲区
				numbers = "ordinal", -- 显示缓冲区编号
				diagnostics = "nvim_lsp", -- 显示 LSP 诊断

				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "center",
						separator = true,
						highlight = "Directory",
					},
				},
			},
		})
	end,
}
