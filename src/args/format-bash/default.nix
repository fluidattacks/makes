{ __nixpkgs__
, asBashArray
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
    __argTargets__ = asBashArray
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
