{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
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
    xdg-desktop-portal-hyprland
    brightnessctl
    wl-clipboard-rs
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      inputs.hyprland-virtual-desktops.packages.${pkgs.system}.virtual-desktops
    ];
    extraConfig =
      ''
          plugin {
            virtual-desktops {
                names = 1:coding, 2:internet, 3:mail and chats
                cycleworkspaces = 1
                rememberlayout = size
                notifyinit = 0
                verbose_logging = 0
            }
        }
      ''
      + builtins.readFile ../../dotfiles/hypr/hyprland.conf;

  };

  home.file = {
    ".config/hypr/hyprlock.conf".source =
      config.lib.file.mkOutOfStoreSymlink ../../dotfiles/hypr/hyprlock.conf;
    ".config/hypr/hyprpaper.conf".source =
      config.lib.file.mkOutOfStoreSymlink ../../dotfiles/hypr/hyprpaper.conf;
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/waybar;
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/rofi;
    ".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/wlogout;
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/dunst;
  };
}
