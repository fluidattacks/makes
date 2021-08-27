{ __toModuleOutputs__
, lintPython
, lintPythonImports
, makeDerivationParallel
, projectPath
, projectPathLsDirs
, ...
}:
{ config
, lib
, ...
}:
let
  makeImports = name: { config, src }: {
    name = "/lintPython/imports/${name}";
    value = lintPythonImports {
      config = projectPath config;
      inherit name;
      src = projectPath src;
    };
  };
  makeModule = name: { extraSources, python, src }: {
    name = "/lintPython/module/${name}";
    value = lintPython {
      inherit extraSources;
      inherit name;
      inherit python;
      settingsMypy = ./settings-mypy.cfg;
      settingsProspector = ./settings-prospector.yaml;
      src = projectPath src;
    };
  };
  makeDirOfModules = name: { extraSources, python, src }:
    let
      modules = builtins.map
        (moduleName: {
          name = "/lintPython/dirOfModules/${name}/${moduleName}";
          value = (makeModule moduleName {
            inherit extraSources;
            inherit python;
            src = "${src}/${moduleName}";
          }).value;
        })
        (projectPathLsDirs src);
    in
    (modules ++ [{
      name = "/lintPython/dirOfModules/${name}";
      value = makeDerivationParallel {
        dependencies = lib.attrsets.catAttrs "value" modules;
        name = "lint-python-dir-of-modules-for-${name}";
      };
    }]);
in
{
  options = {
    lintPython = {
      dirsOfModules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            extraSources = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.package;
            };
            python = lib.mkOption {
              type = lib.types.enum [ "3.7" "3.8" "3.9" ];
            };
            src = lib.mkOption {
              type = lib.types.str;
            };
          };
        }));
      };
      imports = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            config = lib.mkOption {
              type = lib.types.str;
            };
            src = lib.mkOption {
              type = lib.types.str;
            };
          };
        }));
      };
      modules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            extraSources = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.package;
            };
            python = lib.mkOption {
              type = lib.types.enum [ "3.7" "3.8" "3.9" ];
            };
            src = lib.mkOption {
              type = lib.types.str;
            };
          };
        }));
      };
    };
  };
  config = {
    outputs =
      (__toModuleOutputs__ makeDirOfModules config.lintPython.dirsOfModules) //
      (__toModuleOutputs__ makeImports config.lintPython.imports) //
      (__toModuleOutputs__ makeModule config.lintPython.modules);
  };
}
