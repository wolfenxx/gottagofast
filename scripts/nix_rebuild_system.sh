#!/bin/sh

REPO_LOCATION=~/repos/gottagofast

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

# Remove all docker containers and associated volumes to avoid build issues
if [ -n "$(docker ps -aq)" ]; then
  docker rm -vf $(docker ps -aq)
	# Remove lingering volumes
	docker volume prune -f
else
  echo "No containers to remove"
fi

sudo nixos-rebuild switch --flake $REPO_LOCATION/nixos#system;

home-manager switch --flake $REPO_LOCATION/nixos#user;
