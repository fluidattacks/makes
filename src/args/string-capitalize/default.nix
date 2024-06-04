{ __nixpkgs__, ... }:
str:
let
  inherit (__nixpkgs__) lib;
  head = lib.strings.toUpper (builtins.substring 0 1 str);
  tail =
    builtins.concatStringsSep "" (builtins.tail (lib.stringToCharacters str));
in head + tail
