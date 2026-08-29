{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ cifs-utils ];

  # mkForce: /mnt/z is mounted here via x-systemd.automount, so it's always
  # live as an autofs mount whenever nixos-generate-config runs (regardless of
  # docker state) -- it re-detects and rewrites a conflicting
  # fileSystems."/mnt/z" (device = "systemd-1"; fsType = "autofs";) into
  # hardware-configuration.nix on every regeneration. Forcing priority here
  # means that's a harmless no-op instead of a build-breaking conflict.
  fileSystems."/mnt/z" = lib.mkForce {
    device = "//192.168.1.131/Personal-Drive";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/secrets/smb-credentials"
      "uid=1000"
      "gid=100"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
    ];
  };
}
