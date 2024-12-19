Managing secrets is critical for application security.

The following functions are secure
and allow you to re-use secrets
across different Makes components.

## secretsForAwsFromEnv

Load AWS secrets
from environment variables.

Types:

- secretsForAwsFromEnv (`attrsOf awsFromEnvType`): Optional.
    Defaults to `{ }`.
- awsFromEnvType (`submodule`):
    - accessKeyId (`str`): Optional.
        Name of the environment variable
        that stores the value of the AWS Access Key Id.
        Defaults to `"AWS_ACCESS_KEY_ID"`.
    - defaultRegion (`str`): Optional.
        Name of the environment variable
        that stores the value of the AWS Default Region.
        Defaults to `"AWS_DEFAULT_REGION"` (Which defaults to `"us-east-1"`).
    - secretAccessKey (`str`): Optional.
        Name of the environment variable
        that stores the value of the AWS Secret Access Key.
        Defaults to `"AWS_SECRET_ACCESS_KEY"`.
    - sessionToken (`str`): Optional.
        Name of the environment variable
        that stores the value of the AWS Session Token.
        Defaults to `"AWS_SESSION_TOKEN"` (Which defaults to `""`).

Always available outputs:

- `/secretsForAwsFromEnv/__default__`:
    - accessKeyId: "AWS_ACCESS_KEY_ID";
    - defaultRegion: "AWS_DEFAULT_REGION";
    - secretAccessKey: "AWS_SECRET_ACCESS_KEY";
    - sessionToken: "AWS_SESSION_TOKEN";

Example:

=== "makes.nix"

    ```nix
    {
      outputs,
      lintTerraform,
      secretsForAwsFromEnv,
      ...
    }: {
      secretsForAwsFromEnv = {
        makesDev = {
          accessKeyId = "ENV_VAR_FOR_MAKES_DEV_AWS_ACCESS_KEY_ID";
          secretAccessKey = "ENV_VAR_FOR_MAKES_DEV_AWS_SECRET_ACCESS_KEY";
        };
        makesProd = {
          accessKeyId = "ENV_VAR_FOR_MAKES_PROD_AWS_ACCESS_KEY_ID";
          secretAccessKey = "ENV_VAR_FOR_MAKES_PROD_AWS_SECRET_ACCESS_KEY";
        };
      };
      lintTerraform = {
        modules = {
          moduleDev = {
            setup = [
              outputs."/secretsForAwsFromEnv/makesDev"
            ];
            src = "/my/module1";
            version = "0.14";
          };
          moduleProd = {
            setup = [
              outputs."/secretsForAwsFromEnv/makesProd"
            ];
            src = "/my/module2";
            version = "0.14";
          };
        };
      };
    }
    ```

## secretsForAwsFromGitlab

Aquire an AWS session
using [GitLab CI OIDC](https://docs.gitlab.com/ee/ci/cloud_services/aws/index.html).

Types:

- secretsForAwsFromGitlab (`attrsOf awsFromGitlabType`): Optional.
    Defaults to `{ }`.
- awsFromGitlabType (`submodule`):
    - roleArn (`str`):
        ARN of AWS role to be assumed.
    - duration (`ints.positive`): Optional.
        Duration in seconds of the session.
        Defaults to `3600`.
    - retries (`ints.positive`): Optional.
        Number of login retries before failing.
        One retry per second.
        Defaults to `15`.

Example:

=== "makes.nix"

    ```nix
    {
      outputs,
      lintTerraform,
      secretsForAwsFromGitlab,
      ...
    }: {
      secretsForAwsFromGitlab = {
        makesDev = {
          roleArn = "arn:aws:iam::123456789012:role/dev";
          duration = 3600;
          retries = 30;
        };
        makesProd = {
          roleArn = "arn:aws:iam::123456789012:role/prod";
          duration = 7200;
          retries = 30;
        };
      };
      lintTerraform = {
        modules = {
          moduleDev = {
            setup = [
              outputs."/secretsForAwsFromGitlab/makesDev"
            ];
            src = "/my/module1";
            version = "0.14";
          };
          moduleProd = {
            setup = [
              outputs."/secretsForAwsFromGitlab/makesProd"
            ];
            src = "/my/module2";
            version = "0.14";
          };
        };
      };
    }
    ```

## secretsForEnvFromSops

Export secrets from a [Sops](https://github.com/mozilla/sops) encrypted manifest
to environment variables.

Types:

- secretsForEnvFromSops (`attrsOf secretForEnvFromSopsType`): Optional.
    Defaults to `{ }`.
- secretForEnvFromSopsType (`submodule`):
    - manifest (`str`):
        Relative path to the encrypted Sops file.
    - vars (`listOf str`):
        Names of the values to export out of the manifest.

Example:

=== "makes.nix"

    ```nix
    {
      outputs,
      ...
    }: {
      secretsForEnvFromSops = {
        cloudflare = {
          # Manifest contains inside:
          #   CLOUDFLARE_ACCOUNT_ID: ... ciphertext ...
          #   CLOUDFLARE_API_TOKEN: ... ciphertext ...
          manifest = "/infra/secrets/prod.yaml";
          vars = [ "CLOUDFLARE_ACCOUNT_ID" "CLOUDFLARE_API_TOKEN" ];
        };
      };
      lintTerraform = {
        modules = {
          moduleProd = {
            setup = [
              outputs."/secretsForEnvFromSops/cloudflare"
            ];
            src = "/my/module1";
            version = "0.14";
          };
        };
      };
    }
    ```

## secretsForTerraformFromEnv

Export secrets in a format suitable for Terraform
from the given environment variables.

Types:

- secretsForTerraformFromEnv (`attrsOf (attrsOf str)`): Optional.
    Mapping of secrets group name
    to a mapping of Terraform variable names
    to environment variable names.
    Defaults to `{ }`.

Example:

=== "makes.nix"

    ```nix
    {
      outputs,
      ...
    }: {
      secretsForTerraformFromEnv = {
        example = {
          # Equivalent in Bash to:
          #   export TF_VAR_cloudflareAccountId=$ENV_VAR_FOR_CLOUDFLARE_ACCOUNT_ID
          #   export TF_VAR_cloudflareApiToken=$ENV_VAR_FOR_CLOUDFLARE_API_TOKEN
          cloudflareAccountId = "ENV_VAR_FOR_CLOUDFLARE_ACCOUNT_ID";
          cloudflareApiToken = "ENV_VAR_FOR_CLOUDFLARE_API_TOKEN";
        };
      };
    }
    ```

=== "main.tf"

    ```tf
    variable "cloudflareAccountId" {}
    ```
