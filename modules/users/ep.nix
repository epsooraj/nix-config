{ pkgs, ... }:

{
  users.users.ep = {
    isNormalUser = true;

    description = "Sooraj Ep";

    extraGroups = [
      "wheel"
      "docker"
    ];

    packages = with pkgs; [ ];
  };
}
