{ config, pkgs, ... }:

{
  services.github-runners = {
    # You can define multiple distinct runners here
    bitsreef-github-runner = {
      enable = true;
      name = "bitsreef-github-runner";

      tokenFile = "/var/lib/github-runner-token";
      
      # Target URL: Use a specific repo or an organization URL
      url = "https://github.com/cygnaragroup/bitsreef";
      
      extraLabels = [ "self-hosted" "linux" ];
    };
  };
}