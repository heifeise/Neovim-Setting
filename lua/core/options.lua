local opt = vim.opt
--行号
opt.number=true
opt.relativenumber=true

--缩进
opt.tabstop=4
opt.shiftwidth=4
opt.expandtab=true
opt.autoindent=true

--防止包裹
--opt.wrap=false

--光标行
opt.cursorline=true

--系统剪贴板
opt.clipboard:append("unnamedplus")

--默认新创建的窗口在右和下
opt.splitright=true
opt.splitbelow=true

--搜索时不区分大小写
--opt.ignorecase=true
--搜索全大写或者全小写时，区分大小写
--opt.smartcase=true

--外观
opt.termguicolors=true
opt.signcolumn="yes"

-- 设置默认编码为 UTF-8
vim.o.encoding = "utf-8"

-- 设置文件编码检测顺序
vim.o.fileencodings = "utf-8,gbk,gb2312,ascii,latin1,shift-jis,euc-jp,iso-2022-jp,windows-1252,utf-16"

-- 设置文件的默认编码
vim.o.fileencoding = "utf-8"