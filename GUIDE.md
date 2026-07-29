# NixOS Configuration Guide

> My personal guide for organising and maintaining my NixOS configuration using Flakes.

---

# Goals

This repository should be:

- Reproducible
- Modular
- Easy to understand
- Easy to extend
- Git friendly
- Scalable to multiple machines
- Self documented

Everything should have one obvious place.

---

# Repository Structure

```text
nixos/
├── flake.nix
├── flake.lock
├── README.md
├── .gitignore
│
├── hosts/
│
├── modules/
│
├── home/
│
├── overlays/
│
├── packages/
│
├── shells/
│
├── templates/
│
├── scripts/
│
├── docs/
│
└── secrets/
```

Every directory has a single responsibility.

---

# Philosophy

Think about the repository by asking three questions.

## Which machine?

Everything specific to a computer belongs inside

```
hosts/
```

Examples:

- Laptop
- Desktop
- Server
- Raspberry Pi
- Virtual Machine

---

## What feature?

Everything reusable belongs inside

```
modules/
```

Examples:

- Docker
- NVIDIA
- SSH
- Bluetooth
- Pipewire
- Hyprland

A module should configure exactly one feature.

---

## What belongs to the user?

Everything that customises the user account belongs inside

```
home/
```

Examples:

- Git config
- Shell
- Neovim
- Kitty
- VSCode
- Hyprland config
- Aliases
- Environment variables

This is managed using Home Manager.

---

# Directory Details

---

## flake.nix

The entry point.

Responsibilities:

- Import nixpkgs
- Import Home Manager
- Import overlays
- Build each host

Nothing else.

Avoid placing system configuration here.

---

## hosts/

Contains machine specific configuration.

Example:

```
hosts/
    laptop/
        configuration.nix
        hardware-configuration.nix

    desktop/
        configuration.nix
        hardware-configuration.nix

    server/
        configuration.nix
        hardware-configuration.nix
```

Only machine specific things belong here.

Examples:

- Hostname
- Imported modules
- Hardware configuration
- Boot device

Avoid placing package lists here.

---

## modules/

Reusable pieces of configuration.

Recommended structure:

```
modules/

    boot/

    networking/

    hardware/

    desktop/

    development/

    packages/

    services/

    users/

    locale/

    security/

    nix/
```

---

### boot/

Examples

```
systemd-boot.nix

grub.nix

secureboot.nix
```

---

### networking/

Examples

```
networkmanager.nix

openssh.nix

firewall.nix

dns.nix

twingate.nix

netbird.nix

tailscale.nix
```

---

### hardware/

Examples

```
nvidia.nix

amd.nix

intel.nix

audio.nix

bluetooth.nix

printing.nix

camera.nix
```

---

### desktop/

Examples

```
hyprland.nix

gnome.nix

kde.nix

fonts.nix

wayland.nix
```

---

### development/

Everything related to software development.

Examples

```
docker.nix

podman.nix

git.nix

github-runner.nix

vscode.nix

nix-ld.nix

direnv.nix

virtualization.nix
```

---

### packages/

Only package groups.

Do not configure services here.

Examples

```
cli.nix

gui.nix

development.nix

gaming.nix
```

---

### services/

Long running services.

Examples

```
postgres.nix

redis.nix

mysql.nix

ollama.nix

syncthing.nix

nginx.nix
```

---

### users/

User accounts.

Example

```
ep.nix

groups.nix
```

---

### locale/

Examples

```
timezone.nix

keyboard.nix

locale.nix
```

---

### nix/

Everything related to Nix itself.

Examples

```
settings.nix

gc.nix

optimise.nix

substituters.nix
```

---

# Home Manager

```
home/

    git/

    zsh/

    bash/

    tmux/

    kitty/

    neovim/

    vscode/

    hyprland/

    shell/

    ep.nix
```

Only user configuration belongs here.

Nothing requiring sudo should be placed here.

---

# Overlays

```
overlays/
```

Used for

- Custom packages
- Package overrides
- Pinning versions
- Local modifications

---

# Packages

```
packages/
```

Only packages written by me.

Example

```
packages/

    bitsreef-cli/

    my-tool/

    my-library/
```

---

# Development Shells

```
shells/
```

Project specific environments.

Examples

```
python.nix

rust.nix

node.nix

go.nix

flutter.nix
```

---

# Templates

Starter templates.

```
templates/

    python/

    react/

    django/

    rust/

    go/
```

---

# Secrets

```
secrets/
```

Never commit secrets.

Use

- agenix

or

- sops-nix

Store only encrypted files.

---

# Scripts

Utility scripts.

```
scripts/

    rebuild.sh

    update.sh

    cleanup.sh

    bootstrap.sh
```

---

# Docs

Everything I learn.

```
docs/

    setup.md

    recovery.md

    networking.md

    troubleshooting.md
```

Never rely on memory.

Document everything.

---

# Module Design Rules

Each module should

- Have one responsibility
- Be reusable
- Avoid duplication
- Avoid depending on unrelated modules

Good

```
docker.nix
```

Bad

```
docker-and-firewall.nix
```

---

# Host Design Rules

A host should only

- import modules
- define hostname
- define hardware

Nothing else.

Good

```nix
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/networking/openssh.nix
    ../../modules/development/docker.nix
    ../../modules/hardware/nvidia.nix
  ];

  networking.hostName = "eplaplin";
}
```

---

# Package Organisation

CLI packages

```
git
curl
wget
tmux
tree
btop
```

GUI packages

```
google-chrome
firefox
kitty
vlc
```

Development packages

```
docker
kubectl
terraform
```

Gaming packages

```
steam
lutris
```

Avoid putting everything into one giant list.

---

# Git Workflow

Before making changes

```
git pull
```

After editing

```
git status
```

Review

```
git diff
```

Commit

```
git add .
git commit -m "Enable Docker"
```

Build

```
sudo nixos-rebuild switch --flake .#laptop
```

---

# Updating

Update flake inputs

```
nix flake update
```

Review

```
git diff flake.lock
```

Rebuild

```
sudo nixos-rebuild switch --flake .#laptop
```

Commit

```
git add flake.lock
git commit -m "Update flake inputs"
```

---

# Recovery

If something breaks

Rollback immediately

```
sudo nixos-rebuild switch --rollback
```

or

Select an older generation from the bootloader.

Git can also restore previous configurations.

---

# Naming Convention

Files

```
docker.nix

openssh.nix

hyprland.nix
```

Avoid

```
mydocker.nix

docker-config.nix

misc.nix
```

Directories

Use lowercase.

Use singular names.

---

# Future Expansion

As the repository grows add

```
modules/development/github-runner.nix

modules/networking/twingate.nix

modules/services/ollama.nix

modules/services/postgres.nix

modules/services/redis.nix

modules/packages/development.nix

home/neovim/

home/vscode/

home/git/

shells/flutter.nix

shells/python.nix
```

No restructuring should be required.

---

# Guiding Principles

1. One file should do one thing.

2. One module should configure one feature.

3. One host should describe one machine.

4. One commit should represent one logical change.

5. Never duplicate configuration.

6. Everything should be reproducible.

7. Everything should be version controlled.

8. Document decisions.

9. Prefer readability over cleverness.

10. Future me should understand this repository without remembering why I wrote it.