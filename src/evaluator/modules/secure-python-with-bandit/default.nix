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
  makeModule = name: {target}: {
    name = "/securePythonWithBandit/${name}";
    value = securePythonWithBandit {
      inherit name;
      target = projectPath target;
    };
  };
in {
  options = {
    securePythonWithBandit = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
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
