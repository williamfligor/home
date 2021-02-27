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

  gitpython = pkgs.python39.pkgs.buildPythonPackage rec {
    pname = "GitPython";
    version = "3.1.12";
    name = "${pname}-${version}";
    src = pkgs.python39.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1b0x9baawd68z7azj5nfp4jp3vyw0cqry1fhdr4nqmz2v7cfzns2";
    };
    doCheck = false;
    propagatedBuildInputs = [
      pkgs.python39.pkgs.gitdb
    ];
  };

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
  pythonScriptsFile = file: writePython3Script "${file}" (lib.fileContents (./scripts/. + "/${file}"));

  locals = scriptsFile "locals";
  sshreset = scriptsFile "sshreset";
  vimreset = scriptsFile "vimreset";
  tldr = scriptsFile "tldr";
  venvw = scriptsFile "venvw";
  linkapps = scriptsFile "link-apps";

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
    jq
    postgresql
    openssl
    lab
    ranger
    graphviz
    sshuttle
    wget
    python27
    (python39.withPackages (ps: with ps; [
      # Virtualenv
      pip
      virtualenv
      virtualenvwrapper

      # Basics
      python-gitlab
      gitpython
    ]))
    nodejs

    nixpkgs-fmt

    # Scripts
    locals
    sshreset
    vimreset
    tldr
    venvw
    linkapps
  ] ++ (if stdenv.isDarwin then [
    macpass
    rectangle
    alfred
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
