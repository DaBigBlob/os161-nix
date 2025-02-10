# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
  CC = pkgs.gcc13;
in
rec {
  sys161 = pkgs.callPackage ./sys161.nix { inherit CC; };
  binutils = pkgs.callPackage ./binutils.nix { inherit CC; };
  gcc = pkgs.callPackage ./gcc.nix { inherit CC; inherit binutils; };
  gdb = pkgs.callPackage ./gdb.nix { inherit CC; };
  bmake = pkgs.callPackage ./bmake.nix { inherit CC; };
}