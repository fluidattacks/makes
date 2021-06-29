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

    `$ nix-env -if https://github.com/fluidattacks/makes/archive/main.tar.gz`

1.  Setup Makes in your project:

    1.  Locate in the root of your project:

        `$ cd /path/to/my/awesome/project`
    2.  Create a `makes` folder.

        `$ mkdir makes`

        We will place in this folder
        all the source code
        for the CI/CD system
        (build, test, deploy, release, etc).

    1.  Create a configuration file at `makes/config.nix`
        with the following contents:

        ```nix
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
