# TODO

Pending work on this configuration.

---

## Home Manager

Not wired up yet. `home/` is scaffolded and empty.

Home Manager declares user level configuration the same way NixOS declares
system configuration. Dotfiles are generated into the Nix store and symlinked
into `~`, so they become reproducible, version controlled and rollback-able.

### Why

`kitty` and `hyprland` are installed and enabled at the system level, but their
actual configuration still lives as hand edited files in `~`. Untracked and not
reproducible. Home Manager closes that gap.

### Steps

1. Add the input to `flake.nix`, pinned to the branch matching nixpkgs:

   ```nix
   home-manager = {
     url = "github:nix-community/home-manager/release-26.05";
     inputs.nixpkgs.follows = "nixpkgs";
   };
   ```

2. Import `home-manager.nixosModules.home-manager` in the laptop host so a
   single `make switch` rebuilds both system and user configuration.

3. Create `home/ep.nix` as the user side counterpart to
   `modules/users/ep.nix`. Start with git:

   ```nix
   programs.git = {
     enable = true;
     userName = "Sooraj Ep";
     userEmail = "epsooraj4@gmail.com";
   };
   ```

4. Migrate one program at a time into `home/git/`, `home/kitty/`,
   `home/hyprland/`, `home/shell/`.

### Watch out

- **Version coupling.** The Home Manager release must match nixpkgs. Currently
  `nixos-26.05`, so use `release-26.05`. Bump both together or eval fails with
  confusing errors.

- **Existing dotfiles conflict.** On the first switch Home Manager refuses to
  overwrite an existing `~/.gitconfig` and errors out. Back up and remove the
  originals first, or set a backup file extension. One time annoyance.

- **It is a migration, not a flip.** The value only arrives as configs are
  actually moved in. Incremental work per program.
