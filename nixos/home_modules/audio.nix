{ pkgs, pkgs-stable, ... }:
let
  stable-packages = with pkgs-stable; [
    easyeffects
  ];
in
{
  home.packages = with pkgs; [
    qjackctl
    pulsemixer
    ardour
    bluez
    spotify
    spotube
  ] ++ stable-packages; 
}
