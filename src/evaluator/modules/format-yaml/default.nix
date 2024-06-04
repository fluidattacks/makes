{ formatYaml, ... }:
{ config, lib, ... }: {
  options = {
    formatYaml = {
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
      "/formatYaml" = lib.mkIf config.formatYaml.enable (formatYaml {
        name = "builtin";
        targets = builtins.map (rel: "." + rel) config.formatYaml.targets;
      });
    };
  };
}
