{ __nixpkgs__
, builtinLambdas
, builtinShellCommands
, builtinShellOptions
, makeDerivation
, makeSearchPaths
, makeTemplate
, ...
}:

{ aliases ? [ ]
, arguments ? { }
, entrypoint
, name
, searchPaths ? { }
}:
makeDerivation {
  actions = [{
    type = "exec";
    location = "/bin/${name}";
  }];
  arguments = {
    envAliases = builtinLambdas.asBashArray (aliases ++ [ name ]);
    envEntrypoint = makeTemplate {
      inherit arguments;
      inherit name;
      template = entrypoint;
    };
    envEntrypointSetup = makeTemplate {
      arguments = {
        envBuiltinShellCommands = builtinShellCommands;
        envBuiltinShellOptions = builtinShellOptions;
        envCaCert = __nixpkgs__.cacert;
        envName = name;
        envSearchPaths = makeSearchPaths searchPaths;
        envSearchPathsBase = makeSearchPaths {
          # Minimalistic shell environment
          # Let's try to keep it as lightweight as possible because this
          # propagates to all built apps and packages
          envPaths = [
            __nixpkgs__.bash
            __nixpkgs__.coreutils
          ];
        };
        envShell = "${__nixpkgs__.bash}/bin/bash";
      };
      name = "makes-src-args-make-script-for-${name}";
      template = ./template.sh;
    };
  };
  builder = ./builder.sh;
  local = true;
  inherit name;
}
