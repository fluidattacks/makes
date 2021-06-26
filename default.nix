let
  sources = import ./nix/sources.nix;
  packages = {
    nixpkgs = import sources.nixpkgs { };
  };
in
{
  m = packages.nixpkgs.writeShellScriptBin "m" ''
    ${packages.nixpkgs.python3}/bin/python ${./src/cli.py} "$@"
  '';
}
