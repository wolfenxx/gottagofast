#!/bin/sh

REPO_LOCATION=~/repos/gottagofast

# Clone gottagofast repo
nix-shell -p git --command "git clone https://github.com/wolfenxx/gottagofast $REPO_LOCATION"

# Clone tmux plugin manager repo. Required for tmux plugins to be sourced
nix-shell -p git --command "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"

# Generate hardware config for the system
sudo nixos-generate-config --show-hardware-config > $REPO_LOCATION/nixos/hardware-configuration.nix

# Check if uefi or bios
if [ -d /sys/firmware/efi/efivars ]; then
    sed -i "0,/bootMode.*=.*\".*\";/s//bootMode = \"uefi\";/" $REPO_LOCATION/nixos/flake.nix
else
    sed -i "0,/bootMode.*=.*\".*\";/s//bootMode = \"bios\";/" $REPO_LOCATION/nixos/flake.nix
    grubDevice=$(findmnt / | awk -F' ' '{ print $2 }' | sed 's/\[.*\]//g' | tail -n 1 | lsblk -no pkname | tail -n 1 )
    sed -i "0,/grubDevice.*=.*\".*\";/s//grubDevice = \"\/dev\/$grubDevice\";/" $REPO_LOCATION/nixos/flake.nix
fi

# Rebuild system
sudo nixos-rebuild switch --flake $REPO_LOCATION/nixos#system;

# Install and build home-manager configuration
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake $REPO_LOCATION/nixos#user;
