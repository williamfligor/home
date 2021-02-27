{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;

    extraConfig = ''
      map alt+1 goto_tab 1
      map alt+2 goto_tab 2
      map alt+3 goto_tab 3
      map alt+4 goto_tab 4
      map alt+5 goto_tab 5
      map alt+6 goto_tab 6
      map alt+7 goto_tab 7
      map alt+8 goto_tab 8
      map alt+9 goto_tab 9

      # Base16 Tomorrow Night - kitty color config
      # Scheme by Chris Kempson (http://chriskempson.com)
      background #1d1f21
      foreground #c5c8c6
      selection_background #c5c8c6
      selection_foreground #1d1f21
      url_color #b4b7b4
      cursor #c5c8c6
      active_border_color #969896
      inactive_border_color #282a2e
      active_tab_background #1d1f21
      active_tab_foreground #c5c8c6
      inactive_tab_background #282a2e
      inactive_tab_foreground #b4b7b4
      tab_bar_background #282a2e

      # normal
      color0 #1d1f21
      color1 #cc6666
      color2 #b5bd68
      color3 #f0c674
      color4 #81a2be
      color5 #b294bb
      color6 #8abeb7
      color7 #c5c8c6

      # bright
      color8 #969896
      color9 #cc6666
      color10 #b5bd68
      color11 #f0c674
      color12 #81a2be
      color13 #b294bb
      color14 #8abeb7
      color15 #ffffff

      # extended base16 colors
      color16 #de935f
      color17 #a3685a
      color18 #282a2e
      color19 #373b41
      color20 #b4b7b4
      color21 #e0e0e0
    '';
  };
}
