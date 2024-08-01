{ config, pkgs, userSettings, ... }:
let
  shellAliases = {
    sd = "shutdown 0";
    rs = "reboot";
    lo = "session=`loginctl session-status | head -n 1 | awk '{print $1}'`; loginctl terminate-session $session";
    bk = "cd ..";
    hd = "cd ~";
    gg = "cd ~/repos/gottagofast";
    pr = "cd ~/projects";
    cl = "clear";
    bat = "bat";
    cat = "bat";
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

  home.stateVersion = "24.05";

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
     docker-compose
     difftastic
     jless
     yazi
     zoxide
     silicon
     btop
     gcc
     mono
     gnumake
     netcoredbg
     dotnet-sdk_8
     #dotnet-runtime_8
     #dotnet-aspnetcore_8	
     unzip
     kitty
     discord
     waybar
     libnotify
     dunst
     wofi
     rofi-wayland
     grim
     slurp
     swaylock
     wlogout
     dolphin
     hyprpaper
     networkmanagerapplet
     nerdfonts
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
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

  wayland.windowManager.hyprland = {
    enable = false;
  };

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ./.config/nvim;
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink ./.config/tmux;
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink ./.config/hypr; 
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink ./.config/kitty;
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink ./.config/yazi;
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ./.config/waybar;
  };
}
