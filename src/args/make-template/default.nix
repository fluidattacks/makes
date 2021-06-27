{ __packages
, builtinLambdas
, builtinShellCommands
, builtinShellOptions
, makeDerivation
, makeSearchPaths
, path
, ...
}:

{ arguments ? { }
, argumentsBase64 ? { }
, name
, searchPaths ? { }
, template ? ""
}:
let
  # Validate arguments
  validateArguments = builtins.mapAttrs
    (k: v: (
      if __packages.nixpkgs.lib.strings.hasPrefix "env" k
      then v
      else abort "Ivalid argument: ${k}, arguments must start with `env`"
    ));

  arguments' = validateArguments arguments;
  argumentsBase64' = validateArguments argumentsBase64;
in
makeDerivation {
  arguments = arguments' // argumentsBase64' // {
    __envArgumentNamesFile = builtinLambdas.listToFileWithTrailinNewLine
      (builtins.attrNames arguments);
    __envArgumentBase64NamesFile = builtinLambdas.listToFileWithTrailinNewLine
      (builtins.attrNames argumentsBase64);
    __envPath = __packages.nixpkgs.lib.strings.makeBinPath [
      __packages.nixpkgs.gnugrep
      __packages.nixpkgs.gnused
    ];
    __envTemplate =
      if searchPaths == { }
      then builtinLambdas.asContent template
      else ''
        source "${makeSearchPaths searchPaths}"

        ${builtinLambdas.asContent template}
      '';
  };
  builder = ./builder.sh;
  local = true;
  inherit name;
}
