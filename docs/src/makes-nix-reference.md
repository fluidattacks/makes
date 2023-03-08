# Makes.nix reference

A Makes project is identified by a `makes.nix` file
in the top level directory.

A `makes.nix` file should be:

- An attribute set of configuration options:

  ```nix
  {
    configOption1 = {
      # ...
    };
    configOption2 = {
      # ...
    };
  }
  ```

- A function that receives one or more arguments
  and returns an attribute set of configuration options:

  ```nix
  { argA
  , argB
  , ...
  }:
  {
    configOption1 = {
      # ...
    };
    configOption2 = {
      # ...
    };
  }
  ```

Below we document all configuration options you can tweak in a `makes.nix`.

## Development

### dev

Create declarative development environments.

Can be used with [direnv](https://direnv.net/)
to make your shell automatically load
the development environment and its required dependencies.

Types:

- dev (`attrsOf (asIn makeSearchPaths)`): Optional.
  Mapping of environment name to searchPaths.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ inputs
, ...
}:
{
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };

  dev = {
    example = {
      # A development environment with `hello` package
      bin = [
        inputs.nixpkgs.hello
      ];
    };
  };
}
```

Example invocation: `$ m . /dev/example`

---

Example usage with direnv
on remote projects:

```bash
$ cat /path/to/some/dir/.envrc

    source "$(m github:fluidattacks/makes@main /dev/example)/template"

# Now every time you enter /path/to/some/dir
# the shell will automatically load the environment
$ cd /path/to/some/dir

    direnv: loading /path/to/some/dir/.envrc
    direnv: export ~PATH

/path/to/some/dir $ hello

    Hello, world!

# If you exit the directory, the development environment is unloaded
/path/to/some/dir $ cd ..

    direnv: unloading

/path/to/some $ hello

    hello: command not found
```

---

Example usage with direnv
on a local project:

```bash
$ cat /path/to/some/dir/.envrc

    cd /path/to/my/project
    source "$(m . /dev/example)/template"

# Now every time you enter /path/to/some/dir
# the shell will automatically load the environment
$ cd /path/to/some/dir

    direnv: loading /path/to/some/dir/.envrc
    direnv: export ~PATH

/path/to/some/dir $ hello

    Hello, world!

# If you exit the directory, the development environment is unloaded
/path/to/some/dir $ cd ..

    direnv: unloading

/path/to/some $ hello

    hello: command not found
