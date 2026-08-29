{ pkgs, pkgs-stable, ... }:
let
  stable-packages = with pkgs-stable; [
    easyeffects
    ardour
    soundconverter
  ];
in
{
  home.packages =
    with pkgs;
    [
      qjackctl
      pulsemixer
      bluez
      spotify
      spotube
      audacity
      lmms
      bitwig-studio
      mixxx
    ]
    ++ stable-packages;
}
