{ makeDerivation, ... }:
name: expr:
makeDerivation {
  envFiles.envAll = builtins.toJSON expr;
  builder = "cp $envAllPath $out";
  local = true;
  inherit name;
}
