{pkgs, ...}: {
  users.users = {
    kmies = {
      isNormalUser = true;
      home = "/home/kmies";
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGb5cPrpHA5mLxknm0WInP6NuZylMCE6Z9LT+IRT7J4 kmies@zeus"];
      initialPassword = "1";
      extraGroups = ["wheel"];
    };
  };

  services.openssh = {
    enable = true;
  };

  nixpkgs = {
    config.allowUnsupportedSystem = true;
    config.allowBroken = true;
    buildPlatform.system = "x86_64-linux";
    hostPlatform.system = "armv7l-linux";
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = ["@wheel"];
      warn-dirty = false;
    };
  };

  system.stateVersion = "23.05";
}
