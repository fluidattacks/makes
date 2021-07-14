args:
{
  imports = [
    (import ./assertions.nix)
    (import ./caches.nix args)
    (import ./inputs.nix)
    (import ./outputs args)
    (import ./required-makes-version.nix args)
  ];
}
