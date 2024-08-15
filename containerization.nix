{ config, pkgs, inputs, systemSettings, userSettings, ... }:
{
  # Enable virtualization for Docker daemon
  virtualisation.docker.enable = true;

  # Use Docker without root access
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
