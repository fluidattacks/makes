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
  name = "format-terraform-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.terraform
    ];
  };
  entrypoint = ./entrypoint.sh;
}
