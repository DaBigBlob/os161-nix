# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
  CC = pkgs.gcc13;
in
rec {
  os161-sys161 = pkgs.callPackage ./sys161.nix { inherit CC; };
  os161-binutils = pkgs.callPackage ./binutils.nix { inherit CC; };
  os161-gcc = pkgs.callPackage ./gcc.nix { inherit CC; inherit os161-binutils; };
  os161-gdb = pkgs.callPackage ./gdb.nix { inherit CC; };
  os161-bmake = pkgs.callPackage ./bmake.nix { inherit CC; };
}