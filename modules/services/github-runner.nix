{ config, lib, pkgs, ... }:

{
  # The runner gets a real, static account rather than a systemd DynamicUser.
  #
  # DynamicUser uids exist only in systemd's transient userdb and are resolved
  # through nss-systemd. When that lookup stops working the uid has no passwd
  # entry, and anything calling getpwuid() breaks — OpenSSH aborts on startup
  # with "No user exists for uid <n>" before it even looks at its arguments.
  # That took down the production deploy on 2026-08-01: every ssh-keygen exited
  # non-zero regardless of input, and the workflow's key check reported a
  # perfectly good RELEASE_SSH_KEY as malformed for an afternoon.
  #
  # A static account also gives the runner a passwd home that matches $HOME.
  # Under DynamicUser they differed, which is why ssh expanded `~` to a
  # different directory than bash did and the deploy had to be given absolute
  # identity paths.
  users.groups.github-runner = { };

  users.users.github-runner = {
    isSystemUser = true;
    group = "github-runner";
    home = "/var/lib/github-runner";
    createHome = true;
  };

  services.github-runners = {
    # You can define multiple distinct runners here
    bitsreef-github-runner = {
      enable = true;
      name = "bitsreef-github-runner";

      # Without this the module falls back to a systemd DynamicUser. See the
      # note on users.users.github-runner above for why that is not acceptable
      # for a release path.
      user = "github-runner";

      tokenFile = "/var/lib/github-runner-token";

      # Target URL: Use a specific repo or an organization URL
      url = "https://github.com/cygnaragroup/bitsreef";

      extraLabels = [ "self-hosted" "linux" ];

      # Take over a registration of the same name instead of failing with
      # "A runner exists with the same name". Without this, any crash that
      # leaves a stale registration on GitHub blocks every future start.
      replace = true;

      # The runner is a hardened systemd unit and does NOT inherit the login
      # shell's PATH, so `environment.systemPackages` is invisible to it.
      # Anything a workflow shells out to must be listed here.
      # GitHub-hosted runners are full Ubuntu images; actions and setup-*
      # scripts freely assume a standard userland exists. A NixOS service unit
      # has almost none of it, so rather than discover the list one CI failure
      # at a time, provide the base toolkit up front.
      extraPackages = with pkgs; [
        # what our own workflows invoke
        docker          # Postgres service containers (Django/Integration Tests)
        curl
        uv
        git
        nodejs
        python3         # .github/codeql/summarize_sarif.py

        # infra/deploy.sh — the production release path. Every external command
        # it invokes was enumerated from the source; these are the ones not
        # already covered above or by a guarded fallback in the script.
        openssh         # ssh + scp — deploy.sh reaches both nodes over SSH
        util-linux      # uuidgen (the tooling now falls back, but don't rely on it)
        jq              # the workflow installs it too; this removes the dependency
        gettext         # envsubst — deploy.sh has a fallback, but prefer the real one

        # standard userland the actions themselves shell out to
        bash
        coreutils
        gawk            # setup-uv parses libc detection with awk
        gnused
        gnugrep
        findutils
        diffutils
        which
        glibc.bin       # provides `ldd`, used to detect glibc vs musl
        file
        procps

        # archive tools for actions/cache and up/download-artifact
        gnutar
        gzip
        xz
        zstd
        unzip
        bzip2
      ];

      serviceOverrides = {
        # The runner account is not in the `docker` group; without this it
        # finds the binary and then fails on /var/run/docker.sock.
        SupplementaryGroups = [ "docker" ];

        # The module hardens /proc so only the runner's own PID is visible.
        # The Actions runner reads /proc/1/cgroup to detect whether it is
        # itself containerised before setting up the network for service
        # containers; blinded, it yields "Value cannot be null. (Parameter
        # 'network')". Relax both so job containers can be networked.
        ProcSubset = lib.mkForce "all";
        ProtectProc = lib.mkForce "default";
      };
    };
  };
}