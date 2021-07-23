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
  name = "format-terraform-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.terraform
    ];
  };
  entrypoint = ./entrypoint.sh;
}
