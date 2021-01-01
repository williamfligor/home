{ config, pkgs, lib, ... }:

# Installing VS Code extensions with NixOS is possible, but it's quite cumbersome.
# Constantly changing the versions and sha256 checksums for frequently updated extensions is really annoying
# I prefer to install extensions in the command line once, then have them update automatically
#
# List of extensions:
# code --install-extension DavidAnson.vscode-markdownlint
# code --install-extension EditorConfig.EditorConfig
# code --install-extension PKief.material-icon-theme
# code --install-extension PeterJausovec.vscode-docker
# code --install-extension cschlosser.doxdocgen
# code --install-extension dbaeumer.vscode-eslint
# code --install-extension eamodio.gitlens
# code --install-extension esbenp.prettier-vscode
# code --install-extension ms-python.python
# code --install-extension ms-vscode.cpptools
# code --install-extension mshr-h.vhdl
# code --install-extension twxs.cmake
# code --install-extension vscodevim.vim

{
    programs.vscode = {
        enable = true;
    };
}
