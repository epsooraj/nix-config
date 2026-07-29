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

    google-chrome

    kitty

    net-tools

    btop

    tmux

  ];
}
