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
  arguments = {
    envCommands = builtinLambdas.asBashArray commands;
    envParallelArgs = builtinLambdas.asBashArray extraArgs;
  };
  entrypoint = ./entrypoint.sh;
  name = "make-parallel-for-${name}";
  searchPaths = {
    envPaths = [
      __nixpkgs__.parallel
    ];
  };
}
