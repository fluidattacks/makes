{
  __nixpkgs__,
  calculateScorecard,
  ...
}: {
  config,
  lib,
  ...
}: {
  options = {
    calculateScorecard = {
      checks = lib.mkOption {
        default = [];
        type = lib.types.listOf lib.types.str;
      };
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      format = lib.mkOption {
        default = "json";
        type = lib.types.str;
      };
      target = lib.mkOption {
        default = "";
        type = lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "/calculateScorecard" = lib.mkIf config.calculateScorecard.enable (
        calculateScorecard {
          checks =
            if config.calculateScorecard.checks == []
            then config.calculateScorecard.checks
            else builtins.concatStringsSep "," config.calculateScorecard.checks;
          format = config.calculateScorecard.format;
          target = config.calculateScorecard.target;
        }
      );
    };
  };
}
