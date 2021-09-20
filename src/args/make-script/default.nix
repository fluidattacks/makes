{ __nixpkgs__
, toBashArray
, __shellCommands__
, __shellOptions__
, makeDerivation
, makeSearchPaths
, makeTemplate
, toDerivationName
, __projectStateDir__
, __globalStateDir__
, ...
}:
{ aliases ? [ ]
, entrypoint
, name
, help ? null
, replace ? { }
, searchPaths ? { }
, persistState ? false
, globalState ? if (__projectStateDir__ == __globalStateDir__) then true else false
}:
assert (if (__projectStateDir__ == __globalStateDir__) then globalState else true);
let
  # Minimalistic shell environment
  # Let's try to keep it as lightweight as possible because this
  # propagates to all built apps and packages
  searchPathsBase = makeSearchPaths {
    append = false;
    bin = [ __nixpkgs__.coreutils ];
  };
  # Clean Search Paths before starting
  # To ensure there are no impurities
  searchPathsEmpty = makeSearchPaths
    (builtins.mapAttrs
      (name: _:
        if name == "append"
        then false
        else if name == "export"
        then [ ]
        else if name == "source"
        then [ ]
        else [ "/not-set" ])
      (builtins.functionArgs makeSearchPaths));

  aliases' = builtins.map toDerivationName aliases;
  name' = toDerivationName name;
in
makeDerivation {
  action = ''
    "$1/bin/${name'}" "''${@:2}"
  '';
  env = {
    envAliases = toBashArray ([ name' ] ++ aliases');
    envEntrypoint = makeTemplate {
      inherit replace;
      inherit name;
      template = entrypoint;
    };
    envEntrypointSetup = makeTemplate {
      replace = {
        __argShellCommands__ = __shellCommands__;
        __argShellOptions__ = __shellOptions__;
        __argCaCert__ = __nixpkgs__.cacert;
        __argName__ = name';
        __argProjectStateDir__ = __projectStateDir__;
        __argGlobalStateDir__ = __globalStateDir__;
        __argSearchPaths__ = makeSearchPaths searchPaths;
        __argSearchPathsBase__ = searchPathsBase;
        __argSearchPathsEmpty__ = searchPathsEmpty;
        __argShell__ = "${__nixpkgs__.bash}/bin/bash";
        __argPersistState__ = if persistState then 1 else 0;
        __argGlobalState__ = if globalState then 1 else 0;
      };
      name = "make-script-for-${name}";
      template = ./template.sh;
    };
  };
  builder = ./builder.sh;
  local = true;
  inherit name help;
}
