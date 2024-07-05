{ __toModuleOutputs__, lintPython, lintPythonImports, makeDerivationParallel
, projectPath, projectPathLsDirs, ... }:
{ config, lib, ... }:
let
  makeImports = name:
    { config, searchPaths, src, }: {
      name = "/lintPython/imports/${name}";
      value = lintPythonImports {
        inherit searchPaths;
        config = projectPath config;
        inherit name;
        src = projectPath src;
      };
    };
  makeModule = name:
    { config, searchPaths, src, }: {
      name = "/lintPython/module/${name}";
      value = lintPython {
        inherit searchPaths;
        inherit name;
        settingsMypy = config.mypy;
        settingsProspector = config.prospector;
        src = projectPath src;
      };
    };
  makeDirOfModules = name:
    { config, searchPaths, src, }:
    let
      modules = builtins.map (moduleName: {
        name = "/lintPython/dirOfModules/${name}/${moduleName}";
        inherit ((makeModule moduleName {
          inherit config;
          inherit searchPaths;
          src = "${src}/${moduleName}";
        }))
          value;
      }) (projectPathLsDirs src);
    in modules ++ [{
      name = "/lintPython/dirOfModules/${name}";
      value = makeDerivationParallel {
        dependencies = lib.attrsets.catAttrs "value" modules;
        name = "lint-python-dir-of-modules-for-${name}";
      };
    }];
in {
  options = {
    lintPython = {
      dirOfModules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            config = {
              mypy = lib.mkOption {
                default = ./settings-mypy.cfg;
                type = lib.types.path;
              };
              prospector = lib.mkOption {
                default = ./settings-prospector.yaml;
                type = lib.types.path;
              };
            };
            searchPaths = lib.mkOption {
              default = { };
              type = lib.types.attrs;
            };
            src = lib.mkOption { type = lib.types.str; };
          };
        }));
      };
      imports = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            config = lib.mkOption { type = lib.types.str; };
            searchPaths = lib.mkOption {
              default = { };
              type = lib.types.attrs;
            };
            src = lib.mkOption { type = lib.types.str; };
          };
        }));
      };
      modules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            config = {
              mypy = lib.mkOption {
                default = ./settings-mypy.cfg;
                type = lib.types.path;
              };
              prospector = lib.mkOption {
                default = ./settings-prospector.yaml;
                type = lib.types.path;
              };
            };
            searchPaths = lib.mkOption {
              default = { };
              type = lib.types.attrs;
            };
            src = lib.mkOption { type = lib.types.str; };
          };
        }));
      };
    };
  };
  config = {
    outputs =
      (__toModuleOutputs__ makeDirOfModules config.lintPython.dirOfModules)
      // (__toModuleOutputs__ makeImports config.lintPython.imports)
      // (__toModuleOutputs__ makeModule config.lintPython.modules);
  };
}
