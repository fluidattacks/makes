{ __nixpkgs__
, asContent
, toFileLst
, makeDerivation
, makeSearchPaths
, ...
}:

{ local ? true
, name
, help ? null
, replace ? { }
, replaceBase64 ? { }
, searchPaths ? { }
, template ? ""
}:
let
  # Validate arguments to replace
  argumentRegex = "__arg[A-Z][a-zA-Z0-9]{2,}__";
  validateArguments = builtins.mapAttrs
    (k: v: (
      if builtins.match argumentRegex k == null
      then
        abort ''

          Ivalid placeholder: ${k}
          Placeholders must match: ${argumentRegex}
          For example: __argExample123__

        ''
      else v
    ));

  replace' = validateArguments replace;
  replaceBase64' = validateArguments replaceBase64;
in
makeDerivation {
  action = ''
    cat "$1/template"
  '';
  env = replace' // replaceBase64' // {
    __envArgumentsRegex = argumentRegex;
    __envArgumentNamesFile = toFileLst "replace.lst"
      (builtins.attrNames replace);
    __envArgumentBase64NamesFile = toFileLst "replaceBase64.lst"
      (builtins.attrNames replaceBase64);
    __envPath = __nixpkgs__.lib.strings.makeBinPath [
      __nixpkgs__.gnugrep
      __nixpkgs__.rpl
    ];
    __envTemplate =
      if searchPaths == { }
      then asContent template
      else ''
        source "${makeSearchPaths searchPaths}/template"

        ${asContent template}
      '';
  };
  builder = ./builder.sh;
  inherit local help;
  name = "make-template-for-${name}";
}
