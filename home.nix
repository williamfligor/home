{ config, pkgs, lib, ... }:

{
    imports = [
        ./home/shell.nix 
        ./home/vim.nix 
        ./home/tmux.nix
        ./home/vscode.nix
    ];

    nixpkgs.config.allowUnfree = true;

    home.username = "will";
    home.homeDirectory = "/Users/will";

    home.stateVersion = "21.03";

    home.packages = with pkgs; [
        htop
        ctop
        tmux
        fzf
        silver-searcher
        dos2unix
        python39
        valgrind
    ];

    programs = {
        home-manager.enable = true;
        command-not-found.enable = true;

        git = {
            enable = true;
            userName = "William Fligor";
            userEmail = "williamfligor@users.noreply.github.com";
        };

        fzf = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
        };
    };
}
