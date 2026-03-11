{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obs-studio
    arandr
    autorandr
    mpv
    # davinci-resolve-studio # cannot build in latest nixos
    ffmpeg
    shotcut
    blender
    ytdownloader
  ];
}
