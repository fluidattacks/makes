{ formatTerraform
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
      "/formatTerraform" = lib.mkIf
        config.formatTerraform.enable
        (formatTerraform {
          name = "format-terraform";
          targets = config.formatTerraform.targets;
        });
    };
  };
}