```

## Format

Formatters help your code be consistent, beautiful and more maintainable.

### formatBash

Ensure that Bash code is formatted
according to [shfmt](https://github.com/mvdan/sh).

Types:

- formatBash:
  - enable (`boolean`): Optional.
    Defaults to false.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

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

Example invocation: `$ m . /formatBash`

### formatMarkdown

:warning: This function is only available on Linux at the moment.

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
    Files (relative to the project) to format.

Example `makes.nix`:

```nix
{
  formatMarkdown = {
    enable = true;
    doctocArgs = [ "--title" "# Contents" ];
    targets = [ "/README.md" ];
  };
}
```

Example invocation: `$ m . /formatMarkdown`

### formatNix

Ensure that Nix code is formatted
according to [Alejandra](https://github.com/kamadorueda/alejandra).

Types:

- formatNix:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

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

Example invocation: `$ m . /formatNix`

### formatPython

Ensure that Python code is formatted
according to [Black](https://github.com/psf/black)
and [isort](https://github.com/PyCQA/isort).

Types:

- formatPython:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

```nix
{
  formatPython = {
    enable = true;
    targets = [
      "/" # Entire project
      "/file.py" # A file
      "/directory" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /formatPython`

### formatTerraform

Ensure that Terraform code is formatted
according to [Terraform FMT](https://www.terraform.io/docs/cli/commands/fmt.html).

Types:

- formatTerraform:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

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

Example invocation: `$ m . /formatTerraform`

### formatYaml

Ensure that YAML code
is formatted according to [yamlfix](https://github.com/lyz-code/yamlfix).

Types:

- formatYaml:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

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

Example invocation: `$ m . /formatYaml`

## Lint

Linters ensure source code follows
best practices.

### lintBash

Lints Bash code with [ShellCheck](https://github.com/koalaman/shellcheck).

Types:

- lintBash:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to lint.
    Defaults to the entire project.

Example `makes.nix`:

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

Example invocation: `$ m . /lintBash`

### lintClojure

Lints clojure code with [clj-kondo](https://github.com/clj-kondo/clj-kondo).

Types:

- lintClojure (`attrsOf (listOf str)`): Optional.
  Mapping of custom names to lists of paths (relative to the project) to lint.
  Defaults to `{ }`.

Example `makes.nix`:

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

Example invocation: `$ m . /lintClojure/example1`

Example invocation: `$ m . /lintClojure/example2`

### lintGitCommitMsg

:warning: This function is only available on Linux at the moment.

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

Example `makes.nix`:

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

Example invocation: `$ m . /lintGitCommitMsg`

### lintGitMailMap

Lint the [Git mailmap](https://git-scm.com/docs/gitmailmap)
of the project with
[MailMap Linter](https://github.com/kamadorueda/mailmap-linter).

Types:

- lintGitMailmap:
  - enable (`boolean`): Optional.
    Defaults to `false`.

Example `makes.nix`:

```nix
{
  lintGitMailMap = {
    enable = true;
  };
}
```

Example invocation: `$ m . /lintGitMailMap`

### lintMarkdown

Lints Markdown code with [Markdown lint tool](https://github.com/markdownlint/markdownlint).

Types:

- lintMarkdown (`attrsOf moduleType`): Optional.
  Definitions of config and associated paths to lint.
  Defaults to `{ }`.
- moduleType (`submodule`):
  - config (`str`): Optional.
    Path to the config file.
    Defaults to [config.rb](/src/evaluator/modules/lint-markdown/config.rb).
  - targets (`listOf str`): Required.
    paths to lint with `config`.

Example `makes.nix`:

```nix
{
  lintMarkdown = {
    all = {
      # You can pass custom configs like this:
      # config = "/src/config/markdown.rb";
      targets = [ "/" ];
    };
    others = {
      targets = [ "/others" ];
    };
  };
}
```

Example invocation: `$ m . /lintMarkdown/all`

Example invocation: `$ m . /lintMarkdown/others`

### lintNix

Lints Nix code with [nix-linter](https://github.com/Synthetica9/nix-linter).

Types:

- lintNix:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to lint.
    Defaults to the entire project.

Example `makes.nix`:

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

Example invocation: `$ m . /lintNix`

### lintPython

Lints Python code with [mypy](https://mypy.readthedocs.io/en/stable/),
[Prospector](http://prospector.landscape.io/en/master/),
and (if configured) [import-linter](https://import-linter.readthedocs.io/en/stable/).

Types:

- lintPython:
  - dirsOfModules (`attrsOf dirOfModulesType`): Optional.
    Definitions of directories of python packages/modules to lint.
    Defaults to `{ }`.
  - imports (`attrsOf importsType`): Optional.
    Definitions of python packages whose imports will be linted.
    Defaults to `{ }`.
  - modules (`attrsOf moduleType`): Optional.
    Definitions of python packages/modules to lint.
    Defaults to `{ }`.
- dirOfModulesType (`submodule`):
  - python (`enum ["3.8" "3.9" "3.10" "3.11"]`):
    Python interpreter version that your package/module is designed for.
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
  - python (`enum ["3.8" "3.9" "3.10" "3.11"]`):
    Python interpreter version that your package/module is designed for.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.
  - src (`str`):
    Path to the package/module.

Example `makes.nix`:

```nix
{
  lintPython = {
    dirsOfModules = {
      makes = {
        python = "3.8";
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
        python = "3.8";
        src = "/src/cli/main";
      };
    };
  };
}
```

Example invocation: `$ m . /lintPython/dirOfModules/makes`

Example invocation: `$ m . /lintPython/dirOfModules/makes/main`

Example invocation: `$ m . /lintPython/module/cliMain`

### lintTerraform

Lint Terraform code
with [TFLint](https://github.com/terraform-linters/tflint).

Types:

- lintTerraform:
  - config (`str`): Optional.
    Path to a TFLint configuration file.
    Defaults to [config.hcl](/src/evaluator/modules/lint-terraform/config.hcl).
  - modules (`attrsOf moduleType`): Optional.
    Path to Terraform modules to lint.
    Defaults to `{ }`.
- moduleType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`str`):
    Path to the Terraform module.
  - version (`enum [ "0.14" "0.15" "1.0" ]`):
    Terraform version your module is built with.

Example `makes.nix`:

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

Example invocation: `$ m . /lintTerraform/module1`

Example invocation: `$ m . /lintTerraform/module2`

### lintWithAjv

:warning: This function is only available on Linux at the moment.

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

Example `makes.nix`:

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

Example invocation: `$ m . /lintWithAjv/users`

Example invocation: `$ m . /lintWithAjv/colors`

### lintWithLizard

Using [Lizard](https://github.com/terryyin/lizard) to check
Ciclomatic Complexity and functions length
in all supported languages

Types:

- lintWithLizard (`attrsOf (listOf str)`): Optional.
  Mapping of custom names to lists of paths (relative to the project) to lint.
  Defaults to `{ }`.

Example `makes.nix`:

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

Example invocation: `$ m . /lintWithLizard/example1`

Example invocation: `$ m . /lintWithLizard/example2`

## Test

### testPython

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

    `$ pytest /tmp/some-random-unique-dir/__project__/path/to/src`

    Defaults to `{ }`.

Example `makes.nix`:

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

```bash
$ tree test/test-python/

  test/test-python/
  └── test_something.py

$ cat test/test-python/test_something.py

  1 def test_one_plus_one_equals_two() -> None:
  2     assert (1 + 1) == 2
```

Example invocation: `$ m . /testPython/example`

### testTerraform

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
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
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

Example `makes.nix`:

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

Example invocation: `$ m . /testTerraform/module1`

Example invocation: `$ m . /testTerraform/module2`

## Security

### secureKubernetesWithRbacPolice

:warning: This function is only available on Linux at the moment.

Secure Kubernetes clusters
with [rbac-police](https://github.com/PaloAltoNetworks/rbac-police).

Types:

- secureKubernetesWithRbacPolice (`attrsOf kubernetesWithRbacPolice`): Optional.
  Defaults to `{ }`.
- kubernetesWithRbacPolice (`submodule`):

  - severity (`str`):
    Only evaluate policies with severity >= threshold.
    Defaults to `Low`.

  - setup (`listOf package`):
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.

Example `makes.nix`:

```nix
{ outputs
, secretsForAwsFromGitlab
, secretsForKubernetesConfigFromAws
, secureKubernetesWithRbacPolice
, ...
}:
{
  secretsForAwsFromGitlab = {
    makesProd = {
      roleArn = "arn:aws:iam::123456789012:role/prod";
      duration = 7200;
      retries = 30;
    };
  };
  secretsForKubernetesConfigFromAws = {
    makes = {
      cluster = "makes-k8s";
      region = "us-east-1";
    };
  };
  secureKubernetesWithRbacPolice = {
    makes = {
      severity = "Low";
      setup = [
        outputs."/secretsForAwsFromGitlab/makesProd"
        outputs."/secretsForKubernetesConfigFromAws/makes"
      ];
    };
  };
}
```

Example invocation: `$ m . /secureKubernetesWithRbacPolice/makes`

### securePythonWithBandit

Secure Python code
with [Bandit](https://github.com/PyCQA/bandit).

Types:

- securePythonWithBandit (`attrsOf projectType`): Optional.
  Definitions of directories of python packages/modules to lint.
  Defaults to `{ }`.
- projectType (`submodule`):
  - python (`enum ["3.8" "3.9" "3.10" "3.11"]`):
    Python interpreter version that your package/module is designed for.
  - target (`str`):
    Relative path to the package/module.

Example `makes.nix`:

```nix
{
  securePythonWithBandit = {
    cli = {
      python = "3.8";
      target = "/src/cli";
    };
  };
}
```

Example invocation: `$ m . /securePythonWithBandit/cli`

## Deploy

### computeOnAwsBatch

Submit a job to an [AWS BATCH](https://aws.amazon.com/batch/) queue.

Types:

- computeOnAwsBatch (`attrsOf jobType`): Optional.
  Job groups to submit.
  Defaults to `{ }`.
- jobType (`submodule`):

  - allowDuplicates (`bool`): Optional.
    Set to `false` in order to prevent submitting the job
    if there is already a job in the queue with the same name.
    Defaults to `false`.
  - attempts (`ints.positive`): Optional.
    If the value of attempts is greater than one,
    the job is retried on failure the same number of attempts as the value.
    Defaults to `1`.
  - attemptDurationSeconds (`ints.positive`): Optional.
    The time duration in seconds
    (measured from the job attempt's startedAt timestamp)
    after which Batch terminates your jobs
    if they have not finished.
  - command (`listOf str`):
    The command to send to the container.
    It overrides the one specified
    in the Batch job definition.
    Additional arguments can be propagated when running this module output.
  - definition (`str`):
    Name of the Batch job definition
    that we will use as base for submitting the job.
    In general an Batch job definition is required
    in order to specify which container image
    our job is going to run on.

    The most basic Batch job definition
    to run a Makes job is (in Terraform syntax):

    ```tf
    resource "aws_batch_job_definition" "makes" {
      name = "makes"
      type = "container"
      container_properties = jsonencode({
        # This image cannot be parametrized later.
        #
        # If you need to run jobs on different container images,
        # simply  create many `aws_batch_job_definition`s
        image = "ghcr.io/fluidattacks/makes:23.04"

        # Below arguments can be parametrized later,
        # but they are required for the job definition to be created
        # so let's put some dummy values here
        memory  = 512
        vcpus   = 1
      })
    }
    ```

  - environment (`listOf str`): Optional.
    Name of the environment variables
    whose names and values should be copied from the machine running Makes
    to the machine on Batch running the job.
    Defaults to `[ ]`.
  - includePositionalArgsInName (`bool`): Optional.
    Enable to make positional arguments part of the job name.
    This is useful for identifying jobs
    in the Batch console
    more easily.
    Defaults to `true`.
  - memory (`ints.positive`):
    Amount of memory, in MiB that is reserved for the job.
  - parallel (`ints.positive`): Optional.
    Number of parallel jobs to trigger using
    [Batch Array Jobs](https://docs.aws.amazon.com/batch/latest/userguide/array_jobs.html).
  - propagateTags (`bool`): Optional.
    Enable tags to be propagated into the ECS tasks.
    Defaults to `true`.
  - queue (`nullOr str`):
    Name of the Batch queue we should submit the job to.
    It can be set to `null`,
    causing Makes to read
    the `MAKES_COMPUTE_ON_AWS_BATCH_QUEUE` environment variable at runtime.
  - setup (`listOf package`):
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - tags (`attrsOf str`): Optional.
    Tags to apply to the batch job.
    Defaults to `{ }`.
  - vcpus (`ints.positive`):
    Amount of virtual CPUs that is reserved for the job.

Example `makes.nix`:

```nix
{ outputs
, ...
}:
{
  computeOnAwsBatch = {
    helloWorld = {
      attempts = 1;
      attemptDurationSeconds = 43200;
      command = [ "m" "github:fluidattacks/makes@main" "/helloWorld" ];
      definition = "makes";
      environment = [ "ENV_VAR_FOR_WHATEVER" ];
      memory = 1800;
      queue = "ec2_spot";
      setup = [
        # Use default authentication for AWS
        outputs."/secretsForAwsFromEnv/__default__"
      ];
      tags = {
        "Management:Product" = "awesome_app";
      }
      vcpus = 1;
    };
  };
}
```

Example invocation: `$ m . /computeOnAwsBatch/helloWorld`

Example invocation: `$ m . /computeOnAwsBatch/helloWorld 1 2 3`

Note that positional arguments (`[ "1" "2" "3" ]` in this case)
will be appended to the end of `command`
before sending the job to Batch.

### deployContainerImage

Deploy a set of container images
in [OCI Format](https://github.com/opencontainers/image-spec)
to the specified container registries.

For details on how to build container images in OCI Format
please read the `makeContainerImage` reference.

Types:

- deployContainerImage:
  - images (`attrsOf imageType`): Optional.
    Definitions of container images to deploy.
    Defaults to `{ }`.
- imageType (`submodule`):
  - attempts (`ints.positive`): Optional.
    If the value of attempts is greater than one,
    the job is retried on failure the same number of attempts as the value.
    Defaults to `1`.
  - credentials:
    - token (`str`):
      Name of the environment variable
      that stores the value of the registry token.
    - user (`str`):
      Name of the environment variable
      that stores the value of the registry user.
  - registry (`str`):
    Registry in which the image will be copied to.
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`package`):
    Derivation that contains the container image in OCI Format.
  - tag (`str`):
    The tag under which the image will be stored in the registry.

Example `makes.nix`:

```nix
{ inputs
, outputs
, ...
}:
{
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };

  deployContainerImage = {
    images = {
      nginxDockerHub = {
        credentials = {
          token = "DOCKER_HUB_PASS";
          user = "DOCKER_HUB_USER";
        };
        src = inputs.nixpkgs.dockerTools.examples.nginx;
        registry = "docker.io";
        tag = "fluidattacks/nginx:latest";
      };
      redisGitHub = {
        credentials = {
          token = "GITHUB_TOKEN";
          user = "GITHUB_ACTOR";
        };
        src = inputs.nixpkgs.dockerTools.examples.redis;
        registry = "ghcr.io";
        tag = "fluidattacks/redis:$(date +%Y.%m)"; # Tag from command
      };
      makesGitLab = {
        credentials = {
          token = "CI_REGISTRY_PASSWORD";
          user = "CI_REGISTRY_USER";
        };
        src = outputs."/containerImage";
        registry = "registry.gitlab.com";
        tag = "fluidattacks/product/makes:$MY_VAR"; # Tag from env var
      };
    };
  };
```

Example invocation: `$ DOCKER_HUB_USER=user DOCKER_HUB_PASS=123 m . /deployContainerImage/nginxDockerHub`

Example invocation: `$ GITHUB_ACTOR=user GITHUB_TOKEN=123 m . /deployContainerImage/makesLatest`

Example invocation: `$ CI_REGISTRY_USER=user CI_REGISTRY_PASSWORD=123 m . /deployContainerImage/makesGitLab`

### deployTerraform

Deploy Terraform code
by performing a `terraform apply`
over the specified Terraform modules.

Types:

- deployTerraform:
  - modules (`attrsOf moduleType`): Optional.
    Path to Terraform modules to lint.
    Defaults to `{ }`.
- moduleType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`str`):
    Path to the Terraform module.
  - version (`enum [ "0.14" "0.15" "1.0" ]`):
    Terraform version your module is built with.

Example `makes.nix`:

```nix
{
  deployTerraform = {
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

Example invocation: `$ m . /deployTerraform/module1`

Example invocation: `$ m . /deployTerraform/module2`

### taintTerraform

Taint Terraform code
by performing a `terraform taint $resource`
over the specified Terraform modules.

Types:

- taintTerraform:
  - modules (`attrsOf moduleType`): Optional.
    Path to Terraform modules to lint.
    Defaults to `{ }`.
- moduleType (`submodule`):
  - reDeploy (`bool`): Optional.
    Perform a `terraform apply` after tainting resources.
    Defaults to `false`.
  - resources (`listOf str`):
    Resources to taint.
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`str`):
    Path to the Terraform module.
  - version (`enum [ "0.14" "0.15" "1.0" ]`):
    Terraform version your module is built with.

Example `makes.nix`:

```nix
{
  taintTerraform = {
    modules = {
      module = {
        resources = [ "null_resource.example" ];
        src = "/test/terraform/module";
        version = "0.14";
      };
    };
  };
}
```

Example invocation: `$ m . /taintTerraform/module`

### deployNomad

Deploy [Nomad](https://www.nomad.io/) code
by performing a `nomad plan`
over the specified Nomad jobs / namespaces.

Types:

- deployNomad:
  - jobs (`attrsOf jobsType`): Optional.
    Path to Nomad jobs to deploy.
    Defaults to `{ }`.
  - namespaces (`attrsOf namespacesType`): Optional.
    Path to Nomad namespaces to deploy.
    Defaults to `{ }`.
- jobsType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`path`):
    Path to the Nomad job (hcl or json).
  - version (`enum [ "1.0" "1.1" ]`):
    Nomad version your job is built with.
    Defaults to `"1.1"`.
  - namespace (`str`):
    Nomad namespace to deploy the job into.
- namespacesType (`submodule`):
  - setup (`listOf package`): Optional.
    Makes Environment
    or Makes Secrets
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - jobs (`attrOf path`):
    Attributes of path to the Nomad jobs (hcl or json).
  - version (`enum [ "1.0" "1.1" ]`):
    Nomad version your jobs are built with.
    Defaults to `"1.1"`.

Example `makes.nix`:

```nix
{
  deployNomad = {
    jobs = {
      job1 = {
        src = ./my/job1.hcl;
        namespace = "default";
      };
      job2 = {
        src = ./my/job2.json;
        namespace = "default";
      };
    };
    namespaces = {
      dev.jobs = {
        job1 = ./my/dev/job1.hcl;
        job2 = ./my/dev/job2.json;
      };
      staging.jobs = {
        job1 = ./my/staging/job1.hcl;
        job2 = ./my/staging/job2.json;
      };
    };
  };
}
```

Example invocation: `$ m . /deployNomad/default/job1`

Example invocation: `$ m . /deployNomad/staging/job2`

## Performance

### cache

Configure caches to read,
and optionally a [Cachix](https://cachix.org/) cache for reading and writting.

Types:

- cache:
  - extra: (attrsOf (cacheExtra))
  - readNixos (`bool`): Optional.
    Set to `true` in order to add https://cache.nixos.org as a read cache.
    Defaults to `true`.
- cacheExtra:
  - enable (`str`): Read from cache.
    is read on the server.
  - pubKey (`str`): Public key of the cache server.
  - token (`str`): The name of the environment variable that contains the
    token to push the cache.
  - type: (`enum [cachix]`): Binary cache type.
    Can be [Cachix](https://docs.cachix.org/).
  - url (`str`):
    URL of the cache.
  - write (`bool`): Enable pushing derivations to the cache. Requires `token`.

Required environment variables:

- `CACHIX_AUTH_TOKEN`: API token of the Cachix cache.
  - For Public caches:
    If not set the cache will be read, but not written to.
  - For private caches:
    If not set the cache won't be read, nor written to.

Example `makes.nix`:

```nix
{
  cache = {
    readNixos = true;
    extra = {
      main = {
        enable = true;
        pubKey = "makes.cachix.org-1:zO7UjWLTRR8Vfzkgsu1PESjmb6ymy1e4OE9YfMmCQR4=";
        token = "CACHIX_AUTH_TOKEN";
        type = "nixos";
        url = "https://makes.cachix.org?priority=2";
        write = true;
      };
    };
  };
}
```

## Environment

### envVars

:warning: Do not propagate sensitive information here, it's not safe.
Use [Makes Secrets][makes_secrets] instead.

Allows you to map environment variables from a name to a value.

Types:

- envVars (`attrsOf (attrsOf str)`): Optional.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ inputs
, outputs
, ...
}:
{
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

Example invocation: `$ m . /envVars/example`

Example invocation: `$ m . /envVars/otherExample`

### envVarsForTerraform

:warning: Do not propagate sensitive information here, it's not safe.
Use [Makes Secrets][makes_secrets] instead.

Allows you to map Terraform variables from a name to a value.

Types:

- envVarsForTerraform (`attrsOf (attrsOf str)`): Optional.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ inputs
, outputs
, ...
}:
{
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

Example `main.tf`:

```tf
variable "awsDefaultRegion" {}
```

Example invocation: `$ m . /envVarsForTerraform/example`

Example invocation: `$ m . /envVarsForTerraform/otherExample`

## Secrets

Managing secrets is critical for application security.

The following functions are secure
and allow you to re-use secrets
across different Makes components.

### secretsForAwsFromEnv

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

Example `makes.nix`:

```nix
{ outputs
, lintTerraform
, secretsForAwsFromEnv
, ...
}:
{
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

### secretsForAwsFromGitlab

Aquire an AWS session
using [Gitlab CI OIDC](https://docs.gitlab.com/ee/ci/cloud_services/aws/index.html).

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

Example `makes.nix`:

```nix
{ outputs
, lintTerraform
, secretsForAwsFromGitlab
, ...
}:
{
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

### secretsForEnvFromSops

Export secrets from a [Sops][sops] encrypted manifest
to environment variables.

Types:

- secretsForEnvFromSops (`attrsOf secretForEnvFromSopsType`): Optional.
  Defaults to `{ }`.
- secretForEnvFromSopsType (`submodule`):
  - manifest (`str`):
    Relative path to the encrypted Sops file.
  - vars (`listOf str`):
    Names of the values to export out of the manifest.

Example `makes.nix`:

```nix
{ outputs
, ...
}:
{
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

### secretsForGpgFromEnv

Load GPG public or private keys
from environment variables
into an ephemeral key-ring.

Each key content must be stored
in a environment variable
in [ASCII Armor](https://www.techopedia.com/definition/23150/ascii-armor) format.

Types:

- secretsForGpgFromEnv (`attrsOf (listOf str)`): Optional.
  Mapping of name
  to a list of environment variable names
  where the GPG key contents are stored.
  Defaults to `{ }`.

Example:

```nix
# /path/to/my/project/makes.nix
{ outputs
, ...
}:
{
  # Load keys into an ephemeral GPG keyring
  secretsForGpgFromEnv = {
    example = [
      "ENV_VAR_FOR_PRIVATE_KEY_CONTENT"
      "ENV_VAR_FOR_PUB_KEY_CONTENT"
    ];
  };
  # Use sops to decrypt an encrypted file
  secretsForEnvFromSops = {
    example = {
      manifest = "/secrets.yaml";
      vars = [ "password" ];
    };
  };
}
```

```nix
# /path/to/my/project/makes/example/main.nix
{ makeScript
, outputs
, ...
}:
makeScript {
  name = "example";
  searchPaths.source = [
    # First setup an ephemeral GPG keyring
    outputs."/secretsForGpgFromEnv/example"
    # Now sops will decrypt secrets using the GPG keys in the ring
    outputs."/secretsForEnvFromSops/example"
  ];
  entrypoint = ''
    echo Decrypted password: $password
  '';
}
```

```yaml
# /path/to/my/project/secrets.yaml
password: ENC[AES256_GCM,data:cLbgzNHgBN5drfsDAS+RTV5fL6I=,iv:2YHhHxKg+lbGqdB5nhhG2YemeKB6XWvthGfNNkVgytQ=,tag:cj/el3taq1w7UOp/JQSNwA==,type:str]
# ...
```

```bash
$ m . /example

  Decrypted password: 123
```

### secretsForKubernetesConfigFromAws

Create a Kubernetes
config file out of an AWS EKS cluster
and set it up in the
[KUBECONFIG Environment Variable](https://kubernetes.io/docs/concepts/configuration/).

Types:

- secretsForKubernetesConfigFromAws
  (`attrsOf secretForKubernetesConfigFromAwsType`): Optional.
  Defaults to `{ }`.
- secretForKubernetesConfigFromAwsType (`submodule`):
  - cluster (`str`):
    AWS EKS Cluster name.
  - region (`str`):
    AWS Region the EKS cluster is located in.

Example `makes.nix`:

```nix
{ outputs
, ...
}:
{
  secretsForKubernetesConfigFromAws = {
    myCluster = {
      cluster = "makes-k8s";
      region = "us-east-1";
    };
  };
  deployTerraform = {
    modules = {
      moduleProd = {
        setup = [
          outputs."/secretsForKubernetesConfigFromAws/myCluster"
        ];
        src = "/my/module1";
        version = "0.14";
      };
    };
  };
}
```

### secretsForTerraformFromEnv

Export secrets in a format suitable for Terraform
from the given environment variables.

Types:

- secretsForTerraformFromEnv (`attrsOf (attrsOf str)`): Optional.
  Mapping of secrets group name
  to a mapping of Terraform variable names
  to environment variable names.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ outputs
, ...
}:
{
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

Example `main.tf`:

```tf
variable "cloudflareAccountId" {}
```

## Utilities

Utilities provide an easy mechanism
for calling functions from makes
without having to specify them on any file.

### makeNodeJsLock

You can generate a `package-lock.json`
for [makeNodeJsEnvironment](#makenodejsenvironment)
like this:

```bash
m github:fluidattacks/makes@23.04 /utils/makeNodeJsLock \
  "${node_js_version}" \
  "${package_json}" \
  "${package_lock}"
```

- Supported `node_js_version`s are: `14`, `16` and `18`.
- `package_json` is the **absolute path** to the `package.json` file in your
  project.
- `package_lock` is the **absolute path**
  to the `package-lock.json` file in your project, this file can be an empty
  file.

### makePythonLock

You can generate a `sourcesYaml`
for [makePythonPypiEnvironment](#makepythonpypienvironment)
like this:

```bash
m github:fluidattacks/makes@23.04 /utils/makePythonLock \
  "${python_version}" \
  "${dependencies_yaml}" \
  "${sources_yaml}"
```

- Supported `python_version`s are: `3.8`, `3.9`, `3.10` and `3.11`.
- `dependencies_yaml` is the **absolute path** to a YAML file
  mapping [PyPI](https://pypi.org/) packages to version constraints.

Example:

```yaml
Django: "3.2.*"
psycopg2: "2.9.1"
```

- `sources_yaml` is the **absolute path**
  to a file were the script will output results.

### makeRubyLock

You can generate a `sourcesYaml`
for [makeRubyGemsEnvironment](#makerubygemsenvironment)
like this:

```bash
m github:fluidattacks/makes@23.04 /utils/makeRubyLock \
  "${ruby_version}" \
  "${dependencies_yaml}" \
  "${sources_yaml}"
```

- Supported `ruby_version`s are: `2.7`, `3.0` and `3.1`.
- `dependencies_yaml` is the **absolute path** to a YAML file
  mapping [RubyGems](https://rubygems.org/gems/slim) gems to version constraints.

Example:

```yaml
rubocop: "1.43.0"
slim: "~> 4.1"
```

- `sources_yaml` is the **absolute path**
  to a file were the script will output results.

### makeSopsEncryptedFile

You can generate an encrypted [Sops][sops] file like this:

```bash
m github:fluidattacks/makes@23.04 /utils/makeSopsEncryptedFile \
  "${kms_key_arn}" \
  "${output}"
```

- `kms_key_arn` is the arn of the key you will use for encrypting the file.
- `output` is the path for your resulting encrypted file.

### workspaceForTerraformFromEnv

Sets a [Terraform Workspace](https://developer.hashicorp.com/terraform/language/state/workspaces)
specified via environment variable.

Types:

- workspaceForTerraformFromEnv:
  - modules (`attrsOf moduleType`): Optional.
    Terraform modules to switch workspace.
    Defaults to `{ }`.
- moduleType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`str`):
    Path to the Terraform module.
  - variable (`str`): Optional.
    Name of the environment variable that contains
    the name of the workspace you want to use.
    Defaults to `""`.
    When `""` provided, workspace is `default`.
  - version (`enum [ "0.14" "0.15" "1.0" ]`):
    Terraform version your module is built with.

Example `makes.nix`:

```nix
{
  testTerraform = {
    modules = {
      module1 = {
        setup = [
          outputs."/workspaceForTerraformFromEnv/module1"
        ];
        src = "/my/module1";
        version = "0.14";
      };
    };
  };
  workspaceForTerraformFromEnv = {
    modules = {
      module1 = {
        src = "/my/module1";
        variable = "CI_COMMIT_REF_NAME";
        version = "0.14";
      };
    };
  };
}
```

## Framework Configuration

### extendingMakesDirs

Paths to magic directories where Makes extensions will be loaded from.

Types:

- extendingMakesDirs (`listOf str`): Optional.
  Defaults to `["/makes"]`.

### inputs

Explicitly declare the inputs and sources for your project.
Inputs can be anything.

Types:

- inputs (`attrOf anything`): Optional.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ fetchNixpkgs
, fetchUrl
, ...
}:
{
  inputs = {
    license = fetchUrl {
      rev = "https://raw.githubusercontent.com/fluidattacks/makes/1a595d8642ba98252cff7de3909fb879c54f8e59/LICENSE";
      sha256 = "11311l1apb1xvx2j033zlvbyb3gsqblyxq415qwdsd0db1hlwd52";
    };
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };
}
```

## Database

### dynamoDb

Create a local dynamo database

Types:

- dynamoDb (`attrsOf targetType`): Optional.
  Mapping of names to multiple databases.
  Defaults to `{ }`.
- targetType (`submodule`):
  - name (`str`),
  - host (`str`): Optional, defaults to `127.0.0.1`.
  - port (`str`): Optional, defaults to `8022`.
  - infra (`str`): Optional. Absolute path to the directory containing the
    terraform infraestructure.
  - daemonMode (`boolean`): Optional, defaults to `false`.
  - data (`listOf str`): Optional, defaults to []. Absolute paths with json documents,
    with the format defined for
    [BatchWriteItem](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html#API_BatchWriteItem_RequestSyntax).
  - dataDerivation (`listOf package`): Optional, defaults to `[]`.
    Derivations where the output ($ out), are json documents,
    with the format defined for
    [BatchWriteItem](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html#API_BatchWriteItem_RequestSyntax).
    This is useful if you want to perform transformations on your data.

Example `makes.nix`:

```nix
{ projectPath
, ...
}:
{
  dynamoDb = {
    usersdb = {
      host = "localhost";
      infra = projectPath "/test/database/infra";
      data = [
        projectPath "/test/database/data"
      ];
      daemonMode = true;
    };
  };
}
```

Example invocation: `$ m . /dyanmoDb/usersdb`

You can also overwrite the parameters with environment variables.

Example: `$ DAEMON=false m . /dyanmoDb/usersdb`

The following variables are available:

- HOST
- PORT
- DAEMON
- POPULATE

## Examples

### helloWorld

Small command for demo purposes, it greets the specified user:

Types:

- helloWorld:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - name (`string`):
    Name of the user we should greet.

Example `makes.nix`:

```nix
{
  helloWorld = {
    enable = true;
    name = "Jane Doe";
  };
}
```

Example invocation: `$ m . /helloWorld 1 2 3`

## Monitoring

### calculateScorecard

Calculate your remote repository [Scorecard](https://github.com/ossf/scorecard).
This module is only
available for [GitHub](https://github.com) projects at the moment.

Pre-requisites:

1. To run this module you need to set up a valid `GITHUB_AUTH_TOKEN` on your
   target repository. You can set this up in your CI or locally to run this
   check on your machine.

Types:

- checks (`listOf str`): Optional,
  defaults to all the checks available for Scorecard:

  ```nix
  [
    "Branch-Protection"
    "Fuzzing"
    "License"
    "SAST"
    "Binary-Artifacts"
    "Dependency-Update-Tool"
    "Pinned-Dependencies"
    "CI-Tests"
    "Code-Review"
    "Contributors"
    "Maintained"
    "Token-Permissions"
    "Security-Policy"
    "CII-Best-Practices"
    "Dangerous-Workflow"
    "Packaging"
    "Signed-Releases"
    "Vulnerabilities"
  ]
  ```

- format (`str`): Optional, defaults to JSON. This is the format which
  the scorecard will be printed. Accepted values are: `"default"` which is an
  `ASCII Table` and JSON.
- target (`str`): Mandatory, this is the repository url where you want to run
  scorecard.

Example usage:

```nix
{
  calculateScorecard = {
    checks = [ "SAST" ];
    enable = true;
    format = "json"
    target = "github.com/fluidattacks/makes";
  };
}
```

Example output:

```bash
  [INFO] Calculating Scorecard
  {
    "date": "2022-02-28",
    "repo": {
      "name": "github.com/fluidattacks/makes",
      "commit": "739dcdc0513c29de67406e543e1392ea194b3452"
    },
    "scorecard": {
      "version": "4.0.1",
      "commit": "c60b66bbc8b85286416d6ab9ae9324a095e66c94"
    },
    "score": 5,
    "checks": [
      {
        "details": [
          "Warn: 16 commits out of 30 are checked with a SAST tool",
          "Warn: CodeQL tool not detected"
        ],
        "score": 5,
        "reason": "SAST tool is not run on all commits -- score normalized to 5",
        "name": "SAST",
        "documentation": {
          "url": "https://github.com/ossf/scorecard/blob/c60b66bbc8b85286416d6ab9ae9324a095e66c94/docs/checks.md#sast",
          "short": "Determines if the project uses static code analysis."
        }
      }
    ],
    "metadata": null
  }
  [INFO] Aggregate score: 5
```

- [makes_environment]: #environment
- [makes_secrets]: #secrets
- [sops]: https://github.com/mozilla/sops
