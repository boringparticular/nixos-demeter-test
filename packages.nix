{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # agenix.packages.${pkgs.stdenv.system}.default
    bat
    bottom
    broot
    cheat
    curlie
    du-dust
    duf
    exa
    fd
    fzf
    fzy
    glances
    gtop
    httpie
    hyperfine
    jq
    most
    procs
    ripgrep
    sd
    tealdeer
    xh

    just
    neovim
    tmux
    wget
  ];
}
