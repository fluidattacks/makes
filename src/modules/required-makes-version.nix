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
      default = makesVersion;
      type = lib.types.str;
    };
  };
  config = {
    assertions = [{
      assertion = config.requiredMakesVersion == makesVersion;
      message = "Project requires Makes v${config.requiredMakesVersion}. You are using v${makesVersion} instead.";
    }];
  };
}
