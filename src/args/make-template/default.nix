{ __nixpkgs__
, builtinLambdas
, makeDerivation
, makeSearchPaths
, ...
}:

{ name
, replace ? { }
, replaceBase64 ? { }
, searchPaths ? { }
, template ? ""
}:
let
  # Validate arguments to replace
  argumentRegex = "__arg[A-Z][a-zA-Z]{2,}__";
  validateArguments = builtins.mapAttrs
    (k: v: (
      if builtins.match argumentRegex k == null
      then
        abort ''

          Ivalid placeholder: ${k}
          Placeholders must match: ${argumentRegex}
          For example: __argExample__

        ''
      else v
    ));

  replace' = validateArguments replace;
  replaceBase64' = validateArguments replaceBase64;
in
makeDerivation {
  env = replace' // replaceBase64' // {
    __envArgumentsRegex = argumentRegex;
    __envArgumentNamesFile = builtinLambdas.listToFileWithTrailinNewLine
      (builtins.attrNames replace);
    __envArgumentBase64NamesFile = builtinLambdas.listToFileWithTrailinNewLine
      (builtins.attrNames replaceBase64);
    __envPath = __nixpkgs__.lib.strings.makeBinPath [
      __nixpkgs__.gnugrep
      __nixpkgs__.rpl
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
  name = "make-template-for-${name}";
}
