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
, entrypoint
, name
, replace ? { }
, searchPaths ? { }
}:
let
  # Minimalistic shell environment
  # Let's try to keep it as lightweight as possible because this
  # propagates to all built apps and packages
  searchPathsBase = makeSearchPaths {
    bin = [ __nixpkgs__.coreutils ];
  };
  # Clean Search Paths before starting
  # To ensure there are no impurities
  searchPathsEmpty = makeSearchPaths
    (builtins.mapAttrs
      (name: _:
        if name == "source"
        then [ ]
        else [ "/not-set" ])
      (builtins.functionArgs makeSearchPaths));
in
makeDerivation {
  actions = [{
    type = "exec";
    location = "/bin/${name}";
  }];
  env = {
    envAliases = builtinLambdas.asBashArray (aliases ++ [ name ]);
    envEntrypoint = makeTemplate {
      inherit replace;
      inherit name;
      template = entrypoint;
    };
    envEntrypointSetup = makeTemplate {
      replace = {
        __argBuiltinShellCommands__ = builtinShellCommands;
        __argBuiltinShellOptions__ = builtinShellOptions;
        __argCaCert__ = __nixpkgs__.cacert;
        __argName__ = name;
        __argSearchPaths__ = makeSearchPaths searchPaths;
        __argSearchPathsBase__ = searchPathsBase;
        __argSearchPathsEmpty__ = searchPathsEmpty;
        __argShell__ = "${__nixpkgs__.bash}/bin/bash";
      };
      name = "make-script-for-${name}";
      template = ./template.sh;
    };
  };
  builder = ./builder.sh;
  local = true;
  inherit name;
}
