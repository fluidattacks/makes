{ builtinShellCommands
, makeTemplate
, ...
}:

{ append ? true
, bin ? [ ]
, javaClass ? [ ]
, nodeBin ? [ ]
, nodeModule ? [ ]
, pythonMypy ? [ ]
, pythonMypy38 ? [ ]
, pythonPackage ? [ ]
, pythonPackage37 ? [ ]
, pythonPackage38 ? [ ]
, pythonPackage39 ? [ ]
, rpath ? [ ]
, source ? [ ]
}:
let
  export = envVar: envPath: envDrv:
    if append
    then "export ${envVar}=\"${envDrv}${envPath}\${${envVar}:+:}\${${envVar}:-}\""
    else "export ${envVar}=\"${envDrv}${envPath}\"";
  sourceDrv = envDrv:
    ''
      if test -e "${envDrv}/makes-setup.sh"; then
        source "${envDrv}/makes-setup.sh"
      else
        source "${envDrv}"
      fi
    '';
in
makeTemplate {
  name = "make-search-paths";
  template = builtins.concatStringsSep "\n" (builtins.foldl'
    (sources: { generator, derivations }:
      if (derivations == [ ])
      then sources
      else sources ++ (builtins.map generator derivations)
    )
    [ ]
    [
      {
        derivations = bin;
        generator = export "PATH" "/bin";
      }
      {
        derivations = javaClass;
        generator = export "CLASSPATH" "";
      }
      {
        derivations = nodeBin;
        generator = export "PATH" "/node_modules/.bin";
      }
      {
        derivations = nodeModule;
        generator = export "NODE_PATH" "/node_modules";
      }
      {
        derivations = pythonMypy;
        generator = export "MYPYPATH" "";
      }
      {
        derivations = pythonMypy38;
        generator = export "MYPYPATH" "/lib/python3.8/site-packages";
      }
      {
        derivations = pythonPackage;
        generator = export "PYTHONPATH" "";
      }
      {
        derivations = pythonPackage37;
        generator = export "PYTHONPATH" "/lib/python3.7/site-packages";
      }
      {
        derivations = pythonPackage38;
        generator = export "PYTHONPATH" "/lib/python3.8/site-packages";
      }
      {
        derivations = pythonPackage39;
        generator = export "PYTHONPATH" "/lib/python3.9/site-packages";
      }
      {
        derivations = rpath;
        generator = export "LD_LIBRARY_PATH" "/lib";
      }
      {
        derivations = rpath;
        generator = export "LD_LIBRARY_PATH" "/lib64";
      }
      {
        derivations = [ builtinShellCommands ];
        generator = sourceDrv;
      }
      {
        derivations = source;
        generator = sourceDrv;
      }
    ]
  );
}
