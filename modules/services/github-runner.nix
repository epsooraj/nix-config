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

      # The runner is a hardened systemd unit: it does NOT inherit the login
      # shell's PATH, so `environment.systemPackages` is invisible to it.
      # Anything a workflow shells out to has to be listed here.
      #
      #   docker            — Django/Integration Tests use a Postgres service
      #                       container; without it the job dies in 10s with
      #                       "docker: command not found"
      #   curl, uv          — the API Contract workflow's schema check
      #   git               — actions/checkout falls back to the REST API
      #                       without it, which breaks on large repos
      #   nodejs            — frontend jobs
      #   gnutar, gzip, zstd — actions/cache and artifact up/download
      extraPackages = with pkgs; [
        docker
        curl
        uv
        git
        nodejs
        gnutar
        gzip
        zstd
        bash
        coreutils
      ];

      # The module defaults to DynamicUser, so the runner is an ephemeral user
      # that is not in the `docker` group. Without this it would reach the
      # docker binary and then fail on /var/run/docker.sock with EACCES —
      # a different error, same dead job.
      serviceOverrides.SupplementaryGroups = [ "docker" ];
    };
  };
}