{
  description = "Sooraj's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixpkgs-fmt
        ];
      };

      nixosConfigurations.laptop =
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./hosts/laptop/configuration.nix
          ];
        };
    };
}
