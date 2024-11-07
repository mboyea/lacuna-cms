{
  description = "A CMS website.";
  # to pin a dependency, use revision number
  # get new revision numbers using: git ls-remote https://github.com/<repo_path> | grep HEAD
  # pin a dependency like: "github:numtide/flake-utils?rev=####"
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils, ... }: let
    name = "lacuna";
    version = "0.0.0";
  in utils.lib.eachDefaultSystem (
    system: let
      pkgs = import nixpkgs { inherit system; };
    in rec {
      packages = {
        dev = pkgs.callPackage ./nix/dev.nix {
          inherit name version;
        };
        default = packages.dev;
      };
      apps = {
        dev = utils.lib.mkApp { drv = packages.dev; };
        default = apps.dev;
      };
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nix-prefetch-docker
          pkgs.podman
          pkgs.gzip
          pkgs.skopeo
          pkgs.flyctl
          pkgs.postgresql
          pkgs.pnpm
        ];
      };
    }
  );
}

