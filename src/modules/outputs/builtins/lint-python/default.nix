{ inputs
, lib
, makeDerivation
, makePythonEnvironment
, path
, ...
}:
{ config
, ...
}:
{
  options = {
    lintPython = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      packages = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
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
    outputs = lib.mkIf config.lintPython.enable
      (lib.attrsets.mapAttrs'
        (name: { python, src }: {
          name = "/lintPython/${name}";
          value = makeDerivation {
            arguments = {
              envSettingsMypy = ./settings-mypy.cfg;
              envSettingsProspector = ./settings-prospector.yaml;
              envSrc = path src;
            };
            name = "lint-python-for-${name}";
            searchPaths = {
              envPaths = [
                inputs.makesPackages.nixpkgs.findutils
              ];
              envSources = [
                (makePythonEnvironment {
                  dependencies = [
                    "mypy==0.910"
                    "prospector==1.3.1"
                    "returns==0.16.0"
                  ];
                  name = "lint-python-for-${name}";
                  inherit python;
                  subDependencies = [
                    "astroid==2.4.1"
                    "dodgy==0.2.1"
                    "flake8-polyfill==1.0.2"
                    "flake8==3.9.2"
                    "isort==4.3.21"
                    "lazy-object-proxy==1.4.3"
                    "mccabe==0.6.1"
                    "mypy-extensions==0.4.3"
                    "pep8-naming==0.10.0"
                    "pycodestyle==2.6.0"
                    "pydocstyle==6.1.1"
                    "pyflakes==2.2.0"
                    "pylint-celery==0.3"
                    "pylint-django==2.1.0"
                    "pylint-flask==0.6"
                    "pylint-plugin-utils==0.6"
                    "pylint==2.5.3"
                    "PyYAML==5.4.1"
                    "requirements-detector==0.7"
                    "setoptconf==0.2.0"
                    "six==1.16.0"
                    "snowballstemmer==2.1.0"
                    "toml==0.10.2"
                    "typing-extensions==3.10.0.0"
                    "wrapt==1.12.1"
                  ];
                })
              ];
            };
            builder = ./builder.sh;
          };
        })
        config.lintPython.packages);
  };
}
