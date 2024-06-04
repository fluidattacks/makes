{ lintGitMailMap, ... }:
{ config, lib, ... }: {
  options = {
    lintGitMailMap = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      exclude = lib.mkOption {
        default = "^$";
        type = lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "/lintGitMailMap" = lib.mkIf config.lintGitMailMap.enable
        (lintGitMailMap {
          name = "lint-git-mailmap";
          src = ".";
          inherit (config.lintGitMailMap) exclude;
        });
    };
  };
}
