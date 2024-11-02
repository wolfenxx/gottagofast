# clean up nix store
nix-store --gc

# clean up nix old generations/garbage

nix-collect-garbage --delete-old

# recommeneded to sometimes run as sudo to collect additional garbage
sudo nix-collect-garbage -d

# As a separation of concerns - you will need to run this command to clean out boot
sudo /run/current-system/bin/switch-to-configuration boot
