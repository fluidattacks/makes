# Makes

A SecDevOps framework
powered by [Nix](https://nixos.org).

Our primary goal is to help you setup
a powerful [CI/CD](https://en.wikipedia.org/wiki/CI/CD) system
in just a few steps, in any technology.

We strive for:
- Simplicity: Easy setup with:
  a laptop, or
  [Docker](https://www.docker.com/), or
  [GitHub Actions](https://github.com/features/actions), or
  [Gitlab CI](https://docs.gitlab.com/ee/ci/), or
  [Travis CI](https://travis-ci.org/), or
  [Circle CI](https://circleci.com/),
  and more!
- Sensible defaults: **Good for all** projects of any size, **out-of-the-box**.
- Reproducibility: **Any member** of your team,
  day or night, yesterday and tomorrow, builds and get **exactly the same results**.
- Dev environments: **Any member** of your team with a Linux machine and
  the required secrets **can execute the entire CI/CD pipeline**.
- Performance: A highly granular **caching** system so you only have to **build things once**.
- Extendibility: You can add custom workflows, easily.
- Modularity: You opt-in only for what you need.

# Getting started

1.  Install Nix as explained
    in the [NixOS Download page](https://nixos.org/download).

1.  Install Makes:

    `$ nix-env -if https://fluidattacks.com/makes/install`

1.  Setup Makes in your project:

    1.  Locate in the root of your project:

        `$ cd /path/to/my/awesome/project`
    2.  Create a `makes` folder.

        `$ mkdir makes`

        We will place in this folder
        all the source code
        for the CI/CD system
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

        We have tens of CI/CD actions
        that you can include in jour project as simple as this.

    1.  Now run makes!

        - List all available commands: `$ m`

          ```
          Outputs list for project: ./
            .helloWorld
          ```

        - Run a command: `$ m .helloWorld`

          ```
          [INFO] Hello from Makes! Jane Doe.
          [INFO] You called us with CLI arguments: [ ].
          ```

        - Run a command with arguments: `$ m .helloWorld 1 2 3`

          ```
          [INFO] Hello from Makes! Jane Doe.
          [INFO] You called us with CLI arguments: [ 1 2 3 ].
          ```

# Makes configuration options (makes.nix)

## deployContainerImage

Deploy a set of container images in [OCI Format][OCI_FORMAT_REPO]
to the specified container registries.

Attributes:
- enable (boolean): Optional.
  Defaults to false.
- images (attrsOf imageType): Optional.
  Definitions of container images to deploy.
  Defaults to `{ }`.

Custom Types:
- imageType (submodule):
  - registry (enum ["docker.io" "registry.gitlab.com"]):
    Registry in which the image will be copied to.
  - src (package):
    Derivation that contains the container image in [OCI Format][OCI_FORMAT_REPO].
  - tag (str):
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

Ensure that bash code is formatted according to [shfmt](https://github.com/mvdan/sh).
It helps your code be consistent, beautiful and more maintainable.

Attributes:
- enable (boolean): Optional.
  Defaults to false.
- targets (listOf str): Optional.
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
- enable (boolean): Optional.
  Defaults to false.
- name (string): Required.
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



[OCI_FORMAT_REPO]: https://github.com/opencontainers/image-spec
