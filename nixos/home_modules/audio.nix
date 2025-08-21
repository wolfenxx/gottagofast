{ pkgs, pkgs-stable, ... }:
let
  stable-packages = with pkgs-stable; [
    easyeffects
    ardour
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
      llms
      soundconverter
      bitwig-studio
      mixxx
    ]
    ++ stable-packages;
}
