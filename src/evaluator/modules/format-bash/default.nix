{ formatBash
, __outputsPrefix__
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    formatBash = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      targets = lib.mkOption {
        default = [ "/" ];
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "${__outputsPrefix__}/formatBash" = lib.mkIf config.formatBash.enable (formatBash {
        name = "builtin";
        targets = config.formatBash.targets;
      });
    };
  };
}
