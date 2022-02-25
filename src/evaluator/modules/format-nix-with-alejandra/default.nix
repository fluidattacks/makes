{ formatNixWithAlejandra
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    formatNixWithAlejandra = {
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
      "/formatNixWithAlejandra" = lib.mkIf config.formatNixWithAlejandra.enable (formatNixWithAlejandra {
        name = "builtin";
        targets = builtins.map (rel: "." + rel) config.formatBash.targets;
      });
    };
  };
}
