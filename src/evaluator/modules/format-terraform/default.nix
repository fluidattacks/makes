{ __outputsPrefix__
, formatTerraform
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    formatTerraform = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      targets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "${__outputsPrefix__}/formatTerraform" = lib.mkIf
        config.formatTerraform.enable
        (formatTerraform {
          name = "format-terraform";
          targets = config.formatTerraform.targets;
        });
    };
  };
}
