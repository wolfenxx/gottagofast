{ pkgs, lib, systemSettings, ... }:
let
  nas = systemSettings.lan.nas; # null = no share on this machine
in
{
  environment.systemPackages = with pkgs; [ cifs-utils ];

  # mkForce: /mnt/z is mounted here via x-systemd.automount, so it's always
  # live as an autofs mount whenever nixos-generate-config runs (regardless of
  # docker state) -- it re-detects and rewrites a conflicting
  # fileSystems."/mnt/z" (device = "systemd-1"; fsType = "autofs";) into
  # hardware-configuration.nix on every regeneration. Forcing priority here
  # means that's a harmless no-op instead of a build-breaking conflict.
  fileSystems."/mnt/z" = lib.mkIf (nas != null) (lib.mkForce {
    device = "//${nas.host}/${nas.share}";
    fsType = "cifs";
    options = [
      "credentials=${nas.credentials}"
      "uid=1000"
      "gid=100"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
    ];
  });
}
