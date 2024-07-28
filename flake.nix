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

      # Systems that can run tests:
      supportedSystems = [ "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });
    in
    {
      nixosConfigurations = {
        system = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            ./nixos/hardware-configuration.nix
            ./configuration.nix
          ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
          };
        };
      };

      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = self.packages.${system}.install;

          install = pkgs.writeShellApplication {
            name = "install";
            runtimeInputs = with pkgs; [ git ];
            text = ''${./install.sh} "$@"'';
          };
        });

      apps = forAllSystems (system: {
        default = self.apps.${system}.install;

        install = {
          type = "app";
          program = "${self.packages.${system}.install}/bin/install";
        };
      });
    };
}
