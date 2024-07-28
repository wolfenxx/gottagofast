{ config, pkgs, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
     neovim
     git
     google-chrome
     i3
     tmux
     bat
     eza
     curl
     ripgrep
     fzf
     jq
     python3
     nodejs_20
     lazygit
     lazydocker
     docker
     difftastic
     jless
     yazi
     zoxide
     silicon
     btop
  ];

  #xdg.enable = true;
  #xdg.userDirs = {
  #  extraConfig = {
  #   XDG_GAME_DIR = "${config.home.homeDirectory}/Media/Games";
  #    XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Media/Game Saves";
  #  };
  #};

}
