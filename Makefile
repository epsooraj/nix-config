# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

HOST := laptop
FLAKE := .#$(HOST)

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------

.PHONY: help
help:
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "  make switch      Build and switch to current configuration"
	@echo "  make test        Build without switching"
	@echo "  make boot        Build and activate on next boot"
	@echo "  make dry         Dry-run rebuild"
	@echo ""
	@echo "  make update      Update flake inputs"
	@echo "  make check       Validate flake"
	@echo "  make fmt         Format nix files"
	@echo ""
	@echo "  make gc          Garbage collect"
	@echo "  make optimise    Optimise nix store"
	@echo "  make clean       GC + optimise"
	@echo ""
	@echo "  make generations List generations"
	@echo "  make rollback    Roll back to previous generation"
	@echo ""
	@echo "  make info        System information"
	@echo ""

# -----------------------------------------------------------------------------
# Build
# -----------------------------------------------------------------------------

.PHONY: switch
switch:
	sudo nixos-rebuild switch --flake $(FLAKE)

.PHONY: test
test:
	sudo nixos-rebuild test --flake $(FLAKE)

.PHONY: boot
boot:
	sudo nixos-rebuild boot --flake $(FLAKE)

.PHONY: dry
dry:
	sudo nixos-rebuild dry-build --flake $(FLAKE)

# -----------------------------------------------------------------------------
# Flakes
# -----------------------------------------------------------------------------

.PHONY: update
update:
	nix flake update

.PHONY: check
check:
	nix flake check

.PHONY: metadata
metadata:
	nix flake metadata

# -----------------------------------------------------------------------------
# Formatting
# -----------------------------------------------------------------------------

.PHONY: fmt
fmt:
	nix fmt

# -----------------------------------------------------------------------------
# Maintenance
# -----------------------------------------------------------------------------

.PHONY: gc
gc:
	nix-collect-garbage -d

.PHONY: optimise
optimise:
	nix store optimise

.PHONY: clean
clean: gc optimise

# -----------------------------------------------------------------------------
# System
# -----------------------------------------------------------------------------

.PHONY: rollback
rollback:
	sudo nixos-rebuild switch --rollback

.PHONY: generations
generations:
	sudo nixos-rebuild list-generations

# -----------------------------------------------------------------------------
# Information
# -----------------------------------------------------------------------------

.PHONY: info
info:
	@echo ""
	@echo "Hostname:"
	@hostnamectl hostname
	@echo ""
	@echo "Current Generation:"
	@readlink /run/current-system
	@echo ""
	@echo "Flake Metadata:"
	@nix flake metadata