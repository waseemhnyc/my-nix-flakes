{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "systems";
    flake-utils = {
      url = "flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = { self, flake-utils, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = {
        rustup = pkgs.rustup;
      };
      devShells = {
        default = pkgs.mkShell {
          packages = with self.packages.${system}; [
            rustup
            pkgs.cargo
            pkgs.rustc
          ];
        };
      };
    });
}
