{ config, pkgs, lib, ... }:

let
  # Additional plugins
  themepack = pkgs.tmuxPlugins.mkDerivation {
    pluginName = "themepack";
    name = "themepack";
    src = builtins.fetchGit {
      url = "https://github.com/jimeh/tmux-themepack";
      rev = "1b1b8098419daacb92ca401ad6ee0ca6894a40ca";
    };
  };

in
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    sensibleOnTop = true;
    keyMode = "vi";
    extraConfig = ''
      set -g mouse on

      set -g @themepack 'block/blue'
    '';
    plugins = with pkgs; [
      tmuxPlugins.pain-control
      tmuxPlugins.yank
      tmuxPlugins.resurrect
      tmuxPlugins.copycat
      tmuxPlugins.vim-tmux-navigator
      themepack
    ];
  };
}
