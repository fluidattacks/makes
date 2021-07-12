# Makes v21.08

A SecDevOps framework
powered by [Nix][NIX].

Our primary goal is to help you setup
a powerful [CI/CD][CI_CD] system
in just a few steps, in any technology.

## Why?

Designing a fast, reliable, reproducible, easy-to-use
[CI/CD][CI_CD] system **is no easy task**.

While there are free and paid tools in the market like:
[Apache Ant][APACHE_ANT],
[Docker][DOCKER],
[Gradle][GRADLE],
[Grunt][GRUNT],
[Gulp][GULP],
[Maven][APACHE_MAVEN],
[GNU Make][GNU_MAKE]
[Leiningen][LEININGEN],
[Packer][PACKER],
and
[sbt][SBT].
Most real world production systems:

- Are composed of several programming languages,
  and most tools in the market are just focused in 1.
- Contain hundreds of thousands of dependencies:
    - Compilers
    - Shared-Object libraries (.so)
    - Runtime interpreters
    - Configuration files
    - Vendor artifacts
    - Accounts / Credentials / Secrets

  That most tools in the market cannot fetch, configure, and setup
  in an easy/automated/secure way,
  and most of them do not even support a way of declaring such dependencies.
- Have tens to hundreds of developers
  working across the globe from different setups, stacks and operative systems.

  And most tools cannot guarantee all of them
  an **exactly equal** developing environment.
- Have tens to thousands of production servers
  that need to be deployed to.

  And most tools just cover the: How to build? and not the: How to deploy?.
- Made of several micro-components that one need to orchestrate correctly,
  or fix sunday morning, instead of sharing with family :parasol_on_ground:.
- Need to be **reliable** and **100% available**.

You can instead use [Nix][NIX] which features:

- A single build-tool for everything
- Easy, powerful, modular and expressive dependency declaration.
  From compilers to vendor artifacts.
- Guarantees each developer an **exact**,
  [reproducible][REPRODUCIBLE_BUILDS] environment in which to build and run stuff.
  Isolating as much as possible,
  reducing a lot of bugs along the way.
- Defines a way for you to deploy software **perfectly**.
- And therefore helps you build **reliable** and **100% available** systems.

So, if [Nix][NIX] is that powerful: Why [Makes][MAKES], then?

[Makes][MAKES] wraps [Nix][NIX]
in an opinionated way
that allows users and developers
to get things done, fast.
It incorporates common workflows
for formatting, linting, building, testing, managing infrastructure as code
with terraform, deploying to Kubernetes clusters,
creating development environments, etc.
With as little code as possible.
[Makes][MAKES] tries to hide all the unnecessary complexity
so you can focus on the business logic.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Contents

