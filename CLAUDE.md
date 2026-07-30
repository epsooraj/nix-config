# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Overview

This is a personal NixOS configuration repository built with Flakes. It's organized to be reproducible, modular, and easily extended. All organizational rules are documented in [GUIDE.md](./GUIDE.md) — refer there for detailed philosophy and structure.

---

## Common Commands

All common operations are in the `Makefile`. Run `make` to see all available commands.

### Build & Deploy
- `make switch` — build and switch to the configuration immediately
- `make test` — build without switching (validates configuration)
- `make boot` — build and activate on next boot
- `make dry` — dry-run rebuild to check for errors

### Maintenance
- `make update` — update flake inputs (nixpkgs)
- `make check` — validate flake syntax
- `make fmt` — format all Nix files with `nix fmt`
- `make clean` — garbage collect and optimize the Nix store

### System
- `make rollback` — revert to the previous generation
- `make generations` — list all system generations
- `make info` — show hostname, current generation, and flake metadata

---

## Architecture at a Glance

**Three organizational axes:**

1. **Which machine?** → `hosts/`
   - Machine-specific config: hostname, hardware, which modules to import
   - Example: `hosts/laptop/` contains only `configuration.nix` (imports + hostname) and `hardware-configuration.nix`

2. **What feature?** → `modules/`
   - Reusable system modules, one responsibility per file
   - Subdirectories by category: `boot/`, `networking/`, `hardware/`, `desktop/`, `development/`, `packages/`, `services/`, `users/`, `locale/`, `nix/`, `security/`
   - Examples: `modules/hardware/nvidia.nix`, `modules/services/github-runner.nix`, `modules/development/docker.nix`

3. **What belongs to the user?** → `home/`
   - User-level configuration managed by Home Manager
   - Examples: shell config, editor setup, dotfiles, environment variables
   - Nothing requiring `sudo` should be here

**Other directories:**
- `overlays/` — package overrides and version pins
- `packages/` — custom packages authored locally
- `shells/` — dev environment shells (nix flake show)
- `templates/` — project starter templates
- `secrets/` — encrypted secrets only (agenix or sops-nix)
- `docs/` — runbooks and operational knowledge

---

## Key Design Principles

From GUIDE.md, these shape every decision:

1. **One file, one thing** — each Nix file has a single responsibility
2. **One module, one feature** — don't couple unrelated configuration
3. **One host, one machine** — hosts only import modules and define hardware
4. **One commit, one logical change** — git history should be clear
5. **No duplication** — reuse via modules
6. **Everything version controlled** — no manual edits outside this repo
7. **Reproducible** — same flake.lock + same commit = same system
8. **Self-documented** — future you should understand this without comments

---

## Adding a Feature

**The standard workflow:**

1. Create one `.nix` file under the appropriate `modules/` subdirectory
2. Import it in `hosts/laptop/configuration.nix`
3. `make test` to validate syntax
4. `make switch` to apply
5. `git add .` and commit the one logical change

**Example:** Adding nodejs development tools
- Create `modules/packages/development.nix` with a package group
- Or create `modules/development/nodejs.nix` if configuring a service
- Import it in the host
- Commit with a clear message

---

## Flake Inputs

Currently tracked:
- `nixpkgs` pinned to `nixos-26.05`

Update via `make update` when you want to refresh packages. Review `flake.lock` changes before rebuilding.

---

## Testing & Validation

- `make test` — always run this before `make switch`
- `make check` — validate flake definition
- `make fmt` — auto-format Nix code
- If something breaks: `make rollback` reverts to the previous generation immediately

---

## Notes

- The user is `ep` (defined in `modules/users/ep.nix`)
- Current host is `laptop` (Intel + NVIDIA)
- Home Manager is integrated; user config lives in `home/`
- Secrets should be encrypted; never commit plaintext secrets
- Refer to [GUIDE.md](./GUIDE.md) for detailed structure and philosophy
