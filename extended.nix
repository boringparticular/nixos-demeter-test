{
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
}
