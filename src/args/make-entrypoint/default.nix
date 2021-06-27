{ __packages
, builtinShellCommands
, builtinShellOptions
, makeDerivation
, makeSearchPaths
, makeTemplate
, ...
}:

{ arguments ? { }
, entrypoint
, location ? "/bin/${name}"
, name
, searchPaths ? { }
}:
makeDerivation {
  actions = [{
    type = "exec";
    location = location;
  }];
  arguments = {
    envEntrypoint = makeTemplate {
      inherit arguments;
      inherit name;
      template = entrypoint;
    };
    envEntrypointSetup = makeTemplate {
      arguments = {
        envBuiltinShellCommands = builtinShellCommands;
        envBuiltinShellOptions = builtinShellOptions;
        envCaCert = __packages.nixpkgs.cacert;
        envName = name;
        envSearchPaths = makeSearchPaths searchPaths;
        envSearchPathsBase = makeSearchPaths {
          # Minimalistic shell environment
          # Let's try to keep it as lightweight as possible because this
          # propagates to all built apps and packages
          envPaths = [
            __packages.nixpkgs.bash
            __packages.nixpkgs.coreutils
          ];
        };
        envShell = "${__packages.nixpkgs.bash}/bin/bash";
      };
      name = "makes-src-args-make-entrypoint-for-${name}";
      template = ./template.sh;
    };
    envLocation = location;
  };
  builder = ./builder.sh;
  local = true;
  inherit name;
}
