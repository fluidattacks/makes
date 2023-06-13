## testLicense

Test the license of a project using [reuse](https://reuse.software/).

Types:

- testLicense: Empty attribute set.

Example:

=== "makes.nix"

    ```nix
    {
      testLicense = {};
    }
    ```

=== "Invocation"

    ```bash
    m . /testLicense
    ```

## testPullRequest

Test a pull request
on any of the [supported platforms](https://danger.systems/js/guides/getting_started.html#setting-up-danger-to-run-on-your-ci)
using [Danger.js](https://danger.systems/js/guides/getting_started.html).

For more information
on how to use Danger.js,
please refer to its
[Getting started guide](https://danger.systems/js/guides/getting_started.html).

Types:

- testPullRequest:
    - modules (`attrsOf moduleType`): Optional.
        Danger configurations to use.
        Defaults to `{ }`.
- moduleType (`submodule`):
    - dangerfile (`path`):
        Path to a Javascript or Typescript dangerfile.
    - extraArgs (`listOf str`):
        Extra arguments to pass
        to the danger executable.
    - setup (`listOf package`): Optional.
        [Makes Environment](./environment.md)
        or [Makes Secrets](./secrets.md)
        to `source` (as in Bash's `source`)
        before anything else.
        Defaults to `[ ]`.

Example:

=== "makes.nix"

    ```nix
    {
      projectPath,
      ...
    }:
    {
      testPullRequest = {
        modules = {
          github = {
            dangerfile = projectPath "/dangerfiles/github.ts";
            extraArgs = [
              # Extra arguments for my dangerfile
              "--config"
              "strict"
            ];
          };
          gitlab = {
            dangerfile = projectPath "/dangerfiles/gitlab.ts";
          };
        };
      };
    }
    ```

=== "dangerfiles/github.ts"

    ```typescript
    import { argv } from "node:process";

    import { danger, fail, warn } from "danger";

    const nCommits = danger.git.commits.length;
    const strict = argv[6] === "strict";

    if (nCommits > 1) {
      msg = `Only one commit per PR - Commits: ${nCommits}`
      if (strict) {
        fail(msg);
      }
      else {
        warn(msg);
      }
    }
    ```

=== "Invocation"

    ```bash
    $ m . /testPullRequest/github
    ```

## testPython

Test Python code
with [pytest](https://docs.pytest.org/).

Types:

- testPython (`attrsOf targetType`): Optional.
    Mapping of names to pytest targets.
    Defaults to `{ }`.
- targetType (`submodule`):
    - python (`enum ["3.8" "3.9" "3.10" "3.11"]`):
        Python interpreter version that your package/module is designed for.
    - src (`str`):
        Path to the file or directory that contains the tests code.
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.
    - extraFlags (`listOf str`): Optional.
        Extra command line arguments to propagate to pytest.
        Defaults to `[ ]`.
    - extraSrcs (`attrsOf package`): Optional.
        Place extra sources at the same level of your project code
        so you can reference them via relative paths.

    The final test structure looks like this:

    ```bash
    /tmp/some-random-unique-dir
    ├── __project__  # The entire source code of your project
    │   ├── ...
    │   └── path/to/src
    ... # repeat for all extraSrcs
    ├── "${extraSrcName}"
    │   └── "${extraSrcValue}"
    ...
    ```

    And we will run pytest like this:

    ```bash
    pytest /tmp/some-random-unique-dir/__project__/path/to/src
    ```

    Defaults to `{ }`.

Example:

=== "makes.nix"

    ```nix
    {
      testPython = {
        example = {
          python = "3.9";
          src = "/test/test-python";
        };
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /testPython/example
    ```

=== "Directory"

    ```bash
    $ tree test/test-python/

      test/test-python/
      └── test_something.py

    $ cat test/test-python/test_something.py

      1 def test_one_plus_one_equals_two() -> None:
      2     assert (1 + 1) == 2
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

=== "Invocation"

    ```bash
    $ m . /testTerraform/module1
    ```
