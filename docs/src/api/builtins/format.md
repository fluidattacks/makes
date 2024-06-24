Formatters help your code be consistent, beautiful and more maintainable.

## formatBash

Ensure that Bash code is formatted
according to [shfmt](https://github.com/mvdan/sh).

Types:

- formatBash:
    - enable (`boolean`): Optional.
        Defaults to false.
    - targets (`listOf str`): Optional.
        Files or directories (relative to the project) to format.
        Defaults to the entire project.

Example:

=== "makes.nix"

    ```nix
    {
      formatBash = {
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
    m . /formatBash
    ```

## formatMarkdown

???+ warning

    This function is only available on Linux at the moment.

Ensure that Markdown code is formatted
according to [doctoc](https://github.com/thlorenz/doctoc).

Types:

- formatMarkdown:
    - enable (`boolean`): Optional.
        Defaults to `false`.
    - doctocArgs (`listOf str`): Optional.
        Extra CLI flags to propagate to doctoc.
        Defaults to `[ ]`.
    - targets (`listOf str`):
        File  s (relative to the project) to format.

Example:

=== "makes.nix"

    ```nix
    {
      formatMarkdown = {
        enable = true;
        doctocArgs = [ "--title" "# Contents" ];
        targets = [ "/README.md" ];
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /formatMarkdown
    ```

## formatNix

Ensure that Nix code is formatted
according to [nixfmt](https://github.com/NixOS/nixfmt).

Types:

- formatNix:
    - enable (`boolean`): Optional.
        Defaults to `false`.
    - targets (`listOf str`): Optional.
        Files or directories (relative to the project) to format.
        Defaults to the entire project.

Example:

=== "makes.nix"

    ```nix
    {
      formatNix = {
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
    m . /formatNix
    ```

## formatPython

Ensure that Python code is formatted
according to [Black](https://github.com/psf/black)
and [isort](https://github.com/PyCQA/isort).

Types:

- formatPython (`attrsOf targetType`): Optional.
    Mapping of names to format targets.
    Defaults to `{ }`.
- targetType (`submodule`):
    - config (`atrrs`): Optional.
        - black (`path`): Optional.
            Path to the Black configuration file.
            Defaults to [./settings-black.toml](https://github.com/fluidattacks/makes/blob/main/src/evaluator/modules/format-python/settings-black.toml).
        - isort (`path`): Optional.
            Path to the isort configuration file.
            Defaults to [./settings-isort.toml](https://github.com/fluidattacks/makes/blob/main/src/evaluator/modules/format-python/settings-isort.toml).
    - targets (`listOf str`): Optional.
        Files or directories (relative to the project) to format.
        Defaults to the entire project.

Example:

=== "makes.nix"

    ```nix
    {
      formatPython = {
        my-config = {
          targets = ["/"];
          config = {};
        };
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /formatPython/my-config
    ```

## formatTerraform

Ensure that Terraform code is formatted
according to [Terraform FMT](https://www.terraform.io/docs/cli/commands/fmt.html).

Types:

- formatTerraform:
    - enable (`boolean`): Optional.
        Defaults to `false`.
    - targets (`listOf str`): Optional.
        Files or directories (relative to the project) to format.
        Defaults to the entire project.

Example:

=== "makes.nix"

    ```nix
    {
      formatTerraform = {
        enable = true;
        targets = [
          "/" # Entire project
          "/main.tf" # A file
          "/terraform/module" # A directory within the project
        ];
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /formatTerraform
    ```

## formatYaml

Ensure that YAML code
is formatted according to [yamlfix](https://github.com/lyz-code/yamlfix).

Types:

- formatYaml:
    - enable (`boolean`): Optional.
        Defaults to `false`.
    - targets (`listOf str`): Optional.
        Files or directories (relative to the project) to format.
        Defaults to the entire project.

Example:

=== "makes.nix"

    ```nix
    {
      formatYaml = {
        enable = true;
        targets = [
          "/" # Entire project
          "/main.yaml" # A file
          "/yamls/" # A directory within the project
        ];
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /formatYaml
    ```
