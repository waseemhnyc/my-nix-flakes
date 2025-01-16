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
      # Specify all packages top-level here to make it easier to import them as
      # a caller.  Mostly useful for debugging the flake.
      packages = {
        # Pin to a minor version because why not.
        python3 = pkgs.python312;
        python3Packages = pkgs.python312Packages;
      };
      devShells = {
        default = pkgs.mkShell {
          packages = with self.packages.${system}; [
            python3Packages.python-lsp-server
            python3
            pkgs.ruff
            pkgs.poetry
            pkgs.uv
          ];
        };
      };
    });
}
