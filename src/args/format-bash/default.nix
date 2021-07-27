{ __nixpkgs__
, toBashArray
, makeScript
, projectPathMutable
, ...
}:
{ name
, targets
, ...
}:
makeScript {
  replace = {
    __argTargets__ = toBashArray
      (builtins.map projectPathMutable targets);
  };
  name = "format-bash-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.shfmt
    ];
  };
  entrypoint = ./entrypoint.sh;
}
