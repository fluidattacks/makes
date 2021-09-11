{ __shellCommands__
, makeTemplate
, ...
}:

{ append ? true
, bin ? [ ]
, javaClass ? [ ]
, kubeConfig ? [ ]
, nodeBin ? [ ]
, nodeModule ? [ ]
, pkgConfig ? [ ]
, pythonMypy ? [ ]
, pythonMypy37 ? [ ]
, pythonMypy38 ? [ ]
, pythonMypy39 ? [ ]
, pythonPackage ? [ ]
, pythonPackage36 ? [ ]
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
      if test -e "${envDrv}/template"
      then source "${envDrv}/template"
      else source "${envDrv}"
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
        derivations = pkgConfig;
        generator = export "PKG_CONFIG_PATH" "/lib/pkgconfig";
      }
      {
        derivations = javaClass;
        generator = export "CLASSPATH" "";
      }
      {
        derivations = kubeConfig;
        generator = export "KUBECONFIG" "";
      }
      {
        derivations = nodeBin;
        generator = export "PATH" "/.bin";
      }
      {
        derivations = nodeModule;
        generator = export "NODE_PATH" "";
      }
      {
        derivations = pythonMypy;
        generator = export "MYPYPATH" "";
      }
      {
        derivations = pythonMypy37;
        generator = export "MYPYPATH" "/lib/python3.7/site-packages";
      }
      {
        derivations = pythonMypy38;
        generator = export "MYPYPATH" "/lib/python3.8/site-packages";
      }
      {
        derivations = pythonMypy39;
        generator = export "MYPYPATH" "/lib/python3.9/site-packages";
      }
      {
        derivations = pythonPackage;
        generator = export "PYTHONPATH" "";
      }
      {
        derivations = pythonPackage36;
        generator = export "PYTHONPATH" "/lib/python3.6/site-packages";
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
        derivations = [ __shellCommands__ ];
        generator = sourceDrv;
      }
      {
        derivations = source;
        generator = sourceDrv;
      }
    ]
  );
}
