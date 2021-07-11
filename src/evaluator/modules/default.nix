args:
{
  imports = [
    (import ./assertions.nix)
    (import ./inputs.nix)
    (import ./outputs args)
    (import ./required-makes-version.nix args)
  ];
}
