## envVars

???+ warning

    Do not propagate sensitive information here, it's not safe.
    Use [Makes Secrets][makes_secrets] instead.

Allows you to map environment variables from a name to a value.

Types:

- envVars (`attrsOf (attrsOf str)`): Optional.

    Defaults to `{ }`.

Example:

=== "makes.nix"

    ```nix
    {
      inputs,
      outputs,
      ...
    }: {
      envVars = {
        example = {
          # Equals to: export awsDefaultRegion=us-east-1
          awsDefaultRegion = "us-east-1";
        };
        otherExample = {
          # Equals to: export license=/nix/store/...-my-license
          license = outputs."/MyLicense";
          # Equals to: export bash=/nix/store/...-bash
          bash = inputs.nixpkgs.bash;
        };
      };
      inputs = {
        nixpkgs = fetchNixpkgs {
          rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
          sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
        };
      };
    }
    ```

## envVarsForTerraform

???+ warning

    Do not propagate sensitive information here, it's not safe.
    Use [Makes Secrets][makes_secrets] instead.

Allows you to map Terraform variables from a name to a value.

Types:

- envVarsForTerraform (`attrsOf (attrsOf str)`): Optional.

    Defaults to `{ }`.

Example:

=== "makes.nix"

    ```nix
    {
      inputs,
      outputs,
      ...
    }: {
      envVarsForTerraform = {
        example = {
          # Equals to: export TF_VAR_awsDefaultRegion=us-east-1
          awsDefaultRegion = "us-east-1";
        };
        otherExample = {
          # Equals to: export TF_VAR_license=/nix/store/...-my-license
          license = outputs."/MyLicense";
          # Equals to: export TF_VAR_bash=/nix/store/...-bash
          bash = inputs.nixpkgs.bash;
        };
      };
      inputs = {
        nixpkgs = fetchNixpkgs {
          rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
          sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
        };
      };
    }
    ```

=== "main.tf"

    ```tf
    variable "awsDefaultRegion" {}
    ```

[makes_secrets]: ./secrets.md
