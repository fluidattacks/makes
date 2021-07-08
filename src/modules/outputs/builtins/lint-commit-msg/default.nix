{ inputs
, lib
, makeNodeEnvironment
, makeScript
, ...
}:
{ config
, ...
}:
{
  options = {
    lintCommitMsg = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      branch = lib.mkOption {
        default = "main";
        type = lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "/lintCommitMsg" = lib.mkIf config.lintCommitMsg.enable (makeScript {
        name = "lint-commit-msg";
        arguments = {
          envBranch = config.lintCommitMsg.branch;
        };
        searchPaths = {
          envPaths = [
            inputs.makesPackages.nixpkgs.git
          ];
          envSources = [
            (makeNodeEnvironment {
              dependencies = [ "@commitlint/cli@11.0.0" ];
              name = "lint-node-for-lint-commit-msg";
              node = "10";
              subDependencies = [
                "@babel/code-frame@7.12.13"
                "@babel/helper-validator-identifier@7.12.11"
                "@babel/highlight@7.12.13"
                "@babel/runtime@7.12.13"
                "@commitlint/ensure@11.0.0"
                "@commitlint/execute-rule@11.0.0"
                "@commitlint/format@11.0.0"
                "@commitlint/is-ignored@11.0.0"
                "@commitlint/lint@11.0.0"
                "@commitlint/load@11.0.0"
                "@commitlint/message@11.0.0"
                "@commitlint/parse@11.0.0"
                "@commitlint/read@11.0.0"
                "@commitlint/resolve-extends@11.0.0"
                "@commitlint/rules@11.0.0"
                "@commitlint/to-lines@11.0.0"
                "@commitlint/top-level@11.0.0"
                "@commitlint/types@11.0.0"
                "@types/minimist@1.2.1"
                "@types/normalize-package-data@2.4.0"
                "@types/parse-json@4.0.0"
                "JSONStream@1.3.5"
                "ansi-regex@5.0.0"
                "ansi-styles@3.2.1"
                "array-ify@1.0.0"
                "arrify@1.0.1"
                "at-least-node@1.0.0"
                "callsites@3.1.0"
                "camelcase-keys@6.2.2"
                "camelcase@5.3.1"
                "chalk@2.4.2"
                "cliui@6.0.0"
                "color-convert@1.9.3"
                "color-name@1.1.3"
                "compare-func@2.0.0"
                "conventional-changelog-angular@5.0.12"
                "conventional-commits-parser@3.2.0"
                "core-js@3.8.3"
                "core-util-is@1.0.2"
                "cosmiconfig@7.0.0"
                "dargs@7.0.0"
                "decamelize-keys@1.1.0"
                "decamelize@1.2.0"
                "dot-prop@5.3.0"
                "emoji-regex@8.0.0"
                "error-ex@1.3.2"
                "escape-string-regexp@1.0.5"
                "find-up@4.1.0"
                "fs-extra@9.1.0"
                "function-bind@1.1.1"
                "get-caller-file@2.0.5"
                "get-stdin@8.0.0"
                "git-raw-commits@2.0.10"
                "global-dirs@0.1.1"
                "graceful-fs@4.2.5"
                "hard-rejection@2.1.0"
                "has-flag@3.0.0"
                "has@1.0.3"
                "hosted-git-info@3.0.8"
                "import-fresh@3.3.0"
                "indent-string@4.0.0"
                "inherits@2.0.4"
                "ini@1.3.8"
                "is-arrayish@0.2.1"
                "is-core-module@2.2.0"
                "is-fullwidth-code-point@3.0.0"
                "is-obj@2.0.0"
                "is-plain-obj@1.1.0"
                "is-text-path@1.0.1"
                "isarray@1.0.0"
                "js-tokens@4.0.0"
                "json-parse-even-better-errors@2.3.1"
                "jsonfile@6.1.0"
                "jsonparse@1.3.1"
                "kind-of@6.0.3"
                "lines-and-columns@1.1.6"
                "locate-path@5.0.0"
                "lodash@4.17.20"
                "lru-cache@6.0.0"
                "map-obj@4.1.0"
                "meow@8.1.2"
                "min-indent@1.0.1"
                "minimist-options@4.1.0"
                "normalize-package-data@3.0.0"
                "p-limit@2.3.0"
                "p-locate@4.1.0"
                "p-try@2.2.0"
                "parent-module@1.0.1"
                "parse-json@5.2.0"
                "path-exists@4.0.0"
                "path-parse@1.0.6"
                "path-type@4.0.0"
                "process-nextick-args@2.0.1"
                "q@1.5.1"
                "quick-lru@4.0.1"
                "read-pkg-up@7.0.1"
                "read-pkg@5.2.0"
                "readable-stream@2.3.7"
                "redent@3.0.0"
                "regenerator-runtime@0.13.7"
                "require-directory@2.1.1"
                "require-main-filename@2.0.0"
                "resolve-from@5.0.0"
                "resolve-global@1.0.0"
                "resolve@1.19.0"
                "safe-buffer@5.1.2"
                "semver@7.3.2"
                "set-blocking@2.0.0"
                "spdx-correct@3.1.1"
                "spdx-exceptions@2.3.0"
                "spdx-expression-parse@3.0.1"
                "spdx-license-ids@3.0.7"
                "split2@2.2.0"
                "string-width@4.2.0"
                "string_decoder@1.1.1"
                "strip-ansi@6.0.0"
                "strip-indent@3.0.0"
                "supports-color@5.5.0"
                "text-extensions@1.9.0"
                "through2@4.0.2"
                "through@2.3.8"
                "trim-newlines@3.0.0"
                "trim-off-newlines@1.0.1"
                "type-fest@0.18.1"
                "universalify@2.0.0"
                "util-deprecate@1.0.2"
                "validate-npm-package-license@3.0.4"
                "which-module@2.0.0"
                "wrap-ansi@6.2.0"
                "xtend@4.0.2"
                "y18n@4.0.1"
                "yallist@4.0.0"
                "yaml@1.10.0"
                "yargs-parser@20.2.4"
                "yargs@15.4.1"
                "yocto-queue@0.1.0"
              ];
            })
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
