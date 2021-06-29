# Makes

A SecDevOps framework
powered by [Nix][NIX].

Our primary goal is to help you setup
a powerful [CI/CD][CI_CD] system
in just a few steps, in any technology.

We strive for:
- Simplicity: Easy setup with:
  a laptop, or
  [Docker][DOCKER], or
  [GitHub Actions][GITHUB_ACTIONS], or
  [Gitlab CI][GITLAB_CI], or
  [Travis CI][TRAVIS_CI], or
  [Circle CI][CIRCLE_CI],
  and more!
- Sensible defaults: **Good for all** projects of any size, **out-of-the-box**.
- Reproducibility: **Any member** of your team,
  day or night, yesterday and tomorrow, builds and get **exactly the same results**.
- Dev environments: **Any member** of your team with a Linux machine and
  the required secrets **can execute the entire CI/CD pipeline**.
- Performance: A highly granular **caching** system so you only have to **build things once**.
- Extendibility: You can add custom workflows, easily.
- Modularity: You opt-in only for what you need.

# Table of contents

<!-- http://ecotrust-canada.github.io/markdown-toc -->

- [Getting started](#getting-started)
  * [Getting started as user](#getting-started-as-user)
  * [Getting started as developer](#getting-started-as-developer)
- [Configuring CI/CD](#configuring-ci-cd)
  - [Configuring CI/CD on Gitlab](#configuring-ci-cd-on-gitlab)
- [Makes.nix format](#makesnix-format)
  * [deployContainerImage](#deploycontainerimage)
  * [formatBash](#formatbash)
  * [helloWorld](#helloworld)

# Getting started

Makes is powered by [Nix][NIX].
It's capable of running in any system as long as it supports Nix.
We have thoroughly tested it in x86_64-linux machines.

In order to use Makes you'll need to:

1.  Install Nix as explained
    in the [NixOS Download page][NIX_DOWNLOAD].

1.  Install Makes:
    `$ nix-env -if https://fluidattacks.com/makes/install`

Makes targets two kind of users:
- Final users: People that want to use projects built with Makes.
- Developers: People who develop projects with Makes.

## Getting started as user

1.  Download the Makes project of your choice.

1.  `$ cd /path/to/an/awesome/makes/project`

1.  Now run makes!

    - List all available commands: `$ m`

      ```
      Outputs list for project: ./
        .helloWorld
      ```

    - Run a command: `$ m .helloWorld 1 2 3`

      ```
      [INFO] Hello from Makes! Jane Doe.
      [INFO] You called us with CLI arguments: [ 1 2 3 ].
      ```


## Getting started as developer

1.  Locate in the root of your project:

    `$ cd /path/to/my/awesome/makes/project`
2.  Create a `makes` folder.

    `$ mkdir makes`

    We will place in this folder
    all the source code
    for the [CI/CD][CI_CD] system
    (build, test, deploy, release, etc).

1.  Create a configuration file named `makes.nix`
    with the following contents:

    ```nix
    # /path/to/my/awesome/project/makes.nix
    {
      helloWorld = {
        enable = true;
        name = "Jane Doe";
      };
    }
    ```

    We have tens of [CI/CD][CI_CD] actions
    that you can include in jour project as simple as this.

1.  Now run makes!

    - List all available commands: `$ m`

      ```
      Outputs list for project: ./
        .helloWorld
      ```

    - Run a command: `$ m .helloWorld 1 2 3`

      ```
      [INFO] Hello from Makes! Jane Doe.
      [INFO] You called us with CLI arguments: [ 1 2 3 ].
      ```

# Configuring CI/CD

## Configuring CI/CD on Gitlab

[GitLab CI/CD][GITLAB_CI]
is configured through a [.gitlab-ci.yaml][GITLAB_CI_REF] file
located in the root of the project.

The smallest possible [.gitlab-ci.yaml][GITLAB_CI_REF]
would look like this:

```yaml
# /path/to/my/awesome/makes/project
helloWorld:
  image: registry.gitlab.com/fluidattacks/product/makes:foss
  script:
    - m .helloWorld 1 2 3
```

# Makes.nix format

A Makes project is identified by a `makes.nix` file
in the top level directory.

Below we document all configuration options you can tweak with it.

## deployContainerImage

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
  - registry (`enum ["docker.io" "registry.gitlab.com"]`):
    Registry in which the image will be copied to.
  - src (`package`):
    Derivation that contains the container image in [OCI Format][OCI_FORMAT_REPO].
  - tag (`str`):
    The tag under which the image will be stored in the registry.

Example `makes.nix`:

```nix
{ config
, ...
}:
{
  inputs = {
    nixpkgs = import <nixpkgs> { };
  };

  deployContainerImage = {
    enable = true;
    images = {
      nginxGitlab = {
        src = config.inputs.nixpkgs.dockerTools.examples.nginx;
        registry = "docker.io";
        tag = "fluidattacks/nginx:latest";
      };
      makesGitlab = {
        src = config.outputs."container-image";
        registry = "registry.gitlab.com";
        tag = "fluidattacks/product/makes:foss";
      };
    };
  };
```

Example invocation: `$ m .deployContainerImage.makesGitlab`

## formatBash

Ensure that bash code is formatted according to [shfmt][SHFMT].
It helps your code be consistent, beautiful and more maintainable.

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

Example invocation: `$ m .formatBash`

## helloWorld

Small command for demo purposes, it greets the specified user:

Attributes:
- enable (`boolean`): Optional.
  Defaults to false.
- name (`string`): Required.
  Name of the user to greet.

Example `makes.nix`:

```nix
{
  helloWorld = {
    enable = true;
    name = "Jane Doe";
  };
}
```

Example invocation: `$ m .helloWorld 1 2 3`

<!-- Links go here, so we can update them in this single place -->

[CI_CD]: https://en.wikipedia.org/wiki/CI/CD
[CIRCLE_CI]: https://circleci.com/
[DOCKER]: https://www.docker.com/
[GITHUB_ACTIONS]: https://github.com/features/actions
[GITLAB_CI]: https://docs.gitlab.com/ee/ci/
[GITLAB_CI_REF]: https://docs.gitlab.com/ee/ci/yaml/
[NIX]: https://nixos.org
[NIX_DOWNLOAD]: https://nixos.org/download
[OCI_FORMAT_REPO]: https://github.com/opencontainers/image-spec
[SHFMT]: https://github.com/mvdan/sh
[TRAVIS_CI]: https://travis-ci.org/
