{ pkgs, ... }:

{
  users.users.ep = {
    isNormalUser = true;

    description = "Sooraj Ep";

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];

    packages = with pkgs; [ ];
  };
}
