{
  description = "NixOS Flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, ... }@inputs: 
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
        timezone = "America/Chicago";
        bootMode = "bios"; # uefi or bios
        bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = "/dev/sda"; # device identifier for grub; only used for legacy (bios) boot mode
      };

      # ----- USER SETTINGS ----- #
      userSettings = {
        username = "wolfen";
      };

      # pkgs = nixpkgs.legacyPackages.${systemSettings.system};

      pkgs = import inputs.nixpkgs {
        system = systemSettings.system;
	config = {
	  allowUnfree = true;
	};
      };

      #legacyPackages = nixpkgs.lib.genAttrs [ systemSettings.system ] (system:
      #import inputs.nixpkgs {
      #  system = systemSettings.system;
      #  config.allowUnfree = true;
      # }
      #);

      home-manager = inputs.home-manager;

      # Systems that can run tests:
      supportedSystems = [ "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });
    in
    {
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
          ];
          extraSpecialArgs = {
          # inherit pkgs-stable;
          # inherit pkgs-emacs;
          # inherit pkgs-kdenlive;
          # inherit pkgs-nwg-dock-hyprland;
          # inherit systemSettings;
            inherit userSettings;
          # inherit inputs;
          };
        };
      };

      nixosConfigurations = {
        system = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
          inherit pkgs;
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
    };
}
