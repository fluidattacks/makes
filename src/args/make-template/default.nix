{ __nixpkgs__, __nixpkgsSrc__, asContent, toFileLst, makeDerivation
, makeSearchPaths, ... }:
{ local ? true, name, help ? null, replace ? { }, replaceBase64 ? { }
, searchPaths ? { }, template ? "", withAction ? true, }:
let
  # Validate arguments to replace
  argumentRegex = "__arg[A-Z][a-zA-Z0-9]{2,}__";
  validateArguments = builtins.mapAttrs (k: v:
    (if builtins.match argumentRegex k == null then
      abort ''

        Invalid placeholder: ${k}
        Placeholders must match: ${argumentRegex}
        For example: __argExample123__

      ''
    else
      v));

  replace' = validateArguments replace;
  replaceBase64' = validateArguments replaceBase64;
in makeDerivation {
  action = if withAction then ''
    cat "$1/template" 1>&2
  '' else
    null;
  env = replace' // replaceBase64' // {
    __envArgumentsRegex = argumentRegex;
    __envArgumentNamesFile =
      toFileLst "replace.lst" (builtins.attrNames replace);
    __envArgumentBase64NamesFile =
      toFileLst "replaceBase64.lst" (builtins.attrNames replaceBase64);

    # Compatibility layer with Nixpkgs' stdenv
    __envNixpkgsBuildInputs = [
      __nixpkgs__.gnugrep
      __nixpkgs__.python3Packages.chardet
      __nixpkgs__.rpl
    ];
    __envNixpkgsInitialPath = [ __nixpkgs__.coreutils ];
    __envNixpkgsSrc = __nixpkgsSrc__;

    __envTemplate = if searchPaths == { } then
      asContent template
    else ''
      source "${makeSearchPaths searchPaths}/template"

      ${asContent template}
    '';
  };
  builder = ./builder.sh;
  inherit local help;
  name = "make-template-for-${name}";
}
