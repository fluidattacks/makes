{
  __nixpkgs__,
  attrsOptional,
  isLinux,
  lintGitCommitMsg,
  projectPath,
  ...
}: {
  config,
  lib,
  ...
}: {
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
  config = {
    outputs = {
      "/lintGitCommitMsg" =
        lib.mkIf
        config.lintGitCommitMsg.enable
        (lintGitCommitMsg {
          inherit (config.lintGitCommitMsg) branch;
          config =
            if config.lintGitCommitMsg.config == null
            then ./config.js
            else projectPath config.lintGitCommitMsg.config;
          name = "lint-git-commit-msg";
          parser =
            if config.lintGitCommitMsg.parser == null
            then ./parser.js
            else projectPath config.lintGitCommitMsg.parser;
          src = ".";
        });
    };
  };
}
