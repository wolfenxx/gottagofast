{ config, lib, systemSettings, ... }:
{
  # Gaming modules
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  hardware.graphics.enable = true;

  # GPU driver, selected by systemSettings.gpu in flake.nix. AMD and Intel are
  # in-kernel (amdgpu / i915 / xe) and need nothing declared here; only the
  # proprietary NVIDIA stack has to be opted into. On a machine with no NVIDIA
  # card, loading it would leave the display stack without a usable driver.
  services.xserver.videoDrivers = lib.mkIf (systemSettings.gpu == "nvidia") [ "nvidia" ];

  hardware.nvidia = lib.mkIf (systemSettings.gpu == "nvidia") {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
