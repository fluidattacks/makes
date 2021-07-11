{ __nixpkgs__
, builtinLambdas
, makeNodeEnvironment
, makeScript
, pathImpure
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    formatMarkdown = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      doctocArgs = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
      };
      targets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "/formatMarkdown" = lib.mkIf config.formatMarkdown.enable (makeScript {
        arguments = {
          envDoctocArgs = builtinLambdas.asBashArray
            config.formatMarkdown.doctocArgs;
          envTargets = builtinLambdas.asBashArray
            (builtins.map pathImpure config.formatMarkdown.targets);
        };
        name = "format-markdown";
        searchPaths = {
          envPaths = [
            __nixpkgs__.git
            __nixpkgs__.gnugrep
            __nixpkgs__.gnused
          ];
          envSources = [
            (makeNodeEnvironment {
              name = "doctoc";
              node = "16";
              dependencies = [ "doctoc@2.0.1" ];
              subDependencies = [
                "@textlint/ast-node-types@4.4.3"
                "@textlint/markdown-to-ast@6.1.7"
                "anchor-markdown-header@0.5.7"
                "bail@1.0.5"
                "boundary@1.0.1"
                "character-entities-legacy@1.1.4"
                "character-entities@1.2.4"
                "character-reference-invalid@1.1.4"
                "collapse-white-space@1.0.6"
                "debug@4.3.2"
                "dom-serializer@1.3.2"
                "domelementtype@2.2.0"
                "domhandler@3.3.0"
                "domutils@2.7.0"
                "emoji-regex@6.1.3"
                "entities@2.2.0"
                "extend@3.0.2"
                "fault@1.0.4"
                "format@0.2.2"
                "htmlparser2@4.1.0"
                "inherits@2.0.4"
                "is-alphabetical@1.0.4"
                "is-alphanumerical@1.0.4"
                "is-buffer@1.1.6"
                "is-decimal@1.0.4"
                "is-hexadecimal@1.0.4"
                "is-plain-obj@1.1.0"
                "is-whitespace-character@1.0.4"
                "is-word-character@1.0.4"
                "markdown-escapes@1.0.4"
                "minimist@1.2.5"
                "ms@2.1.2"
                "parse-entities@1.2.2"
                "remark-frontmatter@1.3.3"
                "remark-parse@5.0.0"
                "repeat-string@1.6.1"
                "replace-ext@1.0.0"
                "state-toggle@1.0.3"
                "structured-source@3.0.2"
                "traverse@0.6.6"
                "trim-trailing-lines@1.1.4"
                "trim@0.0.1"
                "trough@1.0.5"
                "underscore@1.12.1"
                "unherit@1.1.3"
                "unified@6.2.0"
                "unist-util-is@3.0.0"
                "unist-util-remove-position@1.1.4"
                "unist-util-stringify-position@1.1.2"
                "unist-util-visit-parents@2.1.2"
                "unist-util-visit@1.4.1"
                "update-section@0.3.3"
                "vfile-location@2.0.6"
                "vfile-message@1.1.1"
                "vfile@2.3.0"
                "x-is-string@0.1.0"
                "xtend@4.0.2"
              ];
            })
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
