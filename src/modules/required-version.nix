{ makesVersion
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    requiredMakesVersion = lib.mkOption {
      type = lib.types.enum [
        "21.08-pre1"
      ];
    };
  };
  config = {
    assertions = [{
      assertion = config.requiredMakesVersion == makesVersion;
      message = "Project requires Makes v${config.requiredMakesVersion}. You are using v${makesVersion} instead.";
    }];
  };
}
