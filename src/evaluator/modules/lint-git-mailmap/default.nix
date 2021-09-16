{ lintGitMailMap
, projectPathMutable
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    lintGitMailMap = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
    };
  };
  config = {
    outputs = {
      "/lintGitMailMap" = lib.mkIf
        (config.lintGitMailMap.enable)
        (lintGitMailMap {
          name = "lint-git-mailmap";
          src = projectPathMutable "/";
        });
    };
  };
}
