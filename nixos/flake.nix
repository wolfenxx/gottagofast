{
  description = "Wolfen's System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        hostSystem = "x86_64-linux";
        hostname = "nixos";
        timezone = "America/Chicago";
        bootMode = "uefi"; # uefi or bios
        bootMountPath = "/boot"; # mount path for efi boot partition
        grubDevice = "/dev/sda"; # only used for legacy (bios) boot mode
      };

      # ----- USER SETTINGS ----- #
      userSettings = {
        username = "wolfen";
      };

      pkgs = import inputs.nixpkgs {
        system = systemSettings.hostSystem;
        config.allowUnfree = true;
      };

      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.hostSystem;
        config.allowUnfree = true;
      };

      home-manager = inputs.home-manager;

      # Systems that can run tests:
      supportedSystems = [ "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor = forAllSystems (hostSystem: import inputs.nixpkgs { system = hostSystem; });
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
            ./home_modules/image.nix
          ];
          extraSpecialArgs = {
            inherit userSettings inputs pkgs-stable;
          };
        };
      };

      nixosConfigurations = {
        system = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
            ./system_modules/virtualization.nix
            ./system_modules/containerization.nix
            ./system_modules/gaming.nix
            ./system_modules/network-shares.nix
          ];
          specialArgs = {
            inherit systemSettings userSettings inputs;
          };
        };
      };

      packages = forAllSystems (
        hostSystem:
        let
          pkgs = nixpkgsFor.${hostSystem};
        in
        {
          default = self.packages.${hostSystem}.install;

          install = pkgs.writeShellApplication {
            name = "install";
            runtimeInputs = with pkgs; [ git ];
            text = ''${../scripts/nix_install_system.sh} "$@"'';
          };
        }
      );

      devShells = forAllSystems (
        hostSystem:
        let
          pkgs = nixpkgsFor.${hostSystem};
        in
        {
          node = pkgs.mkShell {
            packages = with pkgs; [
              nodejs_20
              cypress
            ];

            shellHook = ''
              echo "Welcome to NodeJS dev environment"
            '';
          };
        }
      );
    };
}
