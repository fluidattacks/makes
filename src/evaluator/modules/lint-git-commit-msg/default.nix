{ lintGitCommitMsg
, __outputsPrefix__
, projectPathMutable
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    lintGitCommitMsg = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      branch = lib.mkOption {
        default = "main";
        type = lib.types.str;
      };
      config = lib.mkOption {
        default = ./config.js;
        type = lib.types.path;
      };
      parser = lib.mkOption {
        default = ./parser.js;
        type = lib.types.path;
      };
    };
  };
  config = {
    outputs = {
      "${__outputsPrefix__}/lintGitCommitMsg" = lib.mkIf
        (config.lintGitCommitMsg.enable)
        (lintGitCommitMsg {
          branch = config.lintGitCommitMsg.branch;
          config = config.lintGitCommitMsg.config;
          name = "lint-git-commit-msg";
          parser = config.lintGitCommitMsg.parser;
          src = projectPathMutable "/";
        });
    };
  };
}
