{ makesVersion
, ...
}:
{ config
, lib
, ...
}:
let
  versions = [
    "21.08-pre3"
  ];
in
{
  options = {
    makesVersion = lib.mkOption {
      type = lib.types.enum versions;
    };
    requiredMakesVersion = lib.mkOption {
      default = makesVersion;
      type = lib.types.enum versions;
    };
  };
  config = {
    assertions = [{
      assertion = config.requiredMakesVersion == makesVersion;
      message = "Project requires Makes v${config.requiredMakesVersion}. You are using v${makesVersion} instead.";
    }];
    makesVersion = makesVersion;
  };
}
