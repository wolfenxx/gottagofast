{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obs-studio
    arandr
    autorandr
    mpv
  ]; 
}
