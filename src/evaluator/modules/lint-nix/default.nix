{ lintNix, ... }:
{ config, lib, ... }: {
  options = {
    lintNix = {
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
      "/lintNix" = lib.mkIf config.lintNix.enable (lintNix {
        name = "builtin";
        targets = builtins.map (rel: "." + rel) config.lintNix.targets;
      });
    };
  };
}
