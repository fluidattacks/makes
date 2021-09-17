{ lib
, projectSrc
, ...
}:
let
  flakeInputs =
    if (builtins.pathExists (projectSrc + "/flake.lock"))
    then import ./flake.lock.nix projectSrc
    else { };
in
{
  options = {
    inputs = lib.mkOption {
      default = { };
      type = lib.types.attrs;
    };
  };
  config.inputs = flakeInputs;
}
