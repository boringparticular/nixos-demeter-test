{pkgs, ...}: let
  libvpx = pkgs.callPackage ./libvpx.nix;
in {
  programs = {
    git = {
      enable = true;
    };
    zsh.enable = true;
  };
  networking = {
    hostName = "demeter";
    networkmanager.enable = true;
  };

  environment.systemPackages = [
    libvpx
  ];
}
