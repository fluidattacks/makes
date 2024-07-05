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

## lintClojure

Lints clojure code with [clj-kondo](https://github.com/clj-kondo/clj-kondo).

Types:

- lintClojure (`attrsOf (listOf str)`): Optional.
    Mapping of custom names to lists of paths (relative to the project) to lint.

    Defaults to `{ }`.

Example:

=== "makes.nix"

    ```nix
    {
      lintClojure = {
        example1 = [
          "/" # Entire project
          "/file.clj" # A file
        ];
        example2 = [
          "/directory" # A directory within the project
        ];
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /lintClojure/example1`
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

## lintMarkdown

Lints Markdown code with [Markdown lint tool](https://github.com/markdownlint/markdownlint).

Types:

- lintMarkdown (`attrsOf moduleType`): Optional.
    Definitions of config and associated paths to lint.
    Defaults to `{ }`.
- moduleType (`submodule`):
    - config (`str`): Optional.
        Path to the config file.
        Defaults to [config.rb](https://github.com/fluidattacks/makes/blob/main/src/evaluator/modules/lint-markdown/config.rb).
    - targets (`listOf str`): Required.
        paths to lint with `config`.
    - rulesets (`str`): Optional.
        Path to the custom rulesets file.
        Defaults to [rulesets.rb](https://github.com/fluidattacks/makes/blob/main/src/evaluator/modules/lint-markdown/rulesets.rb).

Example:

=== "makes.nix"

    ```nix
    {
      lintMarkdown = {
        all = {
          # You can pass custom configs like this:
          # config = "/src/config/markdown.rb";
          # You can pass custom rules like this:
          # rulesets = "/src/config/rulesets.rb";
          targets = [ "/" ];
        };
        others = {
          targets = [ "/others" ];
        };
      };
    }
    ```

=== "Invocation"

    ```bash
      m . /lintMarkdown/all
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

## lintPython

Lints Python code with [mypy](https://mypy.readthedocs.io/en/stable/),
[Prospector](http://prospector.landscape.io/en/master/),
and (if configured) [import-linter](https://import-linter.readthedocs.io/en/stable/).

Types:

- lintPython:
    - dirOfModules (`attrsOf dirOfModulesType`): Optional.
        Definitions of directories of python packages/modules to lint.
        Defaults to `{ }`.
    - imports (`attrsOf importsType`): Optional.
        Definitions of python packages whose imports will be linted.
        Defaults to `{ }`.
    - modules (`attrsOf moduleType`): Optional.
        Definitions of python packages/modules to lint.
        Defaults to `{ }`.
- dirOfModulesType (`submodule`):
    - config (`atrrs`): Optional.
        - mypy (`path`): Optional.
            Path to the Mypy configuration file.
            Defaults to [./settings-mypy.cfg](https://github.com/fluidattacks/makes/blob/main/src/evaluator/modules/lint-python/settings-mypy.cfg).
        - prospector (`path`): Optional.
            Path to the Prospector configuration file.
            Defaults to [./settings-prospector.yaml](https://github.com/fluidattacks/makes/blob/main/src/evaluator/modules/lint-python/settings-prospector.yaml).
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.
    - src (`str`):
        Path to the directory that contains inside many packages/modules.
- importsType (`submodule`):
    - config (`str`):
        Path to the import-linter configuration file.
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.
    - src (`str`):
        Path to the package/module.
- moduleType (`submodule`):
    - config (`atrrs`): Optional.
        - mypy (`path`): Optional.
            Path to the Mypy configuration file.
            Defaults to [./settings-mypy.cfg](https://github.com/fluidattacks/makes/blob/main/src/evaluator/modules/lint-python/settings-mypy.cfg).
        - prospector (`path`): Optional.
            Path to the Prospector configuration file.
            Defaults to [./settings-prospector.yaml](https://github.com/fluidattacks/makes/blob/main/src/evaluator/modules/lint-python/settings-prospector.yaml).
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.
    - src (`str`):
        Path to the package/module.

Example:

=== "makes.nix"

    ```nix
    {
      lintPython = {
        dirOfModules = {
          makes = {
            config = {};
            src = "/src/cli";
          };
        };
        imports = {
          cli = {
            config = "/src/cli/imports.cfg";
            src = "/src/cli";
          };
        };
        modules = {
          cliMain = {
            config = {};
            src = "/src/cli/main";
          };
        };
      };
    }
    ```

=== "Invocation dirOfModules"

    ```bash
    m . /lintPython/dirOfModules/makes/main
    ```

=== "Invocation module"

    ```bash
    m . /lintPython/module/cliMain
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

## lintWithLizard

Using [Lizard](https://github.com/terryyin/lizard) to check
Ciclomatic Complexity and functions length
in all supported languages

Types:

- lintWithLizard (`attrsOf (listOf str)`): Optional.
    Mapping of custom names to lists of paths (relative to the project) to lint.

    Defaults to `{ }`.

Example:

=== "makes.nix"

    ```nix
    {
      lintWithLizard = {
        example1 = [
          "/" # Entire project
          "/file.py" # A file
        ];
        example2 = [
          "/directory" # A directory within the project
        ];
      };
    }
    ```

=== "Invocation"

    ```bash
    $ m . /lintWithLizard/example1
    ```
