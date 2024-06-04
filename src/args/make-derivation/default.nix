{ __nixpkgs__, __shellCommands__, __shellOptions__, __system__, asContent
, hasPrefix, hasSuffix, makeSearchPaths, attrsOptional, toDerivationName, ... }:
{ action ? null, builder, env ? { }, envFiles ? { }, local ? false, name
, help ? null, searchPaths ? { }, sha256 ? null, }:
let
  # Validate env
  env' = builtins.mapAttrs (k: v:
    (if (hasPrefix "__" k) || (hasPrefix "env" k) then
      v
    else
      abort ''

        Invalid argument: ${k}, must start with: env

      '')) (env // envFiles);

  # Validate that help is a Markdown file
  help' = if (help == null) then
    help
  else if (hasSuffix ".md" help) || (hasSuffix ".MD" help)
  || (hasSuffix ".Md" help) || (hasSuffix ".mD" help) then
    help
  else
    abort ''

      Invalid help file: ${toString help}, must be a markdown file

    '';

  searchPathsBase =
    __nixpkgs__.lib.strings.makeBinPath [ __nixpkgs__.coreutils ];

  searchPathsAction = __nixpkgs__.lib.strings.makeBinPath [
    __nixpkgs__.coreutils
    __nixpkgs__.less
    __nixpkgs__.glow
  ];
in builtins.derivation (env' // {
  __envShellCommands = __shellCommands__;
  __envShellOptions = __shellOptions__;
  __envSearchPathsBase = searchPathsBase;
  args = [
    (builtins.toFile "make-derivation" ''
      source $__envShellCommands
      source $__envShellOptions
      export PATH=$__envSearchPathsBase
      if test -v __envSearchPaths; then
        source $__envSearchPaths/template
      fi

      ${asContent builder}

      if test -v __envAction; then
        copy $__envAction $out/makes-action.sh
      fi

      if test -v __envHelp; then
        copy $__envHelp $out/README.md
      fi
    '')
  ];
  builder = "${__nixpkgs__.bash}/bin/bash";
  name = toDerivationName name;
  outputs = [ "out" ];
  passAsFile = builtins.attrNames envFiles;
  system = __system__;
} // attrsOptional (action != null) {
  __envAction = __nixpkgs__.writeShellScript "makes-action-for-${name}" ''
    source ${__shellOptions__}

    scriptName="$1"
    shift 1

    if test -f ''${BASH_SOURCE%/*}/README.md; then
      case "''${1:-}" in
        -h|--help)
          export LESSCHARSET=utf-8
          export PATH=${searchPathsAction}
          glow --pager --local ''${BASH_SOURCE%/*}/README.md
          exit 0
          ;;
        --)
          shift
          ;;
      esac
    fi

    set -- "$scriptName" "$@"

    ${action}
  '';
} // attrsOptional (help' != null) { __envHelp = help'; }
  // attrsOptional local {
    allowSubstitutes = false;
    preferLocalBuild = true;
  } // attrsOptional (searchPaths != { }) {
    __envSearchPaths = makeSearchPaths searchPaths;
  } // attrsOptional (sha256 != null) {
    outputHash = sha256;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  })
