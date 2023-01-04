{
  __nixpkgs__,
  makeScript,
  ...
}: {
  checks,
  format,
  target,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "calculate-scorecard";
  replace = {
    __argChecks__ = checks;
    __argFormat__ = format;
    __argTarget__ = target;
  };
  searchPaths.bin = [
    __nixpkgs__.coreutils
    __nixpkgs__.gnugrep
    __nixpkgs__.jq
    __nixpkgs__.scorecard
  ];
}
