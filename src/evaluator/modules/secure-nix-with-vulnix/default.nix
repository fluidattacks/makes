{ __toModuleOutputs__
, secureNixWithVulnix
, ...
}:
{ config
, lib
, ...
}:
let
  makeModule = name: { derivations, whitelist }: {
    name = "/secureNixWithVulnix/${name}";
    value = secureNixWithVulnix {
      inherit name;
      inherit derivations;
      inherit whitelist;
    };
  };
in
{
  options = {
    secureNixWithVulnix = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          derivations = lib.mkOption {
            type = lib.types.listOf lib.types.package;
          };
          whitelist = lib.mkOption {
            default = { };
            type = lib.types.anything;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeModule config.secureNixWithVulnix;
  };
}
