{
  __toModuleOutputs__,
  lintPython,
  lintPythonImports,
  makeDerivationParallel,
  projectPath,
  projectPathLsDirs,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeImports = name: {
    config,
    searchPaths,
    src,
  }: {
    name = "/lintPython/imports/${name}";
    value = lintPythonImports {
      inherit searchPaths;
      config = projectPath config;
      inherit name;
      src = projectPath src;
    };
  };
  makeModule = name: {
    searchPaths,
    python,
    src,
  }: {
    name = "/lintPython/module/${name}";
    value = lintPython {
      inherit searchPaths;
      inherit name;
      inherit python;
      settingsMypy = ./settings-mypy.cfg;
      settingsProspector = ./settings-prospector.yaml;
      src = projectPath src;
    };
  };
  makeDirOfModules = name: {
    searchPaths,
    python,
    src,
  }: let
    modules =
      builtins.map
      (moduleName: {
        name = "/lintPython/dirOfModules/${name}/${moduleName}";
        value =
          (makeModule moduleName {
            inherit searchPaths;
            inherit python;
            src = "${src}/${moduleName}";
          })
          .value;
      })
      (projectPathLsDirs src);
  in (modules
    ++ [
      {
        name = "/lintPython/dirOfModules/${name}";
        value = makeDerivationParallel {
          dependencies = lib.attrsets.catAttrs "value" modules;
          name = "lint-python-dir-of-modules-for-${name}";
        };
      }
    ]);
in {
  options = {
    lintPython = {
      dirsOfModules = lib.mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            python = lib.mkOption {
              type = lib.types.enum ["3.7" "3.8" "3.9" "3.10"];
            };
            searchPaths = lib.mkOption {
              default = {};
              type = lib.types.attrs;
            };
            src = lib.mkOption {
              type = lib.types.str;
            };
          };
        }));
      };
      imports = lib.mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            config = lib.mkOption {
              type = lib.types.str;
            };
            searchPaths = lib.mkOption {
              default = {};
              type = lib.types.attrs;
            };
            src = lib.mkOption {
              type = lib.types.str;
            };
          };
        }));
      };
      modules = lib.mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            python = lib.mkOption {
              type = lib.types.enum ["3.7" "3.8" "3.9" "3.10"];
            };
            searchPaths = lib.mkOption {
              default = {};
              type = lib.types.attrs;
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
      (__toModuleOutputs__ makeDirOfModules config.lintPython.dirsOfModules)
      // (__toModuleOutputs__ makeImports config.lintPython.imports)
      // (__toModuleOutputs__ makeModule config.lintPython.modules);
  };
}
