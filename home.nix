{ config, pkgs, pkgs-stable, userSettings, ... }:
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
    pm = "pulsemixer";
    cy = "cd ~/repos/cypress/";
    ast = "cd ~/repos/astralnotes/";
  };

	stable-packages = with pkgs-stable; [
    openlens
    easyeffects
	];
in
{
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

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
     clang
     clang-tools
     lldb
     mono
     gnumake
     netcoredbg
     dotnet-sdk_8
     nuget-to-nix
     csharp-ls
     omnisharp-roslyn
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
     mpv
     bluez
     file
     lua
     lua-language-server
     stylua
     cypress
     postman
     docker-ls
     sqls
     nil
     hyprls
     lemminx
     yaml-language-server
     biome
     powershell
     spotify
     spotube
     teleport
     nushell
     starship
     obsidian
     glow
     sqlite
  ] ++ stable-packages; 

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
    bashrcExtra = ''
      export DOTNET_ROOT="${pkgs.dotnet-sdk_8}"

      export CYPRESS_INSTALL_BINARY=0
      export CYPRESS_RUN_BINARY=${pkgs.cypress}/bin/Cypress

      export ST__Application__BindingBasePort=2000
      export ST__Application__PublicUrl=http://localhost:2000
      export ST_EnableBackgroundServices=true
      export ST_SQL=sqlserver://st:$5t-m$5q1$@localhost
      export ST__MockServices__UseMockServices=true
      export ST__Application__ServiceNameBase=ServiceTitan
      export ST__TenantDataService__Enabled=true

      fastfetch
    '';
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "ldgfbffkinooeloadekpmfoklnobpien"; } # raindrop
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
    "omnisharp".source = "${pkgs.omnisharp-roslyn}";
    "csharp-ls".source = "${pkgs.csharp-ls}";
    "stylua".source = "${pkgs.stylua}";
    "clang-tools".source = "${pkgs.clang-tools}";
    "lldb".source = "${pkgs.lldb}";
    "lua-language-server".source = "${pkgs.lua-language-server}";
    "docker-ls".source = "${pkgs.docker-ls}";
    "sqls".source = "${pkgs.sqls}";
    "nil".source = "${pkgs.nil}";
    "hyprls".source = "${pkgs.hyprls}";
    "lemminx".source = "${pkgs.lemminx}";
    "yaml-language-server".source = "${pkgs.yaml-language-server}";
    "biome".source = "${pkgs.biome}";
  };
}
