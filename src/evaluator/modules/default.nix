args:
{
  imports = [
    (import ./assertions.nix)
    (import ./cache.nix args)
    (import ./inputs.nix)
    (import ./outputs args)
    (import ./required-makes-version.nix args)
  ];
}
