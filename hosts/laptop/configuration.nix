{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/boot.nix
    ../../modules/networking.nix
    ../../modules/locale.nix
    ../../modules/pipewire.nix
    ../../modules/users.nix
    ../../modules/services.nix
    ../../modules/programs.nix
    ../../modules/nvidia.nix
    ../../modules/docker.nix
    ../../modules/packages.nix
    ../../modules/nix.nix
  ];

  system.stateVersion = "26.05";
}
