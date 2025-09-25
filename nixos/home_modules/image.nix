{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gimp3
    krita
    inkscape
    drawing
    pinta
  ];
}
