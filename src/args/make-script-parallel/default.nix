{ __nixpkgs__
, toBashArray
, makeScript
, ...
}:
{ commands
, extraArgs ? [ ]
, name
}:
makeScript {
  replace = {
    __argCommands__ = toBashArray commands;
    __argParallelArgs__ = toBashArray extraArgs;
  };
  entrypoint = ./entrypoint.sh;
  name = "make-script-parallel-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.parallel
    ];
  };
}
