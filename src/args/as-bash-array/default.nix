{ __nixpkgs__
, ...
}:
args:
builtins.toFile
  "as-bash-array"
  ''
    case "''${1}" in
      local) true ;;
      export) true ;;
      *) critical "First argument must be one of: local, export" ;;
    esac

    eval "''${@}"="( ${__nixpkgs__.lib.strings.escapeShellArgs args} )"
  ''
