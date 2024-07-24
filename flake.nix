{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      legacyPackages = nixpkgs.lib.genAttrs [ system ] (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    );
    in
    {
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = legacyPackages.${system};
          modules = [
	          ./configuration.nix
	        ];
        };

        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = legacyPackages.${system};
          modules = [
	          ./configuration.nix
	        ];
        };
      };
    };
}
