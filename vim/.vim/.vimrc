if v:version < 802
    packadd! dracula
endif
syntax enable
colorscheme dracula

" Sane defaults
"" How things look.
set number
set wrap
set relativenumber
set cursorline
set signcolumn=yes
set scrolloff=10
set hlsearch
set incsearch
" Set functionality.
set mouse=a
set noshowmode
set clipboard=unnamedplus
set breakindent
set undofile
set ignorecase
set smartcase
set updatetime=250
set timeoutlen=300
set splitright
set splitbelow
set inccommand=split
" Code editing setup
set autoindent
set shiftwidth=4
set smarttab
set softtabstop=4
set expandtab
"TODO
set guifont=JetBrainsMono\ Nerd\ Font\ Mono\ Medium\ 18