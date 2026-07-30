{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/boot/systemd-boot.nix

    ../../modules/networking/networkmanager.nix
    ../../modules/networking/openssh.nix

    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/printing.nix

    ../../modules/desktop/hyprland.nix

    ../../modules/development/docker.nix
    ../../modules/development/direnv.nix
    ../../modules/development/nix-ld.nix

    ../../modules/packages/cli.nix
    ../../modules/packages/gui.nix
    ../../modules/packages/development.nix

    ../../modules/users/ep.nix

    ../../modules/locale/timezone.nix
    ../../modules/locale/locale.nix

    ../../modules/nix/settings.nix
    ../../modules/nix/nixpkgs.nix
  ];

  networking.hostName = "eplaplin";

  system.stateVersion = "26.05";
}
