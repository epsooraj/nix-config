{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    gzip
    gnutar
    xz
    gnumake
    net-tools
    btop
    tmux
    nixpkgs.impala
  ];
}
