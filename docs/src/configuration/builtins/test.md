## testLicense

Test the license of a project using [reuse](https://reuse.software/).

Types:

- testLicense:
    - enable (`bool`): Optional.
        Defaults to `false`.

Example:

=== "makes.nix"

    ```nix
    {
      testLicense = {
        enable = true;
      };
    }
    ```

## testTerraform

Test Terraform code
by performing a `terraform plan`
over the specified Terraform modules.

Types:

- testTerraform:
    - modules (`attrsOf moduleType`): Optional.
        Path to Terraform modules to lint.
        Defaults to `{ }`.
- moduleType (`submodule`):
    - setup (`listOf package`): Optional.
        [Makes Environment](./environment.md)
        or [Makes Secrets](./secrets.md)
        to `source` (as in Bash's `source`)
        before anything else.
        Defaults to `[ ]`.
    - src (`str`):
        Path to the Terraform module.
    - version (`enum [ "0.14" "0.15" "1.0" ]`):
        Terraform version your module is built with.
    - debug (`bool`): Optional.
        Enable maximum level of debugging
        and remove parallelism so logs are clean.
        Defaults to `false`.

Example:

=== "makes.nix"

    ```nix
    {
      testTerraform = {
        modules = {
          module1 = {
            src = "/my/module1";
            version = "0.14";
          };
          module2 = {
            src = "/my/module2";
            version = "1.0";
          };
        };
      };
    }
    ```
