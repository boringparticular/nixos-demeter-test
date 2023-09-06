{
  description = "Build image";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  outputs = {
    self,
    nixpkgs,
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
    };
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        alejandra
        # nixd
      ];
    };
    images.demeter = nixosConfigurations.demeterImage.config.system.build.sdImage;
    systems.demeter = nixosConfigurations.demeter.config.system.build.topLevel;
  };
}