- [Philosophy](#philosophy)
- [Getting started](#getting-started)
    - [Getting started as user](#getting-started-as-user)
    - [Getting started as developer](#getting-started-as-developer)
- [Configuring CI/CD](#configuring-cicd)
    - [Versioning scheme](#versioning-scheme)
    - [Configuring on GitHub Actions](#configuring-on-github-actions)
    - [Configuring on GitLab CI/CD](#configuring-on-gitlab-cicd)
    - [Configuring on Travis CI](#configuring-on-travis-ci)
- [Makes.nix format](#makesnix-format)
    - [Linters](#linters)
        - [lintBash](#lintbash)
        - [lintCommitMsg](#lintcommitmsg)
        - [lintMarkdown](#lintmarkdown)
        - [lintNix](#lintnix)
        - [lintPython](#lintpython)
    - [Formatters](#formatters)
        - [formatBash](#formatbash)
        - [formatMarkdown](#formatmarkdown)
        - [formatNix](#formatnix)
        - [formatPython](#formatpython)
    - [Pinning](#pinning)
        - [inputs](#inputs)
        - [requiredMakesVersion](#requiredmakesversion)
    - [Container Images](#container-images)
        - [deployContainerImage](#deploycontainerimage)
    - [Examples](#examples)
        - [helloWorld](#helloworld)
- [Extending Makes](#extending-makes)
    - [Main.nix format](#mainnix-format)
    - [makeSearchPaths](#makesearchpaths)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Philosophy

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
Which means that Makes is able to run
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

1. For local [Makes][MAKES] projects:

    1. `$ cd /path/to/a/makes/project`

    For remote [Makes][MAKES] projects:

    1. Export `M_FROM` to the git-clone URL of the project:

        For example:
        - http: `$ export M_FROM=https://github.com/fluidattacks/makes`
        - ssh: `$ export M_FROM=git@github.com:fluidattacks/makes`

1. Now run makes!
    - List all available commands: `$ m`

        ```
        Outputs list for project: https://github.com/fluidattacks/makes
          /helloWorld
        ```

    - Run a command: `$ m /helloWorld 1 2 3`

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
    - List all available commands: `$ m`

        ```
        Outputs list for project: /path/to/my/project
          /helloWorld
        ```

    - Run a command: `$ m /helloWorld 1 2 3`

        ```
        [INFO] Hello from Makes! Jane Doe.
        [INFO] You called us with CLI arguments: [ 1 2 3 ].
        ```

# Configuring CI/CD

## Providers comparison

We've thoroughly tested these providers throughout the years,
below is a small table that clearly expresses their trade-offs.

| Provider                         | Easy   | Config | Scale  | SaaS   | Security |
|----------------------------------|--------|--------|--------|--------|----------|
| [GitHub Actions][GITHUB_ACTIONS] | :star: | :star: | :star: | :star: |          |
| [GitLab CI/CD][GITLAB_CI]        | :star: | :star: |        | :star: | :star:   |
| [Travis CI][TRAVIS_CI]           |        |        | :star: | :star: | :star:   |

If you are getting started in the world of CI/CD
it's a good idea to try [GitHub Actions][GITHUB_ACTIONS].

If you want serious security try [GitLab CI/CD][GITLAB_CI].

We didn't like [Travis CI][TRAVIS_CI]
because its way of managing encrypted secrets is uncomfortable
and the fact it does not support running custom container images.

## Versioning scheme

We use [calendar versioning][CALVER] in Makes,
like this: `20.12` (at December 2020).

You can assume that the current month release is stable,
we won't add new features to it nor change it in backward-incompatible ways.
The development or unstable releases are normally tagged with the next month
[calendar version][CALVER], for instance `21.01` (at December 2020).
The `main` release always points to the latest commit in this repository,
it should be considered highly unstable.

For maximum stability you should use the stable release,
in other words: the current month in [calendar versioning][CALVER].
For instance: `21.01` if the current date is January 2021.

At the same time, please consider keeping your [Makes][MAKES] updated.
New features are added constantly.

## Configuring on GitHub Actions

[GitHub Actions][GITHUB_ACTIONS]
is configured through [workflow files][GITHUB_WORKFLOWS]
located in a `.github/workflows` folder in the root of the project.

The smallest possible [workflow file][GITHUB_WORKFLOWS]
looks like this:

```yaml
# .github/workflows/main.yml
name: Makes CI
on: [push, pull_request]
jobs:
  helloWorld:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      # We offer this GitHub action in the following versions:
      #   main: latest release (example: /makes:main)
      #   yy.mm: monthly release (example: /makes:21.07)
    - uses: docker://ghcr.io/fluidattacks/makes:main
      # You can use any name you like here
      name: helloWorld
      # You can pass secrets (if required) as environment variables like this:
      env:
        SECRET_NAME: ${{ secrets.SECRET_IN_YOUR_GITHUB }}
      with:
        args: m /helloWorld 1 2 3

  # Add more jobs here, you can copy paste jobs.helloWorld and modify the `args`
```

## Configuring on GitLab CI/CD

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
  #   yy.mm: monthly release (example: /makes:21.07)
  image: registry.gitlab.com/fluidattacks/product/makes:main
  script:
    - m /helloWorld 1 2 3

# Add more jobs here, you can copy paste /helloWorld and modify the `script`
```

Secrets can be propagated to Makes through [GitLab Variables][GITLAB_VARS],
which are passed automatically to the running container
as environment variables.

## Configuring on Travis CI

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
#   yy.mm: monthly release (example: /install/21.07)
install: nix-env -if https://fluidattacks.com/makes/install/21.07
env:
  global:
    # Encrypted environment variable
    secure: cipher-text-goes-here...
    # Publicly visible environment variable
    NAME: value
jobs:
  include:
  - script: m /helloWorld 1 2 3
  # You can add more jobs like this:
  # - script: m /formatBash
```

Secrets can be propagated to Makes through
[Travis Environment Variables][TRAVIS_ENV_VARS],
which are passed automatically to the running container
as environment variables.
We highly recommend you to use encrypted environment variables as
explained in the [Travis Environment Variables Reference][TRAVIS_ENV_VARS].

# Makes.nix format

A Makes project is identified by a `makes.nix` file
in the top level directory.

Below we document all configuration options you can tweak with it.

## Linters

Linters ensure source code follows
best practices.

### lintBash

Lints Bash code with [ShellCheck][SHELLCHECK].

Attributes:

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
      "/folder" # A folder within the project
    ];
  };
}
```

Example invocation: `$ m /lintBash`

### lintCommitMsg

It creates a commit diff
between you current branch
and the main branch of the repository.
All commits included in the diff
are linted using [commitlint][COMMITLINT].

Attributes:

- enable (`boolean`): Optional.
  Defaults to false.
- branch (`str`): Optional.
  Name of the main branch.
  Defaults to `main`.

Example `makes.nix`:

```nix
{
  lintCommitMsg = {
    enable = true;
    branch = "my-branch-name";
  };
}
```

Example invocation: `$ m /lintCommitMsg`

### lintMarkdown

Lints Markdown code with [Markdown lint tool][MARKDOWN_LINT].

Attributes:

- enable (`boolean`): Optional.
  Defaults to false.
- targets (`listOf str`): Optional.
  Files or directories (relative to the project) to lint.
  Defaults to the entire project.

Example `makes.nix`:

```nix
{
  lintMarkdown = {
    enable = true;
    targets = [
      "/" # Entire project
      "/file.md" # A file
      "/folder" # A folder within the project
    ];
  };
}
```

Example invocation: `$ m /lintMarkdown`

### lintNix

Lints Nix code with [nix-linter][NIX_LINTER].

Attributes:

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
      "/folder" # A folder within the project
    ];
  };
}
```

Example invocation: `$ m /lintNix`

### lintPython

Lints Python code with [mypy][MYPY] and [Prospector][PROSPECTOR].

Attributes:

- enable (`boolean`): Optional.
  Defaults to false.
- dirsOfModules (`attrsOf dirOfModulesType`): Optional.
  Definitions of directories of python packages/modules to lint.
  Defaults to `{ }`.
- modules (`attrsOf moduleType`): Optional.
  Definitions of python packages/modules to lint.
  Defaults to `{ }`.

Custom Types:

- dirOfModulesType (`submodule`):
    - extraSources (`listOf package`): Optional.
      List of scripts that will be sourced before performing the linting process.
      Can be used to setup dependencies of the project in the environment.
      Defaults to `[ ]`
    - python (`enum [ "3.7" "3.8" "3.9" ]`):
      Python interpreter version that your package/module is designed for.
    - src (`str`):
      Path to the folder that contains inside many packages/modules.
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
    enable = true;
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

Example invocation: `$ m /lintPython/dirOfModules/makes`

Example invocation: `$ m /lintPython/dirOfModules/makes/main`

Example invocation: `$ m /lintPython/module/cliMain`

## Formatters

Formatters help your code be consistent, beautiful and more maintainable.

### formatBash

Ensure that Bash code is formatted according to [shfmt][SHFMT].

Attributes:

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
      "/folder" # A folder within the project
    ];
  };
}
```

Example invocation: `$ m /formatBash`

### formatMarkdown

Ensure that Markdown code is formatted according to [doctoc][DOCTOC].

Attributes:

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

Example invocation: `$ m /formatMarkdown`

### formatNix

Ensure that Nix code is formatted according to [nixpkgs-fmt][NIX_PKGS_FMT].

Attributes:

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
      "/folder" # A folder within the project
    ];
  };
}
```

Example invocation: `$ m /formatNix`

### formatPython

Ensure that Python code is formatted according to [Black][BLACK]
and [isort][ISORT].

Attributes:

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
      "/folder" # A folder within the project
    ];
  };
}
```

Example invocation: `$ m /formatPython`

## Pinning

### inputs

Explicitly declare the inputs and sources for your project.
Inputs can be anything.

Attributes:

- self (`attrs`): Optional.
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

### requiredMakesVersion

Ensure that the Makes version people use in your project is the one you want.
This increases reproducibility and prevents compatibility mismatches.
People will use the Makes version you know your project works with.

Attributes:

- self (`str`): Optional.
  Defaults to the version installed in the system.

Example `makes.nix`:

```nix
{
  requiredMakesVersion = "21.08";
}
```

## Container Images

### deployContainerImage

Deploy a set of container images in [OCI Format][OCI_FORMAT_REPO]
to the specified container registries.

Attributes:

- enable (`boolean`): Optional.
  Defaults to false.
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

- CI_REGISTRY_USER and CI_REGISTRY_PASSWORD, when deploying to GitLab.
- DOCKER_HUB_USER and DOCKER_HUB_PASS, when deploying to Docker Hub.
- GITHUB_ACTOR and GITHUB_TOKEN, when deploying to Github Container Registry.

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
    enable = true;
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

Example invocation: `$ DOCKER_HUB_USER=user DOCKER_HUB_PASS=123 m /deployContainerImage/nginxDockerHub`

Example invocation: `$ GITHUB_ACTOR=user GITHUB_TOKEN=123 m /deployContainerImage/makesGitHub`

Example invocation: `$ CI_REGISTRY_USER=user CI_REGISTRY_PASSWORD=123 m /deployContainerImage/makesGitLab`

## Examples

### helloWorld

Small command for demo purposes, it greets the specified user:

Attributes:

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

Example invocation: `$ m /helloWorld 1 2 3`

# Extending Makes

You can create custom workflows
not covered by the builtin `makes.nix` configuration options.

In order to do this:

1. Locate in the root of your project:

    `$ cd /path/to/my/project`

1. Create a directory structure. In this case: `makes/example`.

    `$ mkdir -p makes/example`

    We will place in this folder
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

    - List all available commands: `$ m`

        ```
        Outputs list for project: /path/to/my/project
          /example
        ```

    - Run the command: `$ m /example`

        ```
        Hello from Makes!
        ```

Makes will automatically recognize as outputs all `main.nix` files
under the `makes/` folder in the root of the project.

You can create any directory structure you want.
Output names will me mapped in an intuitive way:

|`main.nix` position                               |Output name       | Invocation command |
|--------------------------------------------------|------------------|--------------------|
|`/path/to/my/project/makes/main.nix`              |`outputs."/"`             |`$ m /`             |
|`/path/to/my/project/makes/example/main.nix`      |`outputs."/example"`      |`$ m /example`      |
|`/path/to/my/project/makes/other/example/main.nix`|`outputs."/other/example"`|`$ m /other/example`|

## Main.nix format

Each `main.nix` file under the `makes/` folder
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

- placing the results in the output directory

Derivation outputs live in the `/nix/store`.
Their locations in the filesystem are always in the form:
`/nix/store/hash123-name` where
`hash123` is computed by [hashing][HASH] the derivation's inputs.

Derivation outputs are regular directories that contain arbitrary contents.
For instance the derivation output for [Bash][BASH] is:
`/nix/store/kxj6cblcsd1qcbbxlmbswwrn89zcmgd6-bash-4.4-p23`
which contains, among other files:

```tree
/nix/store/kxj6cblcsd1qcbbxlmbswwrn89zcmgd6-bash-4.4-p23
├── bin
│   ├── bash
│   └── sh
```

## Main.nix function arguments

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

- `bin` (`listOf package`):
  Append `/`
  of every element in the list
  to [PATH][PATH].

- `ldLib` (`listOf package`):
  Append `/lib` and `/lib64`
  of every element in the list
  to [LD_LIBRARY_PATH][RPATH].

- `ldLib` (`listOf package`):
  Append `/lib` and `/lib64`
  of every element in the list
  to [LD_LIBRARY_PATH][RPATH].

- `source` (`listOf package`):
  Source (as in [Bash][BASH]'s `source` command)
  every element in the list.

Inputs specific to Java:

- `javaClass` (`listOf package`):
  Append `/`
  of each element in the list
  to [CLASSPATH][CLASSPATH].

Inputs specific to [Python][PYTHON]:

- `pythonMypy` (`listOf package`):
  Append `/`
  of each element in the list
  to [MYPYPATH][MYPYPATH].

- `pythonMypy38` (`listOf package`):
  Append `/lib/python3.8/site-packages`
  of each element in the list
  to [MYPYPATH][MYPYPATH].

- `pythonPackage` (`listOf package`):
  Append `/`
  of each element in the list
  to [PYTHONPATH][PYTHONPATH].

- `pythonPackage37` (`listOf package`):
  Append `/lib/python3.7/site-packages`
  of each element in the list
  to [PYTHONPATH][PYTHONPATH].

- `pythonPackage38` (`listOf package`):
  Append `/lib/python3.8/site-packages`
  of each element in the list
  to [PYTHONPATH][PYTHONPATH].

- `pythonPackage39` (`listOf package`):
  Append `/lib/python3.9/site-packages`
  of each element in the list
  to [PYTHONPATH][PYTHONPATH].

Inputs specific to [Node.js][NODE_JS]:

- `nodeBin` (`listOf package`):
  Append `/node_modules/.bin`
  of each element in the list
  to [PATH][PATH].

- `nodeModule` (`listOf package`):
  Append `/node_modules`
  of each element in the list
  to [NODE_PATH][NODE_PATH].

Example:

```nix
makeScript {
  name = "test-search-paths";
  searchPaths = {
    bin = [
      inputs.nixpkgs.git
    ];
  };
  entrypoint = ./entrypoint.sh;
}
```

Both `makeDerivation` and `makeScript`
support `makeSearchPaths`
via the `searchPaths` argument.

:construction: This section is Work in progress

# References

- [APACHE_ANT]: https://ant.apache.org/
  [Apache Ant][APACHE_ANT]

- [APACHE_MAVEN]: https://maven.apache.org/
  [Apache Maven][APACHE_MAVEN]

- [BASH]: https://www.gnu.org/software/bash/
  [Bash][BASH]

- [BLACK]: https://github.com/psf/black
  [Black][BLACK]

- [CALVER]: https://calver.org/
  [Calendar Versioning][CALVER]

- [CI_CD]: https://en.wikipedia.org/wiki/CI/CD
  [CI/CD][CI_CD]

- [CIRCLE_CI]: https://circleci.com/
  [Circle CI][CIRCLE_CI]

- [CLASSPATH]: https://en.wikipedia.org/wiki/Classpath
  [CLASSPATH Environment Variable][CLASSPATH]

- [COMMITLINT]: https://commitlint.js.org/#/
  [commitlint][COMMITLINT]

- [DOCKER]: https://www.docker.com/
  [Docker][DOCKER]

- [DOCTOC]: https://github.com/thlorenz/doctoc
  [DocToc][DOCTOC]

- [FLUID_ATTACKS]: https://fluidattacks.com
  [Fluid Attacks][FLUID_ATTACKS]

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

- [LEININGEN]: https://leiningen.org/
  [Leiningen][LEININGEN]

- [LINUX]: https://en.wikipedia.org/wiki/Linux
  [Linux][LINUX]

- [MAKES]: https://github.com/fluidattacks/makes
  [Makes][MAKES]

- [MAKES_RELEASES]: https://github.com/fluidattacks/makes/releases
  [Makes Releases][MAKES_RELEASES]

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

- [NIX_PKGS_FMT]: https://github.com/nix-community/nixpkgs-fmt
  [nixpkgs-fmt][NIX_PKGS_FMT]

- [NODE_JS]: https://nodejs.org/en/
  [NODE_JS][NODE_JS]

- [NODE_PATH]: https://nodejs.org/api/modules.html
  [NODE_PATH][NODE_PATH]

- [OCI_FORMAT_REPO]: https://github.com/opencontainers/image-spec
  [Open Container Image specification][OCI_FORMAT_REPO]

- [PACKER]: https://www.packer.io/
  [Packer][PACKER]

- [PATH]: https://en.wikipedia.org/wiki/PATH_(variable)
  [PATH Environment Variable][PATH]

- [PROSPECTOR]: http://prospector.landscape.io/en/master/
  [Prospector][PROSPECTOR]

- [PYTHON]: https://www.python.org/
  [Python][PYTHON]

- [PYTHONPATH]: https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH
  [PYTHONPATH Environment Variable][PYTHONPATH]

- [REPRODUCIBLE_BUILDS]: https://reproducible-builds.org/
  [Reproducible Builds][REPRODUCIBLE_BUILDS]

- [RPATH]: https://en.wikipedia.org/wiki/Rpath
  [RPath][RPATH]

- [SBT]: https://www.scala-sbt.org/
  [sbt][SBT]

- [SHELLCHECK]: https://github.com/koalaman/shellcheck
  [ShellCheck][SHELLCHECK]

- [SHFMT]: https://github.com/mvdan/sh
  [SHFMT][SHFMT]

- [TRAVIS_CI]: https://travis-ci.org/
  [Travis CI][TRAVIS_CI]

- [TRAVIS_CI_REF]: https://config.travis-ci.com/
  [Travis CI reference][TRAVIS_CI_REF]

- [TRAVIS_ENV_VARS]: https://docs.travis-ci.com/user/environment-variables
  [Travis Environment Variables][TRAVIS_ENV_VARS]

- [X86_64]: https://en.wikipedia.org/wiki/X86-64
  [x86-64][X86_64]
