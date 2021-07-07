args:
{
  imports = [
    (import ./deploy-container-image args)
    (import ./format-bash args)
    (import ./format-nix args)
    (import ./format-python args)
    (import ./hello-world args)
    (import ./lint-bash args)
    (import ./lint-nix args)
  ];
}
