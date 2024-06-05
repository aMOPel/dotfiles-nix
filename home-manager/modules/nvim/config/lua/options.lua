-- mix of mine, mini.basics, vim-sensible

vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then
	vim.cmd([[syntax enable]])
end

vim.opt.fileformats = { "unix", "dos", "mac" }
vim.o.list = true
vim.opt.listchars = {
	tab = "» ",
	trail = "␣",
	nbsp = "␣",
	extends = "…",
	precedes = "…",
}

vim.opt.clipboard:prepend({ "unnamedplus" })
vim.o.relativenumber = true
vim.o.signcolumn = "yes:2"
vim.o.showtabline = 2
vim.o.foldenable = false
vim.o.foldcolumn = "0"
vim.o.foldlevelstart = 99
vim.o.foldnestmax = 1
vim.o.tabstop = 2

vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.scrolloff = 10
vim.o.sidescroll = 0
vim.o.sidescrolloff = 1
vim.o.ruler = false
vim.o.cursorline = true
vim.o.colorcolumn = "80"
vim.opt.sessionoptions = { "folds", "curdir", "tabpages", "winpos" }
vim.opt.viewoptions:remove({ "options" })
vim.o.autowriteall = true
vim.o.wrap = false
vim.o.breakindent = true
vim.o.linebreak = true

vim.o.ignorecase = true
vim.o.fillchars = "eob: "
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.virtualedit = "block"
vim.o.formatoptions = "qjl1"
vim.opt.shortmess:append("WcC")
vim.o.splitkeep = "screen"
vim.o.cmdheight = 2
vim.o.undofile = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.splitright = true
vim.o.helpheight = 50
vim.o.lazyredraw = true
vim.o.exrc = true
vim.opt.diffopt:prepend({ linematch = "60" })
vim.o.shell = "sh"
vim.o.mouse = ""
vim.o.termguicolors = true
vim.o.pumblend = 0
vim.o.winblend = 0

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("", "<space>", "<nop>")
vim.keymap.set("", "\\", "<nop>")

-- external lang providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- builtin plugins
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zipPlugin = 1

-- to download spellfiles
vim.g.loaded_netrwPlugin = 0
vim.g.loaded_spellfile_plugin = 0
