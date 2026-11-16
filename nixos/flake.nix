{
  description = "Wolfen's System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    # ComfyUI with prebuilt CUDA wheels. Deliberately NOT following our nixpkgs:
    # the flake pins its own to match the PyTorch wheels it was tested with.
    # Pinned to an exact rev on purpose: its CUDA closure is never in a binary
    # cache (xformers compiles CUDA kernels locally, ~1.5-3h), so bump this
    # only when you mean to pay for a rebuild. `nix flake update` won't move it.
    comfyui-nix.url = "github:utensils/comfyui-nix/58f91b001c99a97df46b7be8d58b08f01cb8f6ff";
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
        # GPU vendor: "nvidia" | "amd" | "intel" | "none". Drives the driver
        # block in gaming.nix and whether the CUDA-only ComfyUI service is on.
        gpu = "nvidia";
        # LAN-specific bits. Harmless elsewhere, but they belong here, not in
        # the modules, so a different network only means editing this block.
        lan = {
          # Hostname aliases written to /etc/hosts (name -> IP).
          hosts = {
            "192.168.1.67" = "jellywolf sonarrwolf radarrwolf lidarrwolf bazarrwolf prowlarrwolf qbitwolf quiwolf nzbwolf flarewolf seerrwolf statwolf portainerwolf dashwolf";
            "192.168.1.131" = "nas";
          };
          # SMB share automounted at /mnt/z (network-shares.nix). Set to null to
          # drop the mount entirely on a machine without this NAS.
          nas = {
            host = "192.168.1.131";
            share = "Personal-Drive";
            credentials = "/etc/nixos/secrets/smb-credentials"; # created by hand, never in the repo
          };
        };
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
            ./home_modules/games.nix
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
            ./system_modules/comfyui.nix
            ./system_modules/remote-desktop.nix
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
              # cypress
            ];

            shellHook = ''
              echo "Welcome to NodeJS dev environment"
            '';
          };
        }
      );
    };
}
