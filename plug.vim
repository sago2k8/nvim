if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
if has("nvim")
 
 " this is the nvchad core repo containing utilities for some features like theme swticher, no need to lazy load
  Plug 'Nvchad/extensions'
  Plug 'NvChad/nvim-base16.lua'

  " Status bar
  Plug 'hoob3rt/lualine.nvim'

  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'folke/lsp-colors.nvim'
  Plug 'L3MON4D3/LuaSnip'

  " neovim language things
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'neovim/nvim-lspconfig'
  " main one
 " Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  " 9000+ Snippets
  "Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'onsails/lspkind-nvim'
  
  "Fzf fizzy search
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'


  " Telescope file finder / picker
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

  Plug 'windwp/nvim-autopairs'
  
  " Tabs
  Plug 'jistr/vim-nerdtree-tabs'

  " git indicator in editor
  Plug 'airblade/vim-gitgutter'

  " Nicer LSP UI
  Plug 'glepnir/lspsaga.nvim'

  " autocompletion

  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'saadparwaiz1/cmp_luasnip'

  Plug 'onsails/lspkind-nvim'
endif

Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

call plug#end()
