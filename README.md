# NixOS Configuration

Personal NixOS configuration built with Flakes.

The organising rules live in [GUIDE.md](./GUIDE.md).

---

## Hosts

| Host     | Hostname   | Description  |
| -------- | ---------- | ------------ |
| `laptop` | `eplaplin` | Intel + NVIDIA laptop |

---

## Structure

```text
nixos/
├── flake.nix          Entry point. Builds each host.
├── hosts/             Machine specific configuration.
├── modules/           Reusable system modules, one feature per file.
├── home/              Home Manager user configuration.
├── overlays/          Package overrides and pins.
├── packages/          Packages written by me.
├── shells/            Development shells.
├── templates/         Project starter templates.
├── scripts/           Utility scripts.
├── docs/              Notes and runbooks.
└── secrets/           Encrypted secrets only.
```

### modules/

| Directory      | Contains                              |
| -------------- | ------------------------------------- |
| `boot/`        | Bootloader                            |
| `networking/`  | Network, SSH, firewall, VPNs          |
| `hardware/`    | GPU, audio, printing, bluetooth       |
| `desktop/`     | Compositors, desktop environments, fonts |
| `development/` | Containers, toolchains, dev services  |
| `packages/`    | Package groups only, no services      |
| `services/`    | Long running services                 |
| `users/`       | User accounts                         |
| `locale/`      | Timezone, locale, keyboard            |
| `security/`    | Security related settings             |
| `nix/`         | Nix and nixpkgs settings              |

---

## Usage

Common tasks go through the `Makefile`:

```sh
make            # list available commands
make switch     # build and switch
make test       # build without switching
make boot       # activate on next boot
make update     # update flake inputs
make rollback   # roll back to the previous generation
```

Equivalent to:

```sh
sudo nixos-rebuild switch --flake .#laptop
```

---

## Adding a feature

1. Create one file under the matching `modules/` directory.
2. Import it from the host that needs it.
3. `make test`, then `make switch`.
4. Commit the one logical change.
