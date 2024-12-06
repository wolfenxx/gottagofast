{ config, pkgs, ... }:
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
    enable = false;
  };

  home.file = {
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/hypr; 
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/waybar;
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/rofi;
    ".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/wlogout;
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/dunst;
  };
}
