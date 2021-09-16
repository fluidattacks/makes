{ lintGitMailMap
, projectPathMutable
, ...
}:
{ lib
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
        (config.lintGitCommitMsg.enable)
        (lintGitMailMap {
          name = "lint-git-mailmap";
          src = projectPathMutable "/";
        });
    };
  };
}
