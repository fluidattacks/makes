args:
{
  imports = [
    (import ./__all__/default.nix args)
    (import ./deploy-container-image/default.nix args)
    (import ./deploy-terraform/default.nix args)
    (import ./format-bash/default.nix args)
    (import ./format-markdown/default.nix args)
    (import ./format-nix/default.nix args)
    (import ./format-python/default.nix args)
    (import ./format-terraform/default.nix args)
    (import ./hello-world/default.nix args)
    (import ./lint-bash/default.nix args)
    (import ./lint-git-commit-msg/default.nix args)
    (import ./lint-git-mailmap/default.nix args)
    (import ./lint-markdown/default.nix args)
    (import ./lint-nix/default.nix args)
    (import ./lint-python/default.nix args)
    (import ./lint-terraform/default.nix args)
    (import ./lint-with-lizard/default.nix args)
    (import ./secure-python-with-bandit/default.nix args)
    (import ./test-terraform/default.nix args)
  ];
}
