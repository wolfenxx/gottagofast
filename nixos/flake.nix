{
  description = "Wolfen's System";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nixpkgs, ... }@inputs: 
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
        timezone = "America/Chicago";
        bootMode = "uefi"; # uefi or bios
        bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = "/dev/sda"; # device identifier for grub; only used for legacy (bios) boot mode
      };

      # ----- USER SETTINGS ----- #
      userSettings = {
        username = "wolfen";
      };

      pkgs = import inputs.nixpkgs { 
        system = systemSettings.system;
          config = {
            allowUnfree = true;
          };
      };

      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
          config = {
            allowUnfree = true;
          };
      };

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
            ./home_modules/home.nix
						./home_modules/audio.nix
						./home_modules/browsers.nix
						./home_modules/chat.nix
						./home_modules/development.nix
						./home_modules/hyprland.nix
						./home_modules/terminals.nix
						./home_modules/video.nix
          ];
          extraSpecialArgs = {
            inherit userSettings;
            inherit inputs;
            inherit pkgs-stable;
          };
        };
      };

      nixosConfigurations = {
        system = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
          inherit pkgs;
          modules = [
						./configuration.nix
            ./hardware-configuration.nix
            ./system_modules/virtualization.nix
            ./system_modules/containerization.nix
            ./system_modules/gaming.nix
          ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
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
            text = ''${../scripts/nix_install_system.sh} "$@"'';
          };
        });

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          node = pkgs.mkShell {
            packages = with pkgs; [
              nodejs_20
              cypress
            ];

            shellHook = ''
              echo "Welcome to NodeJS dev environment"
            '';
          };
      });
    };
}
