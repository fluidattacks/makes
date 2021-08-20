{ __nixpkgs__
, __toModuleOutputs__
, makeDerivation
, makeDerivationParallel
, makePythonPypiEnvironment
, projectPath
, projectPathLsDirs
, ...
}:
{ config
, lib
, ...
}:
let
  makeModule = name: { extraSources, python, src }: {
    name = "/lintPython/module/${name}";
    value = makeDerivation {
      env = {
        envSettingsMypy = ./settings-mypy.cfg;
        envSettingsProspector = ./settings-prospector.yaml;
        envSrc = projectPath src;
      };
      name = "lint-python-module-for-${name}";
      searchPaths = {
        bin = [
          __nixpkgs__.findutils
        ];
        source = extraSources ++ [
          (makePythonPypiEnvironment {
            name = "lint-python";
            sourcesJson = {
              "3.7" = ./sources-3.7.json;
              "3.8" = ./sources-3.8.json;
              "3.9" = ./sources-3.9.json;
            }.${python};
            withSetuptools_57_4_0 = true;
            withSetuptoolsScm_6_0_1 = true;
            withWheel_0_37_0 = true;
          })
        ];
      };
      builder = ./builder.sh;
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
      (__toModuleOutputs__ makeModule config.lintPython.modules) //
      (__toModuleOutputs__ makeDirOfModules config.lintPython.dirsOfModules);
  };
}
