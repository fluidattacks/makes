{ __shellCommands__
, makeTemplate
, ...
}:

{ append ? true
, bin ? [ ]
, export ? [ ]
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
  makeExport = envVar: envPath: envDrv:
    if append
    then "export ${envVar}=\"${envDrv}${envPath}\${${envVar}:+:}\${${envVar}:-}\""
    else "export ${envVar}=\"${envDrv}${envPath}\"";
  makeSource = envDrv:
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
    ([
      {
        derivations = export;
        generator = export: makeExport
          (builtins.elemAt export 0)
          (builtins.elemAt export 2)
          (builtins.elemAt export 1);
      }
      {
        derivations = bin;
        generator = makeExport "PATH" "/bin";
      }
      {
        derivations = pkgConfig;
        generator = makeExport "PKG_CONFIG_PATH" "/lib/pkgconfig";
      }
      {
        derivations = javaClass;
        generator = makeExport "CLASSPATH" "";
      }
      {
        derivations = kubeConfig;
        generator = makeExport "KUBECONFIG" "";
      }
      {
        derivations = nodeBin;
        generator = makeExport "PATH" "/.bin";
      }
      {
        derivations = nodeModule;
        generator = makeExport "NODE_PATH" "";
      }
      {
        derivations = pythonMypy;
        generator = makeExport "MYPYPATH" "";
      }
      {
        derivations = pythonMypy37;
        generator = makeExport "MYPYPATH" "/lib/python3.7/site-packages";
      }
      {
        derivations = pythonMypy38;
        generator = makeExport "MYPYPATH" "/lib/python3.8/site-packages";
      }
      {
        derivations = pythonMypy39;
        generator = makeExport "MYPYPATH" "/lib/python3.9/site-packages";
      }
      {
        derivations = pythonPackage;
        generator = makeExport "PYTHONPATH" "";
      }
      {
        derivations = pythonPackage36;
        generator = makeExport "PYTHONPATH" "/lib/python3.6/site-packages";
      }
      {
        derivations = pythonPackage37;
        generator = makeExport "PYTHONPATH" "/lib/python3.7/site-packages";
      }
      {
        derivations = pythonPackage38;
        generator = makeExport "PYTHONPATH" "/lib/python3.8/site-packages";
      }
      {
        derivations = pythonPackage39;
        generator = makeExport "PYTHONPATH" "/lib/python3.9/site-packages";
      }
      {
        derivations = rpath;
        generator = makeExport "LD_LIBRARY_PATH" "/lib";
      }
      {
        derivations = rpath;
        generator = makeExport "LD_LIBRARY_PATH" "/lib64";
      }
      {
        derivations = [ __shellCommands__ ];
        generator = makeSource;
      }
      {
        derivations = source;
        generator = makeSource;
      }
    ])
  );
}
