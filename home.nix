{ config, pkgs, lib, ... }:

let
  username = builtins.getEnv "USER";
  home_directory = builtins.getEnv "HOME";

  nixGL = (import
    (pkgs.fetchFromGitHub {
      owner = "guibou";
      repo = "nixGL";
      rev = "fad15ba09de65fc58052df84b9f68fbc088e5e7c";
      sha256 = "1wc5gfj5ymgm4gxx5pz4lkqp5vxqdk2njlbnrc1kmailgzj6f75h";
    })
    { }).nixGLIntel;
in
{
  imports = [
    ./home/shell.nix
    ./home/vim.nix
    ./home/tmux.nix
    ./home/vscode.nix
    ./home/kitty.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "${username}";
  home.homeDirectory = "${home_directory}";

  home.stateVersion = "21.03";

  home.packages = (with pkgs; [
    htop
    ctop
    tmux
    fzf
    silver-searcher
    dos2unix
    python39
    jq
  ] ++ (if stdenv.isDarwin then [
  ] else [
    nixGL
  ])
  );

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
