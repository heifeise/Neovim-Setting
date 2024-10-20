vim.g.mapleader=" "
local keymap=vim.keymap
---插入模式---
---mode,new shortcut,old shortcut
keymap.set(
    "i",
    "jk",
    "<ESC>"
)


---视觉模式---
---视觉模式下，shift+j/shift+k可以上下移动选中的代码块
keymap.set(
    "v",
    "J",
    ":m '>+1<CR>gv=gv"
)
keymap.set(
    "v",
    "K",
    ":m '<-2<CR>gv=gv"
)

---正常模式---
--窗口
keymap.set(
    "n",
    "<leader>sv",
    "<C-w>v"
)--水平增加窗口

keymap.set(
    "n",
    "<leader>sh",
    "<C-w>s"
)--垂直增加窗口

--keymap.set("n","<leader>nh","nohl<CR>")--取消搜索高亮

