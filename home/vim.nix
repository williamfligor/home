{ config, pkgs, lib, ... }:

let
  plugins = pkgs.vimPlugins;
  python3 = pkgs.python39;
  cmake = pkgs.cmake;
  readSettingsFile = file: builtins.readFile (./vim/. + "/${file}");
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;

  python3Packages = pkgs.python3Packages.override {
    overrides = self: super: {
      doq = pkgs.python3Packages.buildPythonPackage rec {
        pname = "doq";
        version = "0.6.4";
        name = "${pname}-${version}";
        src = python3Packages.fetchPypi {
          inherit pname version;
          sha256 = "00307mranwha3524gymlg33nswxyhv274l33lwlkxvys0c8cgy6v";
        };
        doCheck = false;
        propagatedBuildInputs = [
          pkgs.python3Packages.parso
          pkgs.python3Packages.jinja2
        ];
      };
    };
  };

  vim-ag = buildVimPlugin {
    name = "ag.vim";
    src = pkgs.fetchFromGitHub {
      owner = "rking";
      repo = "ag.vim";
      rev = "4a0dd6e190f446e5a016b44fdaa2feafc582918e";
      sha256 = "1dz7rmqv3xw31090qms05hwbdfdn0qd1q68mazyb715cg25r85r2";
    };
    dependencies = [ python3Packages.doq ];
  };

  vim-rainbow-parentheses = buildVimPlugin {
    name = "vim-rainbow-parentheses";
    pname = "vim-rainbow-parentheses";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "rainbow_parentheses.vim";
      rev = "27e7cd73fec9d1162169180399ff8ea9fa28b003";
      sha256 = "0izbjq6qbia013vmd84rdwjmwagln948jh9labhly0asnhqyrkb8";
    };
    dependencies = [ ];
  };

  vim-pydocstring = buildVimPlugin {
    name = "vim-pydocstring";
    src = pkgs.fetchFromGitHub {
      owner = "heavenshell";
      repo = "vim-pydocstring";
      rev = "e3d411821cfb5fa06b8cc18d6a3f0cccfde2bf7d";
      sha256 = "1ngri5gsknl5i02cwla15l6wgkzhpjsgv9j5h120spkylw8hws5b";
    };
    buildPhase = ''
      ln -sfn ${python3Packages.doq}/bin/doq ./lib/doq
    '';
    dependencies = [ ];
  };

  vim-cmake = buildVimPlugin {
    name = "vim-cmake";
    src = pkgs.fetchFromGitHub {
      owner = "vhdirk";
      repo = "vim-cmake";
      rev = "44f4253960814f82870d890de361047b5f03974c";
      sha256 = "10f0xfwib70i2glzwix38f47n1nwqykb6cr7c1swr4c1m7jxn0f5";
    };
    dependencies = [ ];
    postPatch = ''
      sed -i 's;executable("cmake");executable("${cmake}/bin/cmake");' plugin/cmake.vim
    '';
  };

  vim-bitbake = buildVimPlugin {
    name = "vim-bitbake";
    src = pkgs.fetchFromGitHub {
      owner = "kergoth";
      repo = "vim-bitbake";
      rev = "6d4148c3d200265293040a18c2f772340566554b";
      sha256 = "0izbjq6qbia013vmd84rdwjmwagln948jh9labhly0asnhqyrkb8";
    };
    dependencies = [ ];
  };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withRuby = true;
    withPython = true;
    withPython3 = true;

    plugins = with plugins; [
      # Theme
      base16-vim
      vim-airline
      vim-airline-themes

      # Tools
      vim-gitgutter
      undotree
      vim-ag
      vim-commentary
      vim-leader-guide
      fzfWrapper
      fzf-vim
      {
        plugin = vim-rainbow-parentheses;
        config = ''
          " Rainbow always on
          autocmd FileType * RainbowParentheses
        '';
      }
      {
        plugin = plugins.editorconfig-vim;
        config = ''
          let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
        '';
      }
      vim-tmux-navigator
      supertab

      # Languages
      vim-pydocstring
      vim-nix
      vim-cmake
      vim-bitbake
      {
        plugin = vim-markdown;
        config = '';
                    let g:vim_markdown_folding_disabled = 1
                '';
      }
      vim-nix
    ];

    extraConfig = ''
      let mapleader = "\<SPACE>"
      let g:spacemacs#leader = '<SPACE>'

      let g:spacemacs#excludes = [
        \ 'b',
        \ 'p',
      \ ]

      " ----- KEY MAPPINGS -------
      nnoremap <silent> <LEADER> :<C-U>LeaderGuide '<SPACE>'<CR>
      vnoremap <silent> <LEADER> :<C-U>LeaderGuideVisual '<SPACE>'<CR>
      nnoremap <leader>rn :call NumberToggle()<Cr>
      nnoremap <leader><space> :noh<cr>
      nnoremap <space>bb :Buffers<CR>
      nnoremap <space>pf :GFiles<CR>
      nnoremap <space>ff :Files<CR>
      nnoremap <space>md :Dox<CR>

      " Remove trailing whitespace
      nnoremap <leader>W :%s/\s\+$//<cr>:let @/=\'\'<CR>

      " Make %% in command line expand to the path of the current buffer
      cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

      " Reselect after indent outdent
      vnoremap < <gv
      vnoremap > >gv

      " Reselect after indent outdent
      vnoremap < <gv

      " Built in autocomplete
      set completeopt+=menuone 
      set completeopt+=noselect
      set completeopt+=noinsert
      set shortmess+=c   " Shut off completion messages
      set belloff+=ctrlg " If Vim beeps during completion

      " Searching
      set incsearch
      set showmatch
      set hlsearch

      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set expandtab
      set showcmd
      set showmode
      set visualbell
      set cursorline
      set ttyfast
      set ruler
      set laststatus=2
      set nrformats=
      set number
      set undofile
      set relativenumber

      " Theming
      syntax on
      set background=dark

      set termguicolors
      let base16colorspace=256
      silent! colorscheme base16-tomorrow-night

      " Airline Theme
      let g:airline_theme='tomorrow'
      let g:airline_powerline_fonts = 1

      " Restore cursor position to where it was before
      augroup JumpCursorOnEdit
          au!
          autocmd BufReadPost *
                      \ if expand("<afile>:p:h") !=? $TEMP |
                      \   if line("'\"") > 1 && line("'\"") <= line("$") |
                      \     let JumpCursorOnEdit_foo = line("'\"") |
                      \     let b:doopenfold = 1 |
                      \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
                      \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
                      \        let b:doopenfold = 2 |
                      \     endif |
                      \     exe JumpCursorOnEdit_foo |
                      \   endif |
                      \ endif
          " Need to postpone using "zv" until after reading the modelines.
          autocmd BufWinEnter *
                      \ if exists("b:doopenfold") |
                      \   exe "normal zv" |
                      \   if(b:doopenfold > 1) |
                      \       exe  "+".1 |
                      \   endif |
                      \   unlet b:doopenfold |
                      \ endif
      augroup END

      " Toggle relative numbers
      function! NumberToggle()
          if(&relativenumber == 1)
              set norelativenumber
              set number
          else
              set nonumber
              set relativenumber
          endif
      endfunc

      let swapdir = expand('~/.vim/swap')
      if !isdirectory(swapdir)
          call mkdir(swapdir)
      endif

      let undodir = expand('~/.vim/undo')
      if !isdirectory(undodir)
          call mkdir(undodir)
      endif

      let backupdir = expand('~/.vim/backup')
      if !isdirectory(backupdir)
          call mkdir(backupdir)
      endif

      set undodir=~/.vim/undo//
      set backupdir=~/.vim/backup//
      set directory=~/.vim/swap//

      ${readSettingsFile "spacemacs.vim"}
      ${readSettingsFile "indent-tcl.vim"}

      call SpacemacsInit()
    '';

  };
}
