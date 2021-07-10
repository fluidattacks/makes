args:
{
  imports = [
    (import ./__all__ args)
    (import ./deploy-container-image args)
    (import ./format-bash args)
    (import ./format-nix args)
    (import ./format-python args)
    (import ./hello-world args)
    (import ./lint-bash args)
    (import ./lint-commit-msg args)
    (import ./lint-markdown args)
    (import ./lint-nix args)
    (import ./lint-python args)
  ];
}
