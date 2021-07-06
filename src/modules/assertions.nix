{ config
, lib
, ...
}:
{
  options = {
    assertionsPassed = lib.mkOption {
      type = lib.types.bool;
    };
    assertions = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule ({ ... }: {
        options = {
          assertion = lib.mkOption {
            type = lib.types.bool;
          };
          message = lib.mkOption {
            type = lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    assertionsPassed = builtins.all
      ({ assertion, message }:
        if !assertion
        then abort message
        else assertion)
      config.assertions;
  };
}
