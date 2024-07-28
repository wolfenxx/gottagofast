{ config, pkgs, userSettings, ... }:
let
  shellAliases = {
    sd = "shutdown 0";
    rs = "reboot";
    bk = "cd ..";
    hd = "cd ~";
    gg = "cd ~/repos/gottagofast";
    pr = "cd ~/projects";
    cl = "clear";
    bat = "batcat";
    cat = "batcat";
    ls = "eza";
    ll = "eza -alh";
    tree = "eza --tree";
    fe = "yazi";
    nv = "nvim .";
    lg = "lazygit";
    ldr = "lazydocker";
  };
in
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

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
  };

  programs.bat = {
    enable = true;
    package = pkgs.bat;
  };
  
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
