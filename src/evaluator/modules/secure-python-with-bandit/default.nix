{
  __toModuleOutputs__,
  projectPath,
  securePythonWithBandit,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeModule = name: {
    python,
    target,
  }: {
    name = "/securePythonWithBandit/${name}";
    value = securePythonWithBandit {
      inherit name;
      inherit python;
      target = projectPath target;
    };
  };
in {
  options = {
    securePythonWithBandit = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          python = lib.mkOption {
            type = lib.types.enum ["3.9" "3.10" "3.11" "3.12"];
          };
          target = lib.mkOption {
            type = lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeModule config.securePythonWithBandit;
  };
}
