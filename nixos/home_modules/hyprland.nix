{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    waybar
    libnotify
    dunst
    rofi
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
    configType = "lua";
    extraConfig = "" + builtins.readFile ../../dotfiles/hypr/hyprland.lua;
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
