# Makes v21.08

A DevSecOps framework
powered by [Nix][NIX].

Our primary goal is to help you setup
a powerful [CI/CD][CI_CD] system
in just a few steps, in any technology.

## At a glance

This is how creating a [CI/CD][CI_CD] pipeline
for deploying infrastructure with [Terraform][TERRAFORM]
and [Makes][MAKES] looks like:

```nix
# /path/to/my/project/makes.nix
{ outputs
, ...
}:
{
  # Authenticate securely 🛡 through environment variables
  secretsForTerraformFromEnv = {
    myAwesomeMicroService = {
      githubToken = "GITHUB_API_TOKEN";
      salesforceApiToken = "SALESFORCE_API_TOKEN";
    };
  };

  # Authenticate securely 🛡 to AWS with environment variables
  secretsForAwsFromEnv = {
    myAwesomeMicroService = {
      accessKeyId = "MY_APP_AWS_ACCESS_KEY_ID";
      secretAccessKey = "MY_APP_AWS_SECRET_ACCESS_KEY";
    };
  };

  # Deploy to production 🚀 !!
  deployTerraform = {
    modules = {
      myAwesomeMicroService = {
        setup = [
          outputs."/secretsForTerraformFromEnv/myAwesomeMicroService"
          outputs."/secretsForAwsFromEnv/myAwesomeMicroService"
        ];
        src = "/infra/microServices/myAwesomeMicroService";
        version = "0.13";
      };
    };
  };
}
```

Easy, isn't it?

Now 🔥 it up with: ` $ m . /deployTerraform/myAwesomeMicroService`

