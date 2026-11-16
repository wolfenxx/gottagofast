{
  config,
  pkgs,
  ...
}:
let
  # Live symlinks into this repo. These MUST be string paths, not path
  # literals: under flakes a literal like ../../dotfiles/waybar is copied into
  # the store first, so mkOutOfStoreSymlink would point at that frozen copy --
  # which nothing holds a GC root for, so the next nix-collect-garbage leaves
  # every one of these dangling (happened 2026-11-16: waybar/dunst/rofi/... all
  # fell back to defaults). A string is never copied; the link goes straight to
  # the checkout. Repo location is the same ~/repos/gottagofast the scripts and
  # the `hms` alias assume.
  dotfiles = "${config.home.homeDirectory}/repos/gottagofast/dotfiles";
in
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
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr/hyprlock.conf";
    ".config/hypr/hyprpaper.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr/hyprpaper.conf";
    ".config/hypr/xdph.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr/xdph.conf";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/rofi";
    ".config/wlogout".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wlogout";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/dunst";
  };
}
