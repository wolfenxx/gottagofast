{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brave
    google-chrome
  ]; 

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "ldgfbffkinooeloadekpmfoklnobpien"; } # raindrop
    ];
  };
}