[![asciicast](https://asciinema.org/a/426280.svg)](https://asciinema.org/a/426280)

## Production ready

Yes, [Makes][MAKES] is production ready.

Real life projects that run entirely on [Makes][MAKES]:

- [Fluid Attacks][FLUID_ATTACKS] monorepo:
  https://gitlab.com/fluidattacks/product

## On GitHub Actions

![Makes on GitHub Actions!](
  /static/makes_on_github_actions.png "Makes on GitHub Actions")

## On GitLab

![Makes on GitLab!](/static/makes_on_gitlab.png "Makes on GitLab")

## CLI Showcase

[![Makes Demo](https://asciinema.org/a/425886.svg)](https://asciinema.org/a/425886)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Contents

- [Why](#why)
- [Goal](#goal)
- [Getting started](#getting-started)
    - [Getting started as user](#getting-started-as-user)
    - [Getting started as developer](#getting-started-as-developer)
    - [Learning the language](#learning-the-language)
    - [Versioning scheme for the framework](#versioning-scheme-for-the-framework)
    - [Versioning scheme for the CLI](#versioning-scheme-for-the-cli)
    - [Compatibility information](#compatibility-information)
- [Configuring CI/CD](#configuring-cicd)
    - [Providers comparison](#providers-comparison)
        - [Configuring on GitHub Actions](#configuring-on-github-actions)
        - [Configuring on GitLab CI/CD](#configuring-on-gitlab-cicd)
        - [Configuring on Travis CI](#configuring-on-travis-ci)
    - [Configuring the cache](#configuring-the-cache)
- [Makes.nix reference](#makesnix-reference)
    - [Format](#format)
        - [formatBash](#formatbash)
        - [formatMarkdown](#formatmarkdown)
        - [formatNix](#formatnix)
        - [formatPython](#formatpython)
        - [formatTerraform](#formatterraform)
    - [Lint](#lint)
        - [lintBash](#lintbash)
        - [lintClojure](#lintclojure)
        - [lintGitCommitMsg](#lintgitcommitmsg)
        - [lintGitMailMap](#lintgitmailmap)
        - [lintMarkdown](#lintmarkdown)
        - [lintNix](#lintnix)
        - [lintPython](#lintpython)
        - [lintTerraform](#lintterraform)
        - [lintWithAjv](#lintwithajv)
        - [lintWithLizard](#lintwithlizard)
    - [Test](#test)
        - [testTerraform](#testterraform)
    - [Security](#security)
        - [securePythonWithBandit](#securepythonwithbandit)
    - [Deploy](#deploy)
        - [deployContainerImage](#deploycontainerimage)
        - [deployTerraform](#deployterraform)
    - [Performance](#performance)
        - [cache](#cache)
    - [Environment](#environment)
        - [envVars](#envvars)
        - [envVarsForTerraform](#envvarsforterraform)
    - [Secrets](#secrets)
        - [secretsForAwsFromEnv](#secretsforawsfromenv)
    - [Stability](#stability)
        - [inputs](#inputs)
    - [Examples](#examples)
        - [helloWorld](#helloworld)
- [Makes.lock.nix reference](#makeslocknix-reference)
- [Extending Makes](#extending-makes)
    - [Main.nix format](#mainnix-format)
        - [Derivations](#derivations)
    - [Main.nix reference](#mainnix-reference)
        - [makeSearchPaths](#makesearchpaths)
        - [makeDerivation](#makederivation)
        - [makeScript](#makescript)
        - [projectPath](#projectpath)
        - [asBashArray](#asbasharray)
        - [fromYaml](#fromyaml)
        - [toFileJsonFromFileYaml](#tofilejsonfromfileyaml)
- [Contact an expert](#contact-an-expert)
- [Contributing to Makes](#contributing-to-makes)
    - [Is easy](#is-easy)
    - [Code contributions](#code-contributions)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Why

Designing a fast, reliable, reproducible, easy-to-use
[CI/CD][CI_CD] system **is no easy task**.

While there are free and paid tools in the market like:
[Ansible][ANSIBLE],
[APT][APT],
[Apache Ant][APACHE_ANT],
[Apache Maven][APACHE_MAVEN],
[Buck][BUCK],
[Chef][CHEF],
[Docker][DOCKER],
[Gradle][GRADLE],
[Grunt][GRUNT],
[Gulp][GULP],
[Maven][APACHE_MAVEN],
[GNU Make][GNU_MAKE],
[Leiningen][LEININGEN],
[NPM][NPM],
[pip][PIP],
[Packer][PACKER],
[Rake][Rake],
[RPM][RPM],
[sbt][SBT],
[SCons][SCONS],
and
[yum][YUM]:

1. Real world production systems are composed of several programming languages.

    Tools normally focus only 1.

1. Real world production systems contain hundreds of thousands of dependencies:
    - Compilers
    - Shared-Object libraries (.so)
    - Runtime interpreters
    - Configuration files
    - Vendor artifacts
    - Accounts / Credentials / Secrets

    Tools normally cannot fetch, configure, or setup such dependencies
    in an easy, automated, secure way.
    They just build or install.

1. Real world production systems have tens to hundreds of developers.
    They work across the globe from different machines,
    stacks and operative systems.

    Tools normally cannot guarantee all of them
    an exactly equal, comfortable developing environment.

1. Real world production systems
    have tens to thousands of production servers
    that need to be deployed to.

    Tools normally  cover the: How to build? and not the: How to deploy?
    (or the other way around).

1. Real world production systems
    are made of several micro-components
    that one need to orchestrate correctly,
    or fix sunday morning, instead of sharing with family :parasol_on_ground:.

1. Real world production systems
    need to be **reliable** and **100% available**.

    But how with so much friction?

You can use [Nix][NIX] instead, which features:

1. A single build-tool for everything

1. Easy, powerful, modular and expressive dependency declaration.
    From compilers to vendor artifacts.

1. Guarantees each developer an **exact**,
    [reproducible][REPRODUCIBLE_BUILDS],
    comfortable environment in which to build and run stuff.
    Isolating as much as possible,
    reducing a lot of bugs along the way.
1. Defines a way for you to deploy software **perfectly**.

1. And therefore helps you build **reliable** and **100% available** systems.

So, if [Nix][NIX] is that powerful: Why [Makes][MAKES], then?

1. [Makes][MAKES] stands on the shoulders of [Nix][NIX].

1. [Makes][MAKES] is **specialized** on creating [CI/CD][CI_CD] systems
    that deliver **reliable** software to your end-users.

1. [Makes][MAKES] incorporates common workflows
    for formatting, linting, building, testing, managing infrastructure as code
    with [Terraform][TERRAFORM],
    deploying to [Kubernetes][KUBERNETES] clusters,
    creating development environments, etc.
    You can enable such workflows in a few clicks,
    with as little code as possible, in many providers.

1. [Makes][MAKES] hides unnecessary boilerplate and complexity
    so you can focus on what matters:
    **Adding value** to your **customers**, daily!

# Goal

- :star2: Simplicity: Easy setup with:
  a laptop, or
  [Docker][DOCKER], or
  [GitHub Actions][GITHUB_ACTIONS], or
  [GitLab CI][GITLAB_CI], or
  [Travis CI][TRAVIS_CI], or
  [Circle CI][CIRCLE_CI],
  and more!
- :beers: Sensible defaults: **Good for all** projects of any size, **out-of-the-box**.
- :dancers: Reproducibility: **Any member** of your team
  builds and get **exactly the same results**.
- :woman_technologist: Dev environments:
  **Any member** of your team
  with the required secrets
  **can execute the entire CI/CD pipeline**.
- :horse_racing: Performance:
  A highly granular **caching** system
  so you only have to **build things once**.
- :shipit: Extendibility: You can add custom workflows, easily.

# Getting started

Makes is powered by [Nix][NIX].
This means that Makes is able to run
on any of the [Nix's supported platforms][NIX_PLATFORMS].

We have **thoroughly** tested it in
[x86_64, AMD64 or Intel64][X86_64] Linux machines,
which are very easy to find on any cloud provider.

In order to use Makes you'll need to:

1. Install Nix as explained in the [NixOS Download page][NIX_DOWNLOAD].

1. Install Makes.

    Latest release:
    `$ nix-env -if https://fluidattacks.com/makes/install`

    [Other releases][MAKES_RELEASES]:
    `$ nix-env -if https://fluidattacks.com/makes/install/21.08`

    We will install two commands in your system:
    `m`, and `m-v21.08` (depending on the version you installed).

    Makes targets two kind of users:

    - Final users: People that want to use projects built with Makes.
    - Developers: People who develop projects with Makes.

## Getting started as user

1. List outputs of a [Makes] project:

    - For local [Makes][MAKES] projects, run:

      `$ m /path/to/local/repository`

      or if the project is in the current working directory, run:

      `$ m .`

    - For GitHub [Makes][MAKES] projects, run:

      `$ m github:owner/repo@rev`

    - For GitLab [Makes][MAKES] projects, run:

      `$ m gitlab:owner/repo@rev`

1. Build and run an output: `$ m github:fluidattacks/makes@main /helloWorld 1 2 3`

    ```
    [INFO] Hello from Makes! Jane Doe.
    [INFO] You called us with CLI arguments: [ 1 2 3 ].
    ```

## Getting started as developer

1. Locate in the root of your project:

    `$ cd /path/to/my/project`

1. Create a configuration file named `makes.nix`
    with the following contents:

    ```nix
    # /path/to/my/project/makes.nix
    {
      helloWorld = {
        enable = true;
        name = "Jane Doe";
      };
    }
    ```

    We have tens of [CI/CD][CI_CD] actions
    that you can include in jour project as simple as this.

1. Now run makes!
    - List all available commands: `$ m .`

        ```
        Outputs list for project: /path/to/my/project
          /helloWorld
        ```

    - Build and run an output: `$ m . /helloWorld 1 2 3`

        ```
        [INFO] Hello from Makes! Jane Doe.
        [INFO] You called us with CLI arguments: [ 1 2 3 ].
        ```

## Learning the language

Most of [Makes][MAKES] syntax
is written in [Bash][BASH]
and the [Nix][NIX] expression language.
We highly recommend you the following resources:

- [Bash][BASH]:
    - [Shell Scripting Tutorial][BASH_TUTORIAL_SHELL_SCRIPTING]
- [Nix][NIX] Expression Language:
    - [Nix Pills][NIX_PILLS]

## Versioning scheme for the framework

We use [Git][GIT] commits for versioning the [Makes][MAKES] Framework.
If means you are in full control on how your project evolves over time.
Git commits are mathematically stable.

You can find the commits list [here][MAKES_COMMITS].

Please read the [Makes.lock.nix Reference][MAKES_LOCK_REF] for more information.

## Versioning scheme for the CLI

We use [calendar versioning][CALVER] for the Makes CLI (a.k.a. `$ m`),
like this: `year.month`.

You can assume that the current month release is stable,
for instance: `20.01` (at January 2021).
We won't add new features to it nor change it in backward-incompatible ways.

Development/unstable releases are tagged with the next month
[calendar version][CALVER], for instance `21.02` (at January 2021).
Please don't use unstable releases in production.

You can find the releases list [here][MAKES_RELEASES].

## Compatibility information

For the whole ecosystem to work
you need to use versions (of Makes CLI and Framework)
created in the same month.

# Configuring CI/CD

## Providers comparison

We've thoroughly tested these providers throughout the years,
below is a small table that clearly expresses their trade-offs.

| Provider                         | Easy   | Config | Scale  | SaaS   | Security |
|----------------------------------|--------|--------|--------|--------|----------|
| [GitHub Actions][GITHUB_ACTIONS] | :star: | :star: | :star: | :star: |          |
| [GitLab CI/CD][GITLAB_CI]        | :star: | :star: |        | :star: | :star:   |
| [Travis CI][TRAVIS_CI]           |        |        | :star: | :star: | :star:   |

If you are getting started in the world of [CI/CD][CI_CD]
it's a good idea to try [GitHub Actions][GITHUB_ACTIONS].

If you want **serious** security try [GitLab CI/CD][GITLAB_CI].

We didn't like [Travis CI][TRAVIS_CI]
because managing encrypted secrets is just ugly.
It also does not support running custom container images.

### Configuring on GitHub Actions

[GitHub Actions][GITHUB_ACTIONS]
is configured through [workflow files][GITHUB_WORKFLOWS]
located in a `.github/workflows` directory in the root of the project.

The smallest possible [workflow file][GITHUB_WORKFLOWS]
looks like this:

```yaml
# .github/workflows/dev.yml
name: Makes CI
on: [push, pull_request]
jobs:
  helloWorld:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      # We offer this GitHub action in the following versions:
      #   main: latest release (example: /makes:main)
      #   yy.mm: monthly release (example: /makes:21.08)
    - uses: docker://ghcr.io/fluidattacks/makes:main
      # You can use any name you like here
      name: helloWorld
      # You can pass secrets (if required) as environment variables like this:
      env:
        SECRET_NAME: ${{ secrets.SECRET_IN_YOUR_GITHUB }}
      with:
        args: m . /helloWorld 1 2 3

  # Add more jobs here, you can copy paste jobs.helloWorld and modify the `args`
```

### Configuring on GitLab CI/CD

[GitLab CI/CD][GITLAB_CI]
is configured through a [.gitlab-ci.yaml][GITLAB_CI_REF] file
located in the root of the project.

The smallest possible [.gitlab-ci.yaml][GITLAB_CI_REF]
looks like this:

```yaml
# /path/to/my/project/.gitlab-ci.yaml
/helloWorld:
  # We offer this Container Image in the following tags:
  #   main: latest release (example: /makes:main)
  #   yy.mm: monthly release (example: /makes:21.08)
  image: ghcr.io/fluidattacks/makes:main
  script:
    - m . /helloWorld 1 2 3

# Add more jobs here, you can copy paste /helloWorld and modify the `script`
```

Secrets can be propagated to Makes through [GitLab Variables][GITLAB_VARS],
which are passed automatically to the running container
as environment variables.

### Configuring on Travis CI

[Travis CI][TRAVIS_CI]
is configured through a [.travis.yml][TRAVIS_CI_REF] file
located in the root of the project.

The smallest possible [.travis.yml][TRAVIS_CI_REF]
looks like this:

```yaml
# /path/to/my/project/.travis.yml
os: linux
language: nix
nix: 2.3.12
# We offer this installation step in the following versions:
#   main: latest release (example: /install/main)
#   yy.mm: monthly release (example: /install/21.08)
install: nix-env -if https://fluidattacks.com/makes/install/21.08
env:
  global:
    # Encrypted environment variable
    secure: cipher-text-goes-here...
    # Publicly visible environment variable
    NAME: value
jobs:
  include:
  - script: m . /helloWorld 1 2 3
  # You can add more jobs like this:
  # - script: m . /formatBash
```

Secrets can be propagated to Makes through
[Travis Environment Variables][TRAVIS_ENV_VARS],
which are passed automatically to the running container
as environment variables.
We highly recommend you to use encrypted environment variables as
explained in the [Travis Environment Variables Reference][TRAVIS_ENV_VARS].

## Configuring the cache

If your CI/CD will run on different machines
then it's a good idea
to setup a distributed cache system with [Cachix][CACHIX].

In order to do this:

1. Create or sign-up to your [Cachix][CACHIX] account.
1. Create a new cache with:
    - Write access: `API token`.
    - Read access: `Public` or `Private`.
1. Configure `makes.nix` as explained in the following sections

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

## Format

Formatters help your code be consistent, beautiful and more maintainable.

### formatBash

Ensure that Bash code is formatted according to [shfmt][SHFMT].

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

Ensure that Markdown code is formatted according to [doctoc][DOCTOC].

Types:

- formatMarkdown:
    - enable (`boolean`): Optional.
      Defaults to false.
    - doctocArgs (`listOf str`): Optional.
      Extra CLI flags to propagate to [doctoc][DOCTOC].
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

Ensure that Nix code is formatted according to [nixpkgs-fmt][NIX_PKGS_FMT].

Types:

- formatNix:
    - enable (`boolean`): Optional.
      Defaults to false.
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

Ensure that Python code is formatted according to [Black][BLACK]
and [isort][ISORT].

Types:

- formatPython:
    - enable (`boolean`): Optional.
      Defaults to false.
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

Ensure that [Terraform][TERRAFORM] code
is formatted according to [Terraform FMT][TERRAFORM_FMT].

Types:

- formatTerraform:
    - enable (`boolean`): Optional.
      Defaults to false.
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

## Lint

Linters ensure source code follows
best practices.

### lintBash

Lints Bash code with [ShellCheck][SHELLCHECK].

Types:

- lintBash:
    - enable (`boolean`): Optional.
      Defaults to false.
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

Lints clojure code with [clj-kondo][CLJ-KONDO].

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

It creates a commit diff
between you current branch
and the main branch of the repository.
All commits included in the diff
are linted using [Commitlint][COMMITLINT].

Types:

- lintGitCommitMsg:
    - enable (`boolean`): Optional.
      Defaults to false.
    - branch (`str`): Optional.
      Name of the main branch.
      Defaults to `main`.
    - config (`path`): Optional.
      Configuration file for [Commitlint][COMMITLINT].
      Defaults to
      [config.js](./src/evaluator/modules/outputs/builtins/lint-git-commit-msg/config.js).
    - parser (`path`): Optional.
      [Commitlint][COMMITLINT] parser definitions.
      Defaults to
      [parser.js](./src/evaluator/modules/outputs/builtins/lint-git-commit-msg/parser.js).

Example `makes.nix`:

```nix
{
  lintGitCommitMsg = {
    enable = true;
    branch = "my-branch-name";
  };
}
```

Example invocation: `$ m . /lintGitCommitMsg`

### lintGitMailMap

Lint the [Git][GIT] [MailMap][GIT_MAILMAP] of the project
with [MailMap Linter][MAILMAP_LINTER].

Types:

- lintGitMailmap:
    - enable (`boolean`): Optional.
      Defaults to false.

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

Lints Markdown code with [Markdown lint tool][MARKDOWN_LINT].

Types:

- lintMarkdown (`attrsOf moduleType`): Optional.
  Definitions of config and associated paths to lint.
  Defaults to `{ }`.

Custom Types:

- moduleType (`submodule`):
    - config (`path`): Optional.
      Path to the config file.
      Defaults to
      `src/evaluator/modules/outputs/builtins/lint-markdown/config.rb`.
    - targets (`listOf str`): Required.
      paths to lint with `config`.

Example `makes.nix`:

```nix
{
  lintMarkdown = {
    all = {
      config = ./config/markdown.rb;
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

Lints Nix code with [nix-linter][NIX_LINTER].

Types:

- lintNix:
    - enable (`boolean`): Optional.
      Defaults to false.
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

Lints Python code with [mypy][MYPY] and [Prospector][PROSPECTOR].

Types:

- lintPython:
    - dirsOfModules (`attrsOf dirOfModulesType`): Optional.
      Definitions of directories of python packages/modules to lint.
      Defaults to `{ }`.
    - modules (`attrsOf moduleType`): Optional.
      Definitions of python packages/modules to lint.
      Defaults to `{ }`.
- dirOfModulesType (`submodule`):
    - extraSources (`listOf package`): Optional.
      List of scripts that will be sourced before performing the linting process.
      Can be used to setup dependencies of the project in the environment.
      Defaults to `[ ]`
    - python (`enum [ "3.7" "3.8" "3.9" ]`):
      Python interpreter version that your package/module is designed for.
    - src (`str`):
      Path to the directory that contains inside many packages/modules.
- moduleType (`submodule`):
    - extraSources (`listOf package`): Optional.
      List of scripts that will be sourced before performing the linting process.
      Can be used to setup dependencies of the project in the environment.
    - python (`enum [ "3.7" "3.8" "3.9" ]`):
      Python interpreter version that your package/module is designed for.
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

Lint [Terraform][TERRAFORM] code
with [TFLint][TFLINT].

Types:

- lintTerraform:
    - config (`lines`): Optional.
      Defaults to:

      ```hcl
      config {
        module = true
      }

      plugin "aws" {
        enabled = true
      }
      ```

    - modules (`attrsOf moduleType`): Optional.
      Path to [Terraform][TERRAFORM] modules to lint.
      Defaults to `{ }`.
- moduleType (`submodule`):
    - setup (`listOf package`): Optional.
      [Makes Environment][MAKES_ENVIRONMENT]
      or [Makes Secrets][MAKES_SECRETS]
      to `source` (as in Bash's `source`)
      before anything else.
      Defaults to `[ ]`.
    - src (`str`):
      Path to the [Terraform][TERRAFORM] module.
    - version (`enum [ "0.12" "0.13" "0.14" "0.15" "0.16" ]`):
      [Terraform][TERRAFORM] version your module is built with.

Example `makes.nix`:

```nix
{
  lintTerraform = {
    modules = {
      module1 = {
        src = "/my/module1";
        version = "0.12";
      };
      module2 = {
        src = "/my/module2";
        version = "0.16";
      };
    };
  };
}
```

Example invocation: `$ m . /lintTerraform/module1`

Example invocation: `$ m . /lintTerraform/module2`

### lintWithAjv

Lints [JSON][JSON] and [YAML][YAML] data files
with [JSON Schemas][JSON_SCHEMA].
It uses [ajv-cli][AJV_CLI].

Types:

- lintWithAjv (`attrsOf schemaType`): Optional.
  Definitions of schema and associated data to lint.
  Defaults to `{ }`.

Custom Types:

- schemaType (`submodule`):
    - schema (`str`): Required.
      Path to the [JSON Schema][JSON_SCHEMA].
    - targets (`listOf str`): Required.
      [YAML][YAML] or [JSON][JSON]
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

Using [Lizard][LIZARD] to check
Ciclomatic Complexity and functions length
in all supported languages by [Lizard][LIZARD]

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

### testTerraform

Test [Terraform][TERRAFORM] code
by performing a `terraform plan`
over the specified [Terraform][TERRAFORM] modules.

Types:

- testTerraform:
    - modules (`attrsOf moduleType`): Optional.
      Path to [Terraform][TERRAFORM] modules to lint.
      Defaults to `{ }`.
- moduleType (`submodule`):
    - setup (`listOf package`): Optional.
      [Makes Environment][MAKES_ENVIRONMENT]
      or [Makes Secrets][MAKES_SECRETS]
      to `source` (as in Bash's `source`)
      before anything else.
      Defaults to `[ ]`.
    - src (`str`):
      Path to the [Terraform][TERRAFORM] module.
    - version (`enum [ "0.12" "0.13" "0.14" "0.15" "0.16" ]`):
      [Terraform][TERRAFORM] version your module is built with.

Example `makes.nix`:

```nix
{
  testTerraform = {
    modules = {
      module1 = {
        src = "/my/module1";
        version = "0.12";
      };
      module2 = {
        src = "/my/module2";
        version = "0.16";
      };
    };
  };
}
```

Example invocation: `$ m . /testTerraform/module1`

Example invocation: `$ m . /testTerraform/module2`

## Security

### securePythonWithBandit

Secure Python code with [Bandit][BANDIT].

Types:

- securePythonWithBandit (`attrsOf projectType`): Optional.
  Definitions of directories of python packages/modules to lint.
  Defaults to `{ }`.

Custom Types:

- projectType (`submodule`):
    - python (`enum [ "3.7" "3.8" "3.9" ]`):
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

### deployContainerImage

Deploy a set of container images in [OCI Format][OCI_FORMAT_REPO]
to the specified container registries.

For details on how to build container images in [OCI Format][OCI_FORMAT_REPO]
please read the `makeContainerImage` reference.

Types:

- deployContainerImage:
    - images (`attrsOf imageType`): Optional.
      Definitions of container images to deploy.
      Defaults to `{ }`.

Custom Types:

- imageType (`submodule`):
    - registry (`enum ["docker.io" "ghcr.io" "registry.gitlab.com"]`):
      Registry in which the image will be copied to.
    - src (`package`):
      Derivation that contains the container image in [OCI Format][OCI_FORMAT_REPO].
    - tag (`str`):
      The tag under which the image will be stored in the registry.

Required environment variables:

- `CI_REGISTRY_USER` and `CI_REGISTRY_PASSWORD`, when deploying to GitLab.
- `DOCKER_HUB_USER` and `DOCKER_HUB_PASS`, when deploying to Docker Hub.
- `GITHUB_ACTOR` and `GITHUB_TOKEN`, when deploying to Github Container Registry.

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
        src = inputs.nixpkgs.dockerTools.examples.nginx;
        registry = "docker.io";
        tag = "fluidattacks/nginx:latest";
      };
      redisGitHub = {
        src = inputs.nixpkgs.dockerTools.examples.redis;
        registry = "ghcr.io";
        tag = "fluidattacks/redis:$(date +%Y.%m)"; # Tag from command
      };
      makesGitLab = {
        src = outputs."/containerImage";
        registry = "registry.gitlab.com";
        tag = "fluidattacks/product/makes:$MY_VAR"; # Tag from env var
      };
    };
  };
```

Example invocation: `$ DOCKER_HUB_USER=user DOCKER_HUB_PASS=123 m . /deployContainerImage/nginxDockerHub`

Example invocation: `$ GITHUB_ACTOR=user GITHUB_TOKEN=123 m . /deployContainerImage/makesGitHub`

Example invocation: `$ CI_REGISTRY_USER=user CI_REGISTRY_PASSWORD=123 m . /deployContainerImage/makesGitLab`

### deployTerraform

Deploy [Terraform][TERRAFORM] code
by performing a `terraform apply`
over the specified [Terraform][TERRAFORM] modules.

Types:

- deployTerraform:
    - modules (`attrsOf moduleType`): Optional.
      Path to [Terraform][TERRAFORM] modules to lint.
      Defaults to `{ }`.

Custom Types:

- moduleType (`submodule`):
    - setup (`listOf package`): Optional.
      [Makes Environment][MAKES_ENVIRONMENT]
      or [Makes Secrets][MAKES_SECRETS]
      to `source` (as in Bash's `source`)
      before anything else.
      Defaults to `[ ]`.
    - src (`str`):
      Path to the [Terraform][TERRAFORM] module.
    - version (`enum [ "0.12" "0.13" "0.14" "0.15" "0.16" ]`):
      [Terraform][TERRAFORM] version your module is built with.

Example `makes.nix`:

```nix
{
  deployTerraform = {
    modules = {
      module1 = {
        src = "/my/module1";
        version = "0.12";
      };
      module2 = {
        src = "/my/module2";
        version = "0.16";
      };
    };
  };
}
```

Example invocation: `$ m . /deployTerraform/module1`

Example invocation: `$ m . /deployTerraform/module2`

## Performance

### cache

Cache build results on a [Cachix][CACHIX] cache.

Types:

- cache:
    - enable (`boolean`): Optional.
      Defaults to false.
    - name (`str`):
      Name of the [Cachix][CACHIX] cache.
    - pubKey (`str`):
      Public key of the [Cachix][CACHIX] cache.

Required environment variables:

- `CACHIX_AUTH_TOKEN`: API token of the [Cachix][CACHIX] cache.
    - For Public caches:
      If not set the cache will be read, but not written to.
    - For private caches:
      If not set the cache won't be read, nor written to.

Example `makes.nix`:

```nix
{
  cache = {
    enable = true;
    name = "fluidattacks";
    pubKey = "fluidattacks.cachix.org-1:upiUCP8kWnr7NxVSJtTOM+SBqL0pZhZnUoqPG04sBv0=";
  };
}
```

## Environment

### envVars

:warning: Do not propagate sensitive information here, it's not safe.
Use [Makes Secrets][MAKES_SECRETS] instead.

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
Use [Makes Secrets][MAKES_SECRETS] instead.

Allows you to map [Terraform][TERRAFORM] variables from a name to a value.

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
across different [Makes][MAKES] components.

### secretsForAwsFromEnv

Load [Amazon Web Services (AWS)][AWS] secrets
from [Environment Variables][ENV_VAR].

Types:

- secretsForAwsFromEnv (`attrsOf awsFromEnvType`): Optional.
  Defaults to `{ }`.

Custom Types:

- awsFromEnvType (`submodule`):

    - accessKeyId (`str`): Optional.
      Name of the [environment variable][ENV_VAR]
      that stores the value of the [AWS][AWS] Access Key Id.
      Defaults to `"AWS_ACCESS_KEY_ID"`.

    - defaultRegion (`str`): Optional.
      Name of the [environment variable][ENV_VAR]
      that stores the value of the [AWS][AWS] Default Region.
      Defaults to `"AWS_DEFAULT_REGION"` (Which defaults to `"us-east-1"`).

    - secretAccessKey (`str`): Optional.
      Name of the [environment variable][ENV_VAR]
      that stores the value of the [AWS][AWS] Secret Access Key.
      Defaults to `"AWS_SECRET_ACCESS_KEY"`.

    - sessionToken (`str`): Optional.
      Name of the [environment variable][ENV_VAR]
      that stores the value of the [AWS][AWS] Session Token.
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
, ...
}:
{
  secretsForAwsFromEnv = {
    makesDev = {
      accessKeyId = "MAKES_DEV_AWS_ACCESS_KEY_ID";
      secretAccessKey = "MAKES_DEV_AWS_SECRET_ACCESS_KEY";
    };
    makesProd = {
      accessKeyId = "MAKES_PROD_AWS_ACCESS_KEY_ID";
      secretAccessKey = "MAKES_PROD_AWS_SECRET_ACCESS_KEY";
    };
  };
  lintTerraform = {
    modules = {
      moduleDev = {
        setup = [
          outputs."/secretsForAwsFromEnv/makesDev"
        ];
        src = "/my/module1";
        version = "0.12";
      };
      moduleProd = {
        setup = [
          outputs."/secretsForAwsFromEnv/makesProd"
        ];
        src = "/my/module2";
        version = "0.12";
      };
    };
  };
}
```

## Stability

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

## Examples

### helloWorld

Small command for demo purposes, it greets the specified user:

Types:

- helloWorld:
    - enable (`boolean`): Optional.
      Defaults to false.
    - name (`string`): Required.Some test

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

# Makes.lock.nix reference

Allows you to define the exact version of [Makes]
to evaluate your project with.

Types:

- makesSrc (`package`): Optional.
  Source code of [Makes][MAKES] used to evaluate your Project.
  Defaults to the version bundled with the [Makes][MAKES] CLI.

Example `makes.lock.nix`:

```nix
{
  makesSrc = builtins.fetchGit {
    url = "https://github.com/fluidattacks/makes";
    rev = "0dae5699b8d806e33e18122311c8af9510e18048";
  };
}
```

# Extending Makes

You can create custom workflows
not covered by the builtin `makes.nix` configuration options.

In order to do this:

1. Locate in the root of your project:

    `$ cd /path/to/my/project`

1. Create a directory structure. In this case: `makes/example`.

    `$ mkdir -p makes/example`

    We will place in this directory
    all the source code
    for the custom workflow called `example`.

1. Create a `main.nix` file inside `makes/example`.

    Our goal is to create a bash script that prints `Hello from makes!`,
    so we are going to write the following function:

    ```nix
    # /path/to/my/project/makes/example/main.nix
    { makeScript
    , ...
    }:
    makeScript {
      entrypoint = "echo Hello from Makes!";
      name = "hello-world";
    }
    ```

1. Now run makes!

    - List all available commands: `$ m .`

        ```
        Outputs list for project: /path/to/my/project
          /example
        ```

    - Build and run the output: `$ m . /example`

        ```
        Hello from Makes!
        ```

Makes will automatically recognize as outputs all `main.nix` files
under the `makes/` directory in the root of the project.

You can create any directory structure you want.
Output names will me mapped in an intuitive way:

|`main.nix` position                               |Output name               | Invocation command   |
|--------------------------------------------------|--------------------------|----------------------|
|`/path/to/my/project/makes/main.nix`              |`outputs."/"`             |`$ m . /`             |
|`/path/to/my/project/makes/example/main.nix`      |`outputs."/example"`      |`$ m . /example`      |
|`/path/to/my/project/makes/other/example/main.nix`|`outputs."/other/example"`|`$ m . /other/example`|

## Main.nix format

Each `main.nix` file under the `makes/` directory
should be a function that receives one or more arguments
and returns a derivation:

```nix
{ argA
, argB
, ...
}:
doSomethingAndReturnADerivation
```

### Derivations

On [Nix][NIX]
a [derivation][NIX_DERIVATION]
is the process of:

- taking zero or more inputs

- transforming them as we see fit

- placing the results in the output path

Derivation outputs live in the `/nix/store`.
Their locations in the filesystem are always in the form:
`/nix/store/hash123-name` where
`hash123` is computed by [hashing][HASH] the derivation's inputs.

Derivation outputs are:

- A regular file
- A regular directory that contains arbitrary contents

For instance the derivation output for [Bash][BASH] is:
`/nix/store/kxj6cblcsd1qcbbxlmbswwrn89zcmgd6-bash-4.4-p23`
which contains, among other files:

```tree
/nix/store/kxj6cblcsd1qcbbxlmbswwrn89zcmgd6-bash-4.4-p23
├── bin
│   ├── bash
│   └── sh
```

## Main.nix reference

Makes offers you a few building blocks
for you to reuse.

Let's start from the basics.

### makeSearchPaths

On [Linux][LINUX]
software dependencies
can be located anywhere in the file system.

We can control where
programs find other programs,
dependencies, libraries, etc,
through special environment variables.

Below we describe shortly the purpose
of the environment variables we currently support.

- [CLASSPATH][CLASSPATH]:
  Location of user-defined classes and packages.

- [LD_LIBRARY_PATH][RPATH]:
  Location of libraries for Dynamic Linking Loaders.

- [MYPYPATH][MYPYPATH]:
  Location of library stubs and static types for [MyPy][MYPY].

- [PATH][PATH]:
  Location of directories where executable programs are located.

- [PKG_CONFIG_PATH][PKG_CONFIG_PATH]:
  Location of [pkg-config][PKG_CONFIG] packages.

- [NODE_PATH][NODE_PATH]:
  Location of [Node.js][NODE_JS] modules.

- [PYTHONPATH][PYTHONPATH]:
  Location of [Python][PYTHON] modules and site-packages.

`makeSearchPaths` helps you write code like this:

```nix
makeSearchPaths {
  bin = [ inputs.nixpkgs.git ];
}
```

Instead of this:

```bash
export PATH="/nix/store/m5kp2jhiga25ynk3iq61f4psaqixg7ib-git-2.32.0/bin${PATH:+:}${PATH:-}"
```

Inputs:

- `bin` (`listOf package`): Optional.
  Append `/`
  of every element in the list
  to [PATH][PATH].
  Defaults to `[ ]`.

- `rpath` (`listOf package`): Optional.
  Append `/lib` and `/lib64`
  of every element in the list
  to [LD_LIBRARY_PATH][RPATH].
  Defaults to `[ ]`.

- `source` (`listOf package`): Optional.
  Source (as in [Bash][BASH]'s `source` command)
  every element in the list.
  Defaults to `[ ]`.

Inputs specific to Java:

- `javaClass` (`listOf package`): Optional.
  Append `/`
  of each element in the list
  to [CLASSPATH][CLASSPATH].
  Defaults to `[ ]`.

Inputs specific to [pkg-config][PKG_CONFIG]:

- `pkgConfig` (`listOf derivation`): Optional.
  Append `/lib/pkgconfig`
  of each element in the list
  to [PKG_CONFIG_PATH][PKG_CONFIG_PATH].
  Defaults to `[ ]`.

Inputs specific to [Python][PYTHON]:

- `pythonMypy` (`listOf package`): Optional.
  Append `/`
  of each element in the list
  to [MYPYPATH][MYPYPATH].
  Defaults to `[ ]`.

- `pythonMypy37` (`listOf package`): Optional.
  Append `/lib/python3.7/site-packages`
  of each element in the list
  to [MYPYPATH][MYPYPATH].
  Defaults to `[ ]`.

- `pythonMypy38` (`listOf package`): Optional.
  Append `/lib/python3.8/site-packages`
  of each element in the list
  to [MYPYPATH][MYPYPATH].
  Defaults to `[ ]`.

- `pythonMypy39` (`listOf package`): Optional.
  Append `/lib/python3.9/site-packages`
  of each element in the list
  to [MYPYPATH][MYPYPATH].
  Defaults to `[ ]`.

- `pythonPackage` (`listOf package`): Optional.
  Append `/`
  of each element in the list
  to [PYTHONPATH][PYTHONPATH].
  Defaults to `[ ]`.

- `pythonPackage37` (`listOf package`): Optional.
  Append `/lib/python3.7/site-packages`
  of each element in the list
  to [PYTHONPATH][PYTHONPATH].
  Defaults to `[ ]`.

- `pythonPackage38` (`listOf package`): Optional.
  Append `/lib/python3.8/site-packages`
  of each element in the list
  to [PYTHONPATH][PYTHONPATH].
  Defaults to `[ ]`.

- `pythonPackage39` (`listOf package`): Optional.
  Append `/lib/python3.9/site-packages`
  of each element in the list
  to [PYTHONPATH][PYTHONPATH].
  Defaults to `[ ]`.

Inputs specific to [Node.js][NODE_JS]:

- `nodeBin` (`listOf package`): Optional.
  Append `/node_modules/.bin`
  of each element in the list
  to [PATH][PATH].
  Defaults to `[ ]`.

- `nodeModule` (`listOf package`): Optional.
  Append `/node_modules`
  of each element in the list
  to [NODE_PATH][NODE_PATH].
  Defaults to `[ ]`.

Example:

```nix
{ makeSearchPaths
, ...
}:
makeSearchPaths {
  bin = [ inputs.nixpkgs.git ];
}
```

### makeDerivation

Perform a build step in an **isolated** environment:

- External environment variables are not visible by the builder script.
  This means you **can't** use secrets here.
- Search Paths as in `makeSearchPaths` are completely empty.
- The `HOME` environment variable is set to `/homeless-shelter`.
- Only [GNU coreutils][GNU_COREUTILS] commands (cat, echo, ls, ...)
  are present by default.
- An environment variable called `out` is present
  and represents the derivation's output.
  The derivation **must** produce an output,
  may be a file, or a directory.
- After the build, for all paths in `$out`:
    - User and group ownership are removed
    - Last-modified timestamps are reset to `1970-01-01T00:00:00+00:00`.

Inputs:

- builder (`either str package`):
  A [Bash][BASH] script that performs the build step.
- env (`attrsOf str`): Optional.
  Environment variables that will be propagated to the `builder`.
  Variable names must start with `env`.
  Defaults to `{ }`.
- name (`str`):
  Custom name to assign to the build step, be creative, it helps in debugging.
- searchPaths (`asIn makeSearchPaths`): Optional.
  Arguments here will be passed as-is to `makeSearchPaths`.
  Defaults to `makeSearchPaths`'s defaults.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ inputs
, makeDerivation
, ...
}:
makeDerivation {
  env = {
    envVersion = "1.0";
  };
  builder = ''
    debug Version is $envVersion
    info Running tree command on $PWD
    mkdir dir
    touch dir/file
    tree dir > $out
  '';
  name = "example";
  searchPaths = {
    bin = [ inputs.nixpkgs.tree ];
  };
}
```

```bash
$ m . /example

    [DEBUG] Version is 1.0
    [INFO] Running tree command on /tmp/nix-build-example.drv-0
    /nix/store/30hg7hzn6d3zmfva1bl4zispqilbh3nm-example

$ cat /nix/store/30hg7hzn6d3zmfva1bl4zispqilbh3nm-example
    dir
    `-- file

    0 directories, 1 file
```

### makeScript

Wrap a [Bash][BASH] script
that runs in a **quasi-isolated** environment.

- The file system is **not** isolated, the script runs in user-space.
- External environment variables are visible by the script.
  You can use this to propagate secrets.
- Search Paths as in `makeSearchPaths` are completely empty.
- The `HOME_IMPURE` environment variable is set to the user's home directory.
- The `HOME` environment variable is set to a temporary directory.
- Only [GNU coreutils][GNU_COREUTILS] commands (cat, echo, ls, ...)
  are present by default.
- An environment variable called `STATE` points to a directory
  that can be used to store the script's state (if any).
- After the build, the script is executed.

Inputs:

- entrypoint (`either str package`):
  A [Bash][BASH] script that performs the build step.
- name (`str`):
  Custom name to assign to the build step, be creative, it helps in debugging.
- replace (`attrsOf str`): Optional.
  Placeholders will be replaced in the script with their respective value.
  Variable names must start with `__arg`, end with `__`
  and have at least 6 characters long.
  Defaults to `{ }`.
- searchPaths (`asIn makeSearchPaths`): Optional.
  Arguments here will be passed as-is to `makeSearchPaths`.
  Defaults to `makeSearchPaths`'s defaults.

Example:

```nix

# /path/to/my/project/makes/example/main.nix
{ inputs
, makeScript
, ...
}:
makeScript {
  replace = {
    __argVersion__ = "1.0";
  };
  entrypoint = ''
    debug Version is __argVersion__
    info pwd is $PWD
    info Running tree command on $STATE
    mkdir $STATE/dir
    touch $STATE/dir/file
    tree $STATE
  '';
  name = "example";
  searchPaths = {
    bin = [ inputs.nixpkgs.tree ];
  };
}
```

```bash
$ m . /example

    [DEBUG] Version is 1.0
    [INFO] pwd is /data/github/fluidattacks/makes
    [INFO] Running tree command on /home/user/.makes/state/example
    /home/user/.makes/state/example
    └── dir
        └── file

    1 directory, 1 file
```

### projectPath

Store a path out of the current [Makes][MAKES] project
being evaluated in the [Nix][NIX] store.

- It can be used for including paths in
  [makeScript](#makescript)
  and [makeDerivation](#makederivation)
  via `replace` and `env`
  parameters respectively.
- Derivations are rebuilt
  every time
  provided path contents change,
  thus increasing reproducibility.
- Derivations are not rebuilt
  if the path contents do not change,
  thus increasing performance.
- It removes spurious files and directories
  created while developing,
  thus increasing reproducibility.

Inputs:

- relativePath (`str`):
  path to store.
  It must be absolute
  within the repository.

Example:

```nix
# Consider the following path within the repository: /src/nix

# /path/to/my/project/makes/example/main.nix
{ makeScript
, projectPath
, ...
}:
makeScript {
  replace = {
    __argPath__ = projectPath "/src/nix";
  };
  entrypoint = ''
    info Path is: __argPath__
    info Path contents are:
    ls __argPath__
  '';
  name = "example";
}
```

```bash
$ m . /example

    [INFO] Path is: <nix-store-path>
    [INFO] Path contents are:
    packages.nix  sources.json  sources.nix
```

### asBashArray

Transform a list of arguments
into a [Bash][BASH] array.
It can be used for passing
several arguments from [Nix][NIX]
to [Bash][BASH].

Inputs:

- args (`listOf str`):
  list of arguments
  to transform.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ asBashArray
, makeDerivation
, ...
}:
makeDerivation {
  env = {
    envTargets = asBashArray [ "first" "second" "third" ];
  };
  builder = ''
    source "''${envTargets}/template" export targets
    for target in "''${targets[@]}"; do
      info "''${target}"
      info ---
    done
  '';
  name = "example";
}
```

```bash
$ m . /example

    [INFO] first
    [INFO] ---
    [INFO] second
    [INFO] ---
    [INFO] third
    [INFO] ----
```

### fromYaml

Convert a [YAML][YAML] string
to a [Nix][NIX] value.

Inputs:

- expr (`str`):
  [YAML][YAML] expression to convert.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ fromYaml
, makeDerivation
, ...
}:
let
  data = fromYaml ''
    name: "John"
    lastName: "Doe"
    tickets: 3
  '';
in
makeDerivation {
  env = {
    envName = data.name;
    envLastName = data.lastName;
    envTickets = data.tickets;
  };
  builder = ''
    info "Name is: ${envName}"
    info "Last name is: ${envLastName}"
    info "Tickets is: ${envTickets}"
  '';
  name = "example";
}
```

```bash
$ m . /example

    [INFO] Name is: John
    [INFO] Last name is: Doe
    [INFO] Tickets is: 3
```

### toFileJsonFromFileYaml

Use [yq][YQ] to
transform a [YAML][YAML] file
into its [JSON][JSON]
equivalent.

Inputs:

- envSrc (`path`):
  [YAML][YAML] file to
  transform.

Examples:

```yaml
# /path/to/my/project/test.yaml

name: "John"
lastName: "Doe"
tickets: 3
```

```nix
# /path/to/my/project/makes/example/main.nix
{ makeDerivation
, projectPath
, toFileJsonFromFileYaml
, ...
}:
makeDerivation {
  env = {
    envJson = toFileJsonFromFileYaml (
      projectPath "/path/to/my/project/test.yaml");
  };
  builder = ''
    cat "''${envJson}"
  '';
  name = "example";
}
```

```bash
$ m . /example

{
  "name": "John",
  "lastName": "Doe",
  "tickets": 3
}
```

:construction: This section is Work in progress

# Contact an expert

- [Makes][MAKES] support: help@fluidattacks.com
- Cyber**security**: [Fluid Attacks][FLUID_ATTACKS]

# Contributing to Makes

## Is easy

- Bug reports: [here][MAKES_ISSUES]
- Feature requests: [here][MAKES_ISSUES]
- Give us a :star:: [here][MAKES]
- Feedback: [here][MAKES_ISSUES]

## Code contributions

We accept anything that benefits the community,
thanks for sharing your work with the world.
We can discuss implementation details [here][MAKES_ISSUES].

1. Write your idea: [here][MAKES_ISSUES]
1. Fork [Makes on GitHub][MAKES]
1. [Git][GIT]-clone your fork
1. Hack as much as you like!
1. [Git][GIT]-push changes to your fork
1. Create a **Pull Request** from your fork to [Makes][MAKES]

Guidelines:

- Keep it simple
- Remember we write code for humans, not machines
- Write an argument: `/src/args`
- Write a module (if applies): `/src/evaluator/modules`
- Write docs: `/README.md`
- Write a test: `/makes.nix` or `/makes/**/main.nix`
- Write a test [GitHub workflow][GITHUB_WORKFLOWS]: `/.github/workflows/dev.yml`

Examples:

- [feat(build): #262 lint git mailmap](
  https://github.com/fluidattacks/makes/commit/01fcd5790dd54b117da63bcc2480437135da8bb3)
- [feat(build): #232 lint terraform](
  https://github.com/fluidattacks/makes/commit/081835b563c712b7650dbc5bf1e306d4aff159cf)
- [feat(build): #232 test terraform](
  https://github.com/fluidattacks/makes/commit/571cf059b521cb97396210f9fe4659ee74f675b4)
- [feat(build): #232 deploy terraform](
  https://github.com/fluidattacks/makes/commit/f827da16b685b07d7f987c668c0fe089aefa7931)
- [feat(build): #252 aws secrets from env](
  https://github.com/fluidattacks/makes/commit/1c9f06a809bd92d56939d5809ce46058856fdf0a)
- [feat(build): #232 make parallel utils](
  https://github.com/fluidattacks/makes/commit/99e9f77482a6cbc9858a7a928a91a8a8aa9ff353)

# References

- [AJV_CLI]: https://github.com/ajv-validator/ajv-cli
  [ajv-cli][AJV_CLI]

- [Ansible]: https://www.ansible.com/
  [Ansible][ANSIBLE]

- [AWS]: https://aws.amazon.com/
  [Amazon Web Services (AWS)][AWS]

- [APACHE_ANT]: https://ant.apache.org/
  [Apache Ant][APACHE_ANT]

- [APACHE_MAVEN]: https://maven.apache.org/
  [Apache Maven][APACHE_MAVEN]

- [APT]: https://en.wikipedia.org/wiki/APT_(software)
  [Advanced Package Tool][APT]

- [BANDIT]: https://github.com/PyCQA/bandit
  [Bandit][BANDIT]

- [BASH]: https://www.gnu.org/software/bash/
  [Bash][BASH]

- [BASH_TUTORIAL_SHELL_SCRIPTING]: https://www.tutorialspoint.com/unix/shell_scripting.htm
  [Shell Scripting Tutorial][BASH_TUTORIAL_SHELL_SCRIPTING]

- [BLACK]: https://github.com/psf/black
  [Black][BLACK]

- [BUCK]: https://buck.build/
  [Buck][BUCK]

- [CACHIX]: https://cachix.org/
  [Cachix][CACHIX]

- [CALVER]: https://calver.org/
  [Calendar Versioning][CALVER]

- [CHEF]: https://www.chef.io/
  [Chef][CHEF]

- [CI_CD]: https://en.wikipedia.org/wiki/CI/CD
  [CI/CD][CI_CD]

- [CIRCLE_CI]: https://circleci.com/
  [Circle CI][CIRCLE_CI]

- [CLASSPATH]: https://en.wikipedia.org/wiki/Classpath
  [CLASSPATH Environment Variable][CLASSPATH]

- [CLJ-KONDO]: https://github.com/clj-kondo/clj-kondo
  [clj-kondo][CLJ-KONDO]

- [COMMITLINT]: https://commitlint.js.org/#/
  [commitlint][COMMITLINT]

- [DOCKER]: https://www.docker.com/
  [Docker][DOCKER]

- [DOCTOC]: https://github.com/thlorenz/doctoc
  [DocToc][DOCTOC]

- [ENV_VAR]: https://en.wikipedia.org/wiki/Environment_variable
  [Environment Variable][ENV_VAR]

- [FLUID_ATTACKS]: https://fluidattacks.com
  [Fluid Attacks][FLUID_ATTACKS]

- [GIT]: https://git-scm.com/
  [Git][GIT]

- [GIT_MAILMAP]: https://git-scm.com/docs/gitmailmap
  [Git Mailmap][GIT_MAILMAP]

- [GITHUB_ACTIONS]: https://github.com/features/actions
  [Github Actions][GITHUB_ACTIONS]

- [GITHUB_WORKFLOWS]: https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions
  [Github Workflows][GITHUB_WORKFLOWS]

- [GITLAB_CI]: https://docs.gitlab.com/ee/ci/
  [GitLab CI][GITLAB_CI]

- [GITLAB_CI_REF]: https://docs.gitlab.com/ee/ci/yaml/
  [GitLab CI configuration syntax][GITLAB_CI_REF]

- [GITLAB_VARS]: https://docs.gitlab.com/ee/ci/variables/
  [GitLab Variables][GITLAB_VARS]

- [GNU_MAKE]: https://www.gnu.org/software/make/
  [GNU Make][GNU_MAKE]

- [GNU_COREUTILS]: https://www.gnu.org/software/coreutils/
  [GNU Coreutils][GNU_COREUTILS]

- [GRADLE]: https://gradle.org/
  [Gradle][GRADLE]

- [GRUNT]: https://gruntjs.com/
  [Grunt][GRUNT]

- [GULP]: https://gulpjs.com/
  [Gulp][GULP]

- [HASH]: https://en.wikipedia.org/wiki/Hash_function
  [Hash Function][HASH]

- [ISORT]: https://github.com/PyCQA/isort
  [isort][ISORT]

- [JSON]: https://www.json.org/json-en.html
  [JSON][JSON]

- [JSON_SCHEMA]: https://json-schema.org/
  [JSON Schema][JSON_SCHEMA]

- [KUBERNETES]: https://kubernetes.io/
  [Kubernetes][KUBERNETES]

- [LEININGEN]: https://leiningen.org/
  [Leiningen][LEININGEN]

- [LINUX]: https://en.wikipedia.org/wiki/Linux
  [Linux][LINUX]

- [LIZARD]: https://github.com/terryyin/lizard
  [Lizard][LIZARD]

- [MAILMAP_LINTER]: https://github.com/kamadorueda/mailmap-linter
  [Mailmap Linter][MAILMAP_LINTER]

- [MAKES]: https://github.com/fluidattacks/makes
  [Makes][MAKES]

- [MAKES_LOCK_REF]: #makeslocknix-reference
  [Makes.lock.nix Reference][MAKES_LOCK_REF]

- [MAKES_COMMITS]: https://github.com/fluidattacks/makes/commits/main
  [Makes Commits][MAKES_COMMITS]

- [MAKES_ENVIRONMENT]: #environment
  [Makes Environment][MAKES_ENVIRONMENT]

- [MAKES_ISSUES]: https://github.com/fluidattacks/makes/issues
  [Makes issues][MAKES_ISSUES]

- [MAKES_RELEASES]: https://github.com/fluidattacks/makes/releases
  [Makes Releases][MAKES_RELEASES]

- [MAKES_SECRETS]: #secrets
  [Makes Secrets][MAKES_SECRETS]

- [MARKDOWN_LINT]: https://github.com/markdownlint/markdownlint
  [Markdown lint tool][MARKDOWN_LINT]

- [MYPY]: https://mypy.readthedocs.io/en/stable/
  [MyPy][MYPY]

- [MYPYPATH]: https://mypy.readthedocs.io/en/stable/running_mypy.html
  [MYPYPATH Environment Variable][MYPYPATH]

- [NIX]: https://nixos.org
  [Nix][NIX]

- [NIX_DERIVATION]: https://nixos.org/manual/nix/unstable/expressions/derivations.html
  [Nix Derivation][NIX_DERIVATION]

- [NIX_DOWNLOAD]: https://nixos.org/download
  [Nix Download Page][NIX_DOWNLOAD]

- [NIX_FLAKES]: https://www.tweag.io/blog/2020-05-25-flakes/
  [Nix Flakes][NIX_FLAKES]

- [NIX_PLATFORMS]: https://nixos.org/manual/nix/unstable/installation/supported-platforms.html
  [Nix Supported Platforms][NIX_PLATFORMS]

- [NIX_LINTER]: https://github.com/Synthetica9/nix-linter'
  [nix-linter][NIX_LINTER]

- [NIX_PILLS]: https://nixos.org/guides/nix-pills/
  [Nix Pills][NIX_PILLS]

- [NIX_PKGS_FMT]: https://github.com/nix-community/nixpkgs-fmt
  [nixpkgs-fmt][NIX_PKGS_FMT]

- [NODE_JS]: https://nodejs.org/en/
  [NODE_JS][NODE_JS]

- [NODE_PATH]: https://nodejs.org/api/modules.html
  [NODE_PATH][NODE_PATH]

- [NPM]: https://www.npmjs.com/
  [Node Package Manager (NPM)][NPM]

- [OCI_FORMAT_REPO]: https://github.com/opencontainers/image-spec
  [Open Container Image specification][OCI_FORMAT_REPO]

- [PACKER]: https://www.packer.io/
  [Packer][PACKER]

- [PATH]: https://en.wikipedia.org/wiki/PATH_(variable)
  [PATH Environment Variable][PATH]

- [PIP]: https://pypi.org/project/pip/
  [Package Installer for Python (pip)][PIP]

- [PKG_CONFIG]: https://www.freedesktop.org/wiki/Software/pkg-config/
  [pkg-config][PKG_CONFIG]

- [PROSPECTOR]: http://prospector.landscape.io/en/master/
  [Prospector][PROSPECTOR]

- [PYTHON]: https://www.python.org/
  [Python][PYTHON]

- [PYTHONPATH]: https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH
  [PYTHONPATH Environment Variable][PYTHONPATH]

- [RAKE]: https://github.com/ruby/rake
  [Rake][RAKE]

- [REPRODUCIBLE_BUILDS]: https://reproducible-builds.org/
  [Reproducible Builds][REPRODUCIBLE_BUILDS]

- [RPATH]: https://en.wikipedia.org/wiki/Rpath
  [RPath][RPATH]

- [RPM]: https://rpm.org/
  [RPM Package Manager][RPM]

- [SBT]: https://www.scala-sbt.org/
  [sbt][SBT]

- [SCONS]: https://scons.org/
  [SCons][SCONS]

- [SHELLCHECK]: https://github.com/koalaman/shellcheck
  [ShellCheck][SHELLCHECK]

- [SHFMT]: https://github.com/mvdan/sh
  [SHFMT][SHFMT]

- [TERRAFORM]: https://www.terraform.io/
  [Terraform][TERRAFORM]

- [TERRAFORM_FMT]: https://www.terraform.io/docs/cli/commands/fmt.html
  [Terraform FMT][TERRAFORM_FMT]

- [TFLINT]: https://github.com/terraform-linters/tflint
  [TFLint][TFLINT]

- [TRAVIS_CI]: https://travis-ci.org/
  [Travis CI][TRAVIS_CI]

- [TRAVIS_CI_REF]: https://config.travis-ci.com/
  [Travis CI reference][TRAVIS_CI_REF]

- [TRAVIS_ENV_VARS]: https://docs.travis-ci.com/user/environment-variables
  [Travis Environment Variables][TRAVIS_ENV_VARS]

- [X86_64]: https://en.wikipedia.org/wiki/X86-64
  [x86-64][X86_64]

- [YAML]: https://yaml.org/
  [YAML][YAML]

- [YQ]: https://github.com/mikefarah/yq
  [yq][YQ]

- [YUM]: http://yum.baseurl.org/
  [Yellowdog Updated Modified (yum)][YUM]
