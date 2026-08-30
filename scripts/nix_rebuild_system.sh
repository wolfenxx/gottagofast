#!/bin/sh

REPO_LOCATION=~/repos/gottagofast

# Remove all docker containers and associated volumes first -- this also stops
# any bind/CIFS-backed mounts docker set up (e.g. media-server's `media`
# volume), so nixos-generate-config below doesn't pick up transient
# container/overlay/CIFS mounts as if they were real hardware filesystems.
if [ -n "$(docker ps -aq)" ]; then
  docker rm -vf $(docker ps -aq)
	# Remove lingering volumes
	docker volume prune -f
else
  echo "No containers to remove"
fi

# Unmount declarative network shares (e.g. /mnt/z) first -- when one is
# actively mounted, nixos-generate-config sees both the autofs parent entry
# and the resolved submount as separate rows for the same target and emits
# two conflicting fileSystems blocks for it. These are noauto/automount, so
# unmounting is harmless; they remount on next access.
sudo umount /mnt/z 2>/dev/null || true

# Generate hardware config for new system
sudo nixos-generate-config --show-hardware-config > $REPO_LOCATION/nixos/hardware-configuration.nix

# Check if uefi or bios
if [ -d /sys/firmware/efi/efivars ]; then
    sed -i "0,/bootMode.*=.*\".*\";/s//bootMode = \"uefi\";/" $REPO_LOCATION/nixos/flake.nix
else
    sed -i "0,/bootMode.*=.*\".*\";/s//bootMode = \"bios\";/" $REPO_LOCATION/nixos/flake.nix
    grubDevice=$(findmnt / | awk -F' ' '{ print $2 }' | sed 's/\[.*\]//g' | tail -n 1 | lsblk -no pkname | tail -n 1 )
    sed -i "0,/grubDevice.*=.*\".*\";/s//grubDevice = \"\/dev\/$grubDevice\";/" $REPO_LOCATION/nixos/flake.nix
fi

sudo nixos-rebuild switch --flake $REPO_LOCATION/nixos#system;

home-manager switch --flake $REPO_LOCATION/nixos#user;
