{ __nixpkgs__
, asBashArray
, makeScript
, ...
}:
{ commands
, extraArgs ? [ ]
, name
}:
makeScript {
  replace = {
    __argCommands__ = asBashArray commands;
    __argParallelArgs__ = asBashArray extraArgs;
  };
  entrypoint = ./entrypoint.sh;
  name = "make-script-parallel-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.parallel
    ];
  };
}
