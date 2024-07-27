{
  description = "NixOS Flake";
  inputs.nixpkgs.url = "nixpkgs/nixos-24.05";
  outputs = { self, nixpkgs, ... }@inputs: 
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "nixos"; # hostname
        timezone = "America/Chicago"; # select timezone
        bootMode = "uefi"; # uefi or bios
        bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
      };
      # ----- USER SETTINGS ----- #
      userSettings = {
        username = "wolfen"; # username
      };
      pkgs = nixpkgs.legacyPackages.${systemSettings.system};
      legacyPackages = nixpkgs.lib.genAttrs [ systemSettings.system ] (system:
      import inputs.nixpkgs {
        system = systemSettings.system;
        config.allowUnfree = true;
      }
    );
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
          pkgs = legacyPackages.${systemSettings.system};
          modules = [
            ./nixos/hardware-configuration.nix
	          ./configuration.nix
	        ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
          };
        };
        vm = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
          pkgs = legacyPackages.${systemSettings.system};
          modules = [
            ./nixos/vm-desktop-hardware.nix
	          ./configuration.nix
	        ];
        };
      };

      packages.${system}.default = {
        install = pkgs.writeShellApplication {
          name = "install";
          runtimeInputs = with pkgs; [ git ];
          text = ''${./install.sh} "$@"'';
        };
      };
    }
}
