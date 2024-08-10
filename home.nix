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
     brightnessctl
     obs-studio
     ardour
     fastfetch
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
    bashrcExtra = "fastfetch";
  };

	programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      tmuxPlugins.battery
      tmuxPlugins.catppuccin
    ];
    extraConfig = ''
     set -g mouse on                                                              
     set -g base-index 1                                                          
     set -g pane-base-index 1                                                     
     set-window-option -g pane-base-index 1                                       
     set-option -g renumber-windows on                                            
     bind -n M-H previous-window                                                  
     bind -n M-L next-window                                                      
     unbind C-b                                                                   
     set -g prefix C-a                                                            
     bind C-a send-prefix                                                         
     set-window-option -g mode-keys vi                                            
     bind-key -T copy-mode-vi v send-keys -X begin-selection                      
     bind-key -T copy-mode-vi C-v send-keys -X rectangle toggle                   
     bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel            
     bind '"' split-window -v -c "#{pane_current_path}"                           
     bind % split-window -h -c "#{pane_current_path}"                             
     set -g default-terminal "xterm-256color"                                     
     set-option -ga terminal-overrides ",xterm-256color:Tc"                       
     set -g @catppuccin_flavour "mocha"                                           
     set -g @catppuccin_status_modules_right "battery date_time"                  
     set -g @catppuccin_window_number_position "left"                             
     set -g @catppuccin_window_current_text "#{pane_current_path}"                
     set -g @catppuccin_date_time_text "%m-%d-%Y %I:%M%p"
    ''; 
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
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink ./.config/hypr; 
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink ./.config/kitty;
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink ./.config/yazi;
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ./.config/waybar;
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink ./.config/rofi;
    ".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink ./.config/wlogout;
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink ./.config/dunst;
  };
}
