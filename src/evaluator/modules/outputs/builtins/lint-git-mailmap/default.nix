{ lintGitMailMap
, pathImpure
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
      "/lintGitMailMap" = lintGitMailMap {
        name = "lint-git-mailmap";
        src = pathImpure "/";
      };
    };
  };
}
