{ __nixpkgs__
, asBashArray
, makeScript
, pathMutable
, ...
}:
{ name
, targets
, ...
}:
makeScript {
  replace = {
    __argTargets__ = asBashArray
      (builtins.map pathMutable targets);
  };
  name = "format-bash-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.shfmt
    ];
  };
  entrypoint = ./entrypoint.sh;
}
