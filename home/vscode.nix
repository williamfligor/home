{ config, pkgs, lib, ... }:

let 
    fetchurl = pkgs.fetchurl;

    cpptools = pkgs.vscode-utils.buildVscodeMarketplaceExtension  rec {
        mktplcRef = {
            name = "cpptools";
            publisher = "ms-vscode";
            version = "1.1.3";
            sha256 = "02kx7yv3n22cja8pxnj0i03c4jx4v55iykcgbwxh37vknv8zv376";
        };

        plat = {
            "x86_64-linux" = "linux";
            "x86_64-darwin" = "osx";
        }.${pkgs.system};

        vsix = fetchurl {
            name = "${mktplcRef.publisher}-${mktplcRef.name}.zip";
            url = "https://github.com/microsoft/vscode-cpptools/releases/download/${mktplcRef.version}/cpptools-${plat}.vsix" ;
            sha256 = "1zyp89b04yc3fxn2pnvxl790i7cc3zd3mfsw6shkz2h8wfwah42s";
        };
    };

    python = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
            name = "python";
            publisher = "ms-python";
            version = "2020.12.424452561";
            sha256 = "0zd0wdaip4nd9awr0h0m5afarzwhkfd8n9hzdahwf43sh15lqblf";
        };
    };

    eslint = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
            name = "vscode-eslint";
            publisher = "dbaeumer";
            version = "2.1.14";
            sha256 = "113w2iis4zi4z3sqc3vd2apyrh52hbh2gvmxjr5yvjpmrsksclbd";
        };
    };

    gitlens = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
            name = "gitlens";
            publisher = "eamodio";
            version = "11.0.6";
            sha256 = "0qlaq7hn3m73rx9bmbzz3rc7khg0kw948z2j4rd8gdmmryy217yw";
        };
    };

    tcl = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
            name = "tcl";
            publisher = "rashwell";
            version = "0.1.0";
            sha256 = "0zd1sb1ixz7shwfq70r5dl3b87w6pc4lc5121gcbzwixg1dkzhlk";
        };
    };

    awesome-vhdl = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
            name = "awesome-vhdl";
            publisher = "puorc";
            version = "0.0.1";
            sha256 = "1h55jahz8rpwyx14r3rqx9lsb00vzcj42pr95n4hhyipkbr3sc9z";
        };
    };

in
{
    programs.vscode = {
        enable = true;
        extensions = [
            cpptools
            python
            eslint
            gitlens
            tcl
            awesome-vhdl
            pkgs.vscode-extensions.vscodevim.vim
            pkgs.vscode-extensions.redhat.vscode-yaml
        ];
    };
}
