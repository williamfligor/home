{ config, pkgs, lib, ... }:

let
  username = builtins.getEnv "USER";
  home_directory = builtins.getEnv "HOME";

  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

  nixGL = (import
    (pkgs.fetchFromGitHub {
      owner = "guibou";
      repo = "nixGL";
      rev = "fad15ba09de65fc58052df84b9f68fbc088e5e7c";
      sha256 = "1wc5gfj5ymgm4gxx5pz4lkqp5vxqdk2njlbnrc1kmailgzj6f75h";
    })
    { }).nixGLIntel;

  writePython3Script = name: text:
    pkgs.writeTextFile {
      inherit name;
      executable = true;
      destination = "/bin/${name}";
      text = ''
        #!${pkgs.python39}/bin/python
        ${text}
      '';
    };

  scriptsFile = file: pkgs.writeScriptBin "${file}" (lib.fileContents (./scripts/. + "/${file}"));

  clean-osx-network = scriptsFile "clean-osx-network";
  ssh-reset = scriptsFile "ssh-reset";
  tldr = scriptsFile "tldr";
  venvw = scriptsFile "venvw";
  link-apps = scriptsFile "link-apps";

in
{
  imports = [
    ./home/shell.nix
    ./home/vim.nix
    ./home/tmux.nix
    ./home/vscode.nix
    ./home/kitty.nix
  ];

  nixpkgs.overlays = [
    (import ./overlay/apps.nix)
    (self: super: {
      kitty = unstable.kitty;
    })
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "${username}";
  home.homeDirectory = "${home_directory}";

  home.stateVersion = "21.11";

  home.packages = (with pkgs; [
    # Monitoring
    ctop
    htop

    # Terminal Utilities
    dos2unix
    fzf
    jq
    mtr
    nixpkgs-fmt
    rename
    silver-searcher
    tmux
    wget

    python27
    (python39.withPackages (ps: with ps; [
      # Virtualenv
      pip
      virtualenv
      virtualenvwrapper
      black
      isort
    ]))

    # Script/
    clean-osx-network
    ssh-reset
    tldr
    venvw
    link-apps
  ] ++ (if stdenv.isDarwin then [
    rectangle
  ] else [
    nixGL
  ])
  );

  programs = {
    home-manager.enable = true;
    command-not-found.enable = true;

    git = {
      enable = true;
      lfs = {
        enable = true;
      };
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
