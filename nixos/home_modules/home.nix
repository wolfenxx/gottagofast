{ pkgs, userSettings, ... }:
{
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
     protonup
     obsidian
  ]; 
}
