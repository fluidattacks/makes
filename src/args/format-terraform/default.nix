{ __nixpkgs__
, asBashArray
, makeScript
, pathImpure
, ...
}:
{ name
, targets
, ...
}:
makeScript {
  replace = {
    __argTargets__ = asBashArray
      (builtins.map pathImpure targets);
  };
  name = "format-terraform-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.terraform
    ];
  };
  entrypoint = ./entrypoint.sh;
}
