{ testLicense, ... }:
{ config, lib, ... }: {
  options = {
    testLicense = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
    };
  };
  config = {
    outputs = {
      "/testLicense" = lib.mkIf config.testLicense.enable testLicense;
    };
  };
}
