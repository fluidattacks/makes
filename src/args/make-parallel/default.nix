{ __nixpkgs__
, builtinLambdas
, makeScript
, ...
}:
{ commands
, extraArgs ? [ ]
, name
}:
makeScript {
  replace = {
    __argCommands__ = builtinLambdas.asBashArray commands;
    __argParallelArgs__ = builtinLambdas.asBashArray extraArgs;
  };
  entrypoint = ./entrypoint.sh;
  name = "make-parallel-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.parallel
    ];
  };
}
