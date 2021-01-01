{ config, pkgs, lib, ... }:

let
    plugins = pkgs.vimPlugins;
    python3 = pkgs.python39;
    readSettingsFile = file: builtins.readFile (./vim/. + "/${file}");
    buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;

    vim-ag = buildVimPlugin {
        name = "ag.vim";
        src = pkgs.fetchFromGitHub  {
            owner = "rking";
            repo = "ag.vim";
            rev = "4a0dd6e190f446e5a016b44fdaa2feafc582918e";
            sha256 = "1dz7rmqv3xw31090qms05hwbdfdn0qd1q68mazyb715cg25r85r2";
        };
        dependencies = [];
    };

    vim-spacemacs = buildVimPlugin {
        name = "vim-spacemacs";
        pname = "vim-spacemacs";
        src = pkgs.fetchFromGitHub {
            owner = "jimmay5469";
            repo = "vim-spacemacs";
            rev = "a87473fd6c126f3ee85b32b6ee0d396e2093652e";
            sha256 = "0izbjq6qbia013vmd84rdwjmwagln948jh9labhly0asnhqyrkb8";
        };
        dependencies = [];
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
        dependencies = [];
    };

    vim-pydocstring = buildVimPlugin {
        name = "vim-pydocstring";
        src = pkgs.fetchFromGitHub {
            owner = "heavenshell";
            repo = "vim-pydocstring";
            rev = "e3d411821cfb5fa06b8cc18d6a3f0cccfde2bf7d";
            sha256 = "1ngri5gsknl5i02cwla15l6wgkzhpjsgv9j5h120spkylw8hws5b";
        };
        buildInputs = [ python3 ];
        buildPhase = ''
            make install
        '';
        dependencies = [];
    };

    vim-cmake = buildVimPlugin {
        name = "vim-cmake";
        src = pkgs.fetchFromGitHub {
            owner = "vhdirk";
            repo = "vim-cmake";
            rev = "44f4253960814f82870d890de361047b5f03974c";
            sha256 = "0izbjq6qbia013vmd84rdwjmwagln948jh9labhly0asnhqyrkb8";
        };
        dependencies = [];
    };

    vim-bitbake = buildVimPlugin {
        name = "vim-bitbake";
        src = pkgs.fetchFromGitHub {
            owner = "kergoth";
            repo = "vim-bitbake";
            rev = "6d4148c3d200265293040a18c2f772340566554b";
            sha256 = "0izbjq6qbia013vmd84rdwjmwagln948jh9labhly0asnhqyrkb8";
        };
        dependencies = [];
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
            vim-rainbow-parentheses
            plugins.editorconfig-vim
            vim-tmux-navigator
            supertab

            # Languages
            vim-pydocstring
            vim-nix
            vim-cmake
            vim-bitbake
            vim-markdown
            vim-nix
        ];

        extraConfig = ''
            ${readSettingsFile "spacemacs.vim"}
            ${readSettingsFile "autocomplete.vim"}
            ${readSettingsFile "indent-tcl.vim"}
            ${readSettingsFile "keys.vim"}
            ${readSettingsFile "opts.vim"}
            ${readSettingsFile "theme.vim"}
            ${readSettingsFile "utils.vim"}

            call SpacemacsInit()
        '';

    };

    programs.vim = {
        enable = true;

        plugins = config.programs.neovim.plugins;
        extraConfig = ''
            ${readSettingsFile "spacemacs.vim"}
            ${readSettingsFile "autocomplete.vim"}
            ${readSettingsFile "indent-tcl.vim"}
            ${readSettingsFile "keys.vim"}
            ${readSettingsFile "opts.vim"}
            ${readSettingsFile "theme.vim"}
            ${readSettingsFile "utils.vim"}

            call SpacemacsInit()
        '';
    };

}
