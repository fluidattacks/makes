{ __nixpkgs__, __shellCommands__, makeTemplate, ... }:
{ append ? true, bin ? [ ], crystalLib ? [ ], export ? [ ], javaClass ? [ ]
, kubeConfig ? [ ], nodeBin ? [ ], nodeModule ? [ ], ocamlBin ? [ ]
, ocamlLib ? [ ], ocamlStublib ? [ ], pkgConfig ? [ ], pythonMypy ? [ ]
, pythonMypy38 ? [ ], pythonMypy39 ? [ ], pythonMypy310 ? [ ]
, pythonMypy311 ? [ ], pythonMypy312 ? [ ], pythonPackage ? [ ]
, pythonPackage38 ? [ ], pythonPackage39 ? [ ], pythonPackage310 ? [ ]
, pythonPackage311 ? [ ], pythonPackage312 ? [ ], rpath ? [ ], rubyBin ? [ ]
, rubyGemPath ? [ ], source ? [ ], withAction ? true, }:
let
  makeExport = envVar: envPath: envDrv:
    if append then
      ''
        export ${envVar}="${envDrv}${envPath}''${${envVar}:+:}''${${envVar}:-}"''
    else
      ''export ${envVar}="${envDrv}${envPath}"'';
  makeSource = envDrv:
    let
      type = builtins.typeOf envDrv;
      file = if type == "list" then builtins.head envDrv else envDrv;
      args = if type == "list" then
        __nixpkgs__.lib.strings.escapeShellArgs (builtins.tail envDrv)
      else
        "";
    in ''
      if test -e "${file}/template"
      then source "${file}/template" ${args}
      else source "${file}" ${args}
      fi
    '';
in makeTemplate {
  name = "make-search-paths";
  template = builtins.concatStringsSep "\n" (builtins.foldl' (sources:
    { generator, derivations, }:
    if (derivations == [ ]) then
      sources
    else
      sources ++ (builtins.map generator derivations)) [ ] [
        {
          derivations = export;
          generator = export:
            makeExport (builtins.elemAt export 0) (builtins.elemAt export 2)
            (builtins.elemAt export 1);
        }
        {
          derivations = bin;
          generator = makeExport "PATH" "/bin";
        }
        {
          derivations = crystalLib;
          generator = makeExport "CRYSTAL_LIBRARY_PATH" "/lib";
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
          derivations = ocamlBin;
          generator = makeExport "PATH" "/bin";
        }
        {
          derivations = ocamlLib;
          generator = makeExport "OCAMLPATH" "";
        }
        {
          derivations = ocamlStublib;
          generator = makeExport "CAML_LD_LIBRARY_PATH" "/stublibs";
        }
        {
          derivations = pythonMypy;
          generator = makeExport "MYPYPATH" "";
        }
        {
          derivations = pythonMypy39;
          generator = makeExport "MYPYPATH" "/lib/python3.9/site-packages";
        }
        {
          derivations = pythonMypy310;
          generator = makeExport "MYPYPATH" "/lib/python3.10/site-packages";
        }
        {
          derivations = pythonMypy311;
          generator = makeExport "MYPYPATH" "/lib/python3.11/site-packages";
        }
        {
          derivations = pythonMypy312;
          generator = makeExport "MYPYPATH" "/lib/python3.12/site-packages";
        }
        {
          derivations = pythonPackage;
          generator = makeExport "PYTHONPATH" "";
        }
        {
          derivations = pythonPackage39;
          generator = makeExport "PYTHONPATH" "/lib/python3.9/site-packages";
        }
        {
          derivations = pythonPackage310;
          generator = makeExport "PYTHONPATH" "/lib/python3.10/site-packages";
        }
        {
          derivations = pythonPackage311;
          generator = makeExport "PYTHONPATH" "/lib/python3.11/site-packages";
        }
        {
          derivations = pythonPackage312;
          generator = makeExport "PYTHONPATH" "/lib/python3.12/site-packages";
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
          derivations = rubyBin;
          generator = makeExport "PATH" "/bin";
        }
        {
          derivations = rubyGemPath;
          generator = makeExport "GEM_PATH" "/";
        }
        {
          derivations = [ __shellCommands__ ];
          generator = makeSource;
        }
        {
          derivations = source;
          generator = makeSource;
        }
      ]);
  inherit withAction;
}
