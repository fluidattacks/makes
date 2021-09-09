{ __nixpkgs__
, attrsOptional
, isLinux
, lintGitCommitMsg
, projectPath
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
        default = null;
        type = lib.types.nullOr lib.types.str;
      };
      parser = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
      };
    };
  };
  config = attrsOptional isLinux {
    outputs = {
      "/lintGitCommitMsg" = lib.mkIf
        (config.lintGitCommitMsg.enable)
        (lintGitCommitMsg {
          branch = config.lintGitCommitMsg.branch;
          config =
            if config.lintGitCommitMsg.config == null
            then ./config.js
            else projectPath config.lintGitCommitMsg.config;
          name = "lint-git-commit-msg";
          parser =
            if config.lintGitCommitMsg.parser == null
            then ./parser.js
            else projectPath config.lintGitCommitMsg.parser;
          src = projectPathMutable "/";
        });
    };
  };
}
