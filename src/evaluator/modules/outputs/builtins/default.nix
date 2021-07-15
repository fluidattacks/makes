args:
{
  imports = [
    (import ./__all__/default.nix args)
    (import ./deploy-container-image/default.nix args)
    (import ./format-bash/default.nix args)
    (import ./format-markdown/default.nix args)
    (import ./format-nix/default.nix args)
    (import ./format-python/default.nix args)
    (import ./format-terraform/default.nix args)
    (import ./hello-world/default.nix args)
    (import ./lint-bash/default.nix args)
    (import ./lint-commit-msg/default.nix args)
    (import ./lint-markdown/default.nix args)
    (import ./lint-nix/default.nix args)
    (import ./lint-python/default.nix args)
    (import ./lint-with-lizard/default.nix args)
  ];
}
