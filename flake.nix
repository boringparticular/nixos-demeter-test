{
  description = "Build image";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
    };
  in rec {
    formatter.${system} = pkgs.alejandra;
    nixosConfigurations = {
      demeterImage = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          ./configuration.nix
          {
            sdImage.compressImage = false;
          }
        ];
      };
      demeter = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          {
            boot.loader.grub.enable = false;
            boot.loader.generic-extlinux-compatible.enable = true;
          }
        ];
      };
      demeterExtended = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          agenix.nixosModules.agenix
          ./hardware-configuration.nix
          ./configuration.nix
          ./packages.nix
          ./extended.nix
          {
            boot.loader.grub.enable = false;
            boot.loader.generic-extlinux-compatible.enable = true;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users = {
                kmies = import ./home.nix;
              };
            };
          }
        ];
      };
    };
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        alejandra
        # nixd
      ];
    };
    images.demeter = nixosConfigurations.demeterImage.config.system.build.sdImage;
    systems.demeter = nixosConfigurations.demeter.config.system.build.toplevel;
    systems.demeterExtended = nixosConfigurations.demeterExtended.config.system.build.toplevel;
  };
}
