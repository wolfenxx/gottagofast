{ config, pkgs, userSettings, ... }:
let
  shellAliases = {
    sd = "shutdown 0";
    rs = "reboot";
    lo = "loginctl terminate-user $USER";
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
    hms = "home-manager switch --flake /home/wolfen/repos/gottagofast#user";
    gparted = "sudo -E gparted";
    gp = "sudo -E gparted";
    ff = "fzf --bind 'enter:become(nvim {})'";
    bluetooth = "blueman-manager";
    blueman = "blueman-manager";
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
     google-chrome
     tmux
     bat
     eza
     curl
     ripgrep
     fzf
     fd
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
     #clang
     mono
     gnumake
     netcoredbg
     dotnet-sdk_8
     #dotnet-runtime_8
     #dotnet-aspnetcore_8	
     unzip
     kitty
     waybar
     libnotify
     dunst
     rofi-wayland
     grim
     slurp
     hyprlock
     wlogout
     dolphin
     hyprpaper
     networkmanagerapplet
     roboto
     nerdfonts
     xdg-desktop-portal-hyprland
     zoom-us
     slack
     protonup
     qjackctl
     pulsemixer
     brightnessctl
     obs-studio
     ardour
     fastfetch
     arandr
     autorandr
     webcord
     gparted
     wl-clipboard-rs
     parted
     #python311Packages.ds4drv
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
    bashrcExtra = "fastfetch";
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
    ".config/nvim" = {
      source = ./.config/nvim;
      recursive = true;
    };
    ".config/tmux" = {
      source = ./.config/tmux;
      recursive = true;
    };
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink ./.config/hypr; 
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink ./.config/kitty;
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink ./.config/yazi;
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ./.config/waybar;
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink ./.config/rofi;
    ".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink ./.config/wlogout;
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink ./.config/dunst;
    ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink ./.config/fastfetch;
  };
}
