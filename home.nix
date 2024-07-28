{ config, pkgs, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
     neovim
     git
     brave
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

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "ldgfbffkinooeloadekpmfoklnobpien"; } # raindrop
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
    ];
  };
}
