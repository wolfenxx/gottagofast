{ pkgs, pkgs-stable, ... }:
let
  stable-packages = with pkgs-stable; [
    zoom-us
  ];
in
{
  home.packages = with pkgs; [
    slack
    webcord
  ] ++ stable-packages; 
}
