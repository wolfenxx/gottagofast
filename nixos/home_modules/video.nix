{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obs-studio
    arandr
    autorandr
    mpv
    davinci-resolve-studio
    ffmpeg
    shotcut
    blender
  ];
}
