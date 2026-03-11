{ pkgs, userSettings, ... }:
{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    protonup-ng
    obsidian
    pcsx2
    mesen
    snes9x
    dolphin-emu
    #torzu # fork of yuzu (removed in latest version)
    ledger-live-desktop
    usbimager
  ];
}
