{ lintGitMailMap
, __outputsPrefix__
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
      "${__outputsPrefix__}/lintGitMailMap" = lintGitMailMap {
        name = "lint-git-mailmap";
        src = projectPathMutable "/";
      };
    };
  };
}
