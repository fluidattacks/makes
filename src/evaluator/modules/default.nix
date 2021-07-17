args:
{
  imports = [
    (import ./assertions.nix)
    (import ./cache.nix args)
    (import ./inputs.nix)
    (import ./outputs/default.nix args)
    (import ./required-makes-version.nix args)
    (import ./secrets.nix args)
  ];
}
