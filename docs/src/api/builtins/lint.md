Linters ensure source code follows
best practices.

## lintBash

Lints Bash code with [ShellCheck](https://github.com/koalaman/shellcheck).

Types:

- lintBash:
    - enable (`boolean`): Optional.
        Defaults to `false`.
    - targets (`listOf str`): Optional.
        Files or directories (relative to the project) to lint.
        Defaults to the entire project.

Example:

=== "makes.nix"

    ```nix
    {
      lintBash = {
        enable = true;
        targets = [
          "/" # Entire project
          "/file.sh" # A file
          "/directory" # A directory within the project
        ];
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /lintBash
    ```

## lintGitCommitMsg

It creates a commit diff
between you current branch
and the main branch of the repository.
All commits included in the diff
are linted using [Commitlint](https://commitlint.js.org/#/).

Types:

- lintGitCommitMsg:
    - enable (`boolean`): Optional.
        Defaults to `false`.
    - branch (`str`): Optional.
        Name of the main branch.
        Defaults to `main`.
    - config (`str`): Optional.
        Path to a configuration file for Commitlint.
        Defaults to
        [config.js](/src/evaluator/modules/lint-git-commit-msg/config.js).
    - parser (`str`): Optional.
        Commitlint parser definitions.
        Defaults to
        [parser.js](/src/evaluator/modules/lint-git-commit-msg/parser.js).

Example:

=== "makes.nix"

    ```nix
    {
      lintGitCommitMsg = {
        enable = true;
        branch = "my-branch-name";
        # If you want to use custom configs or parsers you can do it like this:
        # config = "/src/config/config.js";
        # parser = "/src/config/parser.js";
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /lintGitCommitMsg
    ```

## lintGitMailMap

Lint the [Git mailmap](https://git-scm.com/docs/gitmailmap)
of the project with
[MailMap Linter](https://github.com/kamadorueda/mailmap-linter).

Types:

- lintGitMailmap:
    - enable (`boolean`): Optional.
        Defaults to `false`.
    - exclude (`str`): Optional.
        If the excludes aren't too many then use `exclude` instead
        of the exclude file (`.mailmap-exclude`).
        Defaults to `^$`.

Example:

=== "makes.nix"

    ```nix
    {
      lintGitMailMap = {
        enable = true;
        exclude = "^.* <.*noreply@github.com>$";
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /lintGitMailMap
    ```

## lintNix

Lints Nix code with [statix](https://github.com/nerdypepper/statix).

Types:

- lintNix:
    - enable (`boolean`): Optional.
        Defaults to `false`.
    - targets (`listOf str`): Optional.
        Files or directories (relative to the project) to lint.
        Defaults to the entire project.

Example:

=== "makes.nix"

    ```nix
    {
      lintNix = {
        enable = true;
        targets = [
          "/" # Entire project
          "/file.nix" # A file
          "/directory" # A directory within the project
        ];
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /lintNix
    ```

## lintTerraform

Lint Terraform code
with [TFLint](https://github.com/terraform-linters/tflint).

Types:

- lintTerraform:
    - config (`str`): Optional.
        Path to a TFLint configuration file.
        Defaults to [config.hcl](https://github.com/fluidattacks/makes/blob/23.06/src/evaluator/modules/lint-terraform/config.hcl).
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

Example:

=== "makes.nix"

    ```nix
    {
      lintTerraform = {
        # You can use a custom configuration like this:
        # config = "/src/config/tflint.hcl";
        modules = {
          module1 = {
            src = "/my/module1";
            version = "0.14";
          };
          module2 = {
            src = "/my/module2";
            version = "0.15";
          };
        };
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /lintTerraform/module1
    ```

## lintWithAjv

???+ warning

    This function is only available on Linux at the moment.

Lints JSON and YAML data files
with [JSON Schemas](https://json-schema.org/).
It uses [ajv-cli](https://github.com/ajv-validator/ajv-cli).

Types:

- lintWithAjv (`attrsOf schemaType`): Optional.
    Definitions of schema and associated data to lint.
    Defaults to `{ }`.
- schemaType (`submodule`):
    - schema (`str`): Required.
        Path to the JSON Schema.
    - targets (`listOf str`): Required.
        YAML or JSON
        data files to lint with `schema`.

Example:

=== "makes.nix"

    ```nix
    {
      lintWithAjv = {
        users = {
          schema = "/users/schema.json";
          targets = [
            "/users/data1.json"
            "/users/data.yaml"
          ];
        };
        colors = {
          schema = "/colors/schema.json";
          targets = [
            "/colors/data1.json"
            "/colors/data2.yaml"
          ];
        };
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /lintWithAjv/users
    ```
