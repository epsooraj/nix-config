{
  programs.nix-ld.enable = true;
  systemd.tmpfiles.rules = [
    "L+ /bin/bash - - - - ${pkgs.bash}/bin/bash"
  ];

}
