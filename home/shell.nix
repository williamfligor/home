{ config, pkgs, lib, ... }:

let
  shellAliases = {
    ga = "git add";
    gaa = "git add -A";
    gp = "git push";
    gl = "git log --all --graph --pretty=format:\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\" --abbrev-commit --date=relative";
    gs = "git status";
    gd = "git diff";
    gdc = "git diff --cached";
    gm = "git commit -m";
    gma = "git commit -am";
    gb = "git branch";
    gc = "git checkout";
    gra = "git remote add";
    grr = "git remote rm";
    gpu = "git pull";
    gcl = "git clone";

    mv = "mv -i";
    cp = "cp -i";
    rm = "rm -i";

    speedtest = "wget -O /dev/null http://cachefly.cachefly.net/100mb.test";
  };

  home_directory = builtins.getEnv "HOME";

  envExtra = ''
    export EDITOR="vim"
    export VISUAL="vim"

    export CLICOLOR=1
    export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

    export LC_CTYPE=$LANG
    export GREP_COLOR='1;32'
  '';

in
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = shellAliases;

    initExtraFirst = ''
      if test -f "$HOME/.nix-profile/etc/profile.d/nix.sh"; then
          source $HOME/.nix-profile/etc/profile.d/nix.sh
      elif test -f "/etc/profile.d/nix.sh"; then
          source /etc/profile.d/nix.sh
      elif test -f "/nix/var/nix/profiles/default/etc/profile.d/nix.sh"; then
          source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      elif test -f "/nix/var/nix/profiles/per-user/$USER/profile/etc/profile.d/nix.sh"; then
          source /nix/var/nix/profiles/per-user/$USER/profile/etc/profile.d/nix.sh
      else
          echo "WARNING: Could not find nix.sh to activate"
      fi

      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\$\{(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\$\{(%):-%n\}.zsh"
      fi

      if [[ `uname` == 'Darwin' ]]; then
          alias l="ls -laFbh";
          alias kssh="kitty +kitten ssh"
      else
          alias l="ls -laFbh --color=auto"
          alias kitty="nixGLIntel kitty"
      fi
    '';

    envExtra = envExtra;

    initExtraBeforeCompInit = ''
      setopt PROMPT_SUBST
    '';

    initExtra = ''
      export KEYTIMEOUT=1
      bindkey -M vicmd '^[' undefined-key

      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH

      # Stop sharing history between terminals.. it's annoying
      # unsetopt SHARE_HISTORY
    '';

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "oh-my-zsh-history";
        src = pkgs.fetchFromGitHub {
          owner = "robbyrussell";
          repo = "oh-my-zsh";
          rev = "master";
          sha256 = "00m8d992jhbkd8mhm6zhirk9ga3dfzhh8idn2yp40yk7wdbzrd74";
        };
        file = "lib/history.zsh";
      }
      {
        name = "vi-mode";
        src = pkgs.fetchFromGitHub {
          owner = "sinetoami";
          repo = "vi-mode";
          rev = "master";
          sha256 = "0ihq28vym8zfd542hw37nk36ibrbps2y6a1xibabqi6z2nvxyylq";
        };
        file = "vi-mode.plugin.zsh";
      }
    ];
  };

  programs.bash = {
    enable = true;

    shellAliases = shellAliases;

    initExtra = envExtra + ''
      # Prompt, looks like:
      # ┌─[username@host]-[time date]-[directory]
      # └─[$]->
      export PS1="\[$Cyan\]┌─[\[$Green\]\u\[$Blue\]@\[$Red\]\h\[$Cyan\]]-[\[$BYellow\]$(eval 'echo $\{MYPS\}')\[$Cyan\]]\n\[$Cyan\]└─[\[$Purple\]\$\[$Cyan\]]->\[$Colour_Off\] "
      export PS2="\[$Cyan\]Secondary->\[$Colour_Off\] "
      export PS3="\[$Cyan\]Select option->\[$Colour_Off\] "
      export PS4="\[$Cyan\]+xtrace $LINENO->\[$Colour_Off\] "

      if test -f "$HOME/.nix-profile/etc/profile.d/nix.sh"; then
          source $HOME/.nix-profile/etc/profile.d/nix.sh
      elif test -f "/etc/profile.d/nix.sh"; then
          source /etc/profile.d/nix.sh
      elif test -f "/nix/var/nix/profiles/default/etc/profile.d/nix.sh"; then
          source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      elif test -f "/nix/var/nix/profiles/per-user/$USER/profile/etc/profile.d/nix.sh"; then
          source /nix/var/nix/profiles/per-user/$USER/profile/etc/profile.d/nix.sh
      else
          echo "WARNING: Could not find nix.sh to activate"
      fi

      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
    '';
  };
}
