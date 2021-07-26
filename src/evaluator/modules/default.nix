args:
{
  imports = [
    (import ./cache.nix args)
    (import ./env-vars.nix args)
    (import ./env-vars-for-terraform.nix args)
    (import ./inputs.nix)
    (import ./outputs/default.nix args)
    (import ./pipelines/default.nix args)
    (import ./secrets-for-aws-from-env.nix args)
    (import ./secrets-for-env-from-sops.nix args)
    (import ./secrets-for-terraform-from-env.nix args)
  ];
}
