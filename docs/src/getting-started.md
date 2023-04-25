# Getting started

## Installation

1. [Install Nix](https://nixos.org/download).

    ???+ tip

        We recommend getting the Single-user installation
        if you're new to Nix.

1. Install Makes:

    ```bash
    nix-env -if https://github.com/fluidattacks/makes/archive/23.04.tar.gz
    ```

## Usage

### Using the CLI

The Makes command has the following syntax:

```bash
m <repo> <job>
```

where:

- `<repo>` is a GitHub, GitLab or local repository.
- `<job>` is a Makes job
    that exists within the referenced repository.
    If no job is specified,
    Makes displays all available jobs.

Example:

=== "GitHub"

    ```bash
    m github:fluidattacks/makes@main
    ```

=== "GitLab"

    ```bash
    m gitlab:fluidattacks/makes-example-2@main
    ```

=== "Local"

    ```bash
    m /path/to/local/repo
    ```

Makes is powered by [Nix](https://nixos.org).
This means that it is able to run
on any of the
[Nix's supported platforms](https://nixos.org/manual/nix/unstable/installation/supported-platforms.html).

We have **thoroughly** tested it in
x86_64 hardware architectures
running Linux and MacOS (darwin) machines.

### Using the container

A Makes container can be found
in the [container registry](https://github.com/fluidattacks/makes/pkgs/container/makes).

You can use it
to run Makes on any service
that supports containers,
including most CI/CD providers.

Example:

=== "GitHub Actions"

    ```yaml
    # .github/workflows/dev.yml
    name: Makes CI
    on: [push, pull_request]
    jobs:
      helloWorld:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@f095bcc56b7c2baf48f3ac70d6d6782f4f553222
          - uses: docker://ghcr.io/fluidattacks/makes/amd64:23.04
            name: helloWorld
            with:
              args: m . /helloWorld 1 2 3
    ```

=== "GitLab CI"

    ```yaml
    # .gitlab-ci.yml
    /helloWorld:
      image: ghcr.io/fluidattacks/makes/amd64:23.04
      script:
        - m . /helloWorld 1 2 3
    ```

=== "Travis CI"

    ```yaml
    # .travis.yml
    os: linux
    language: nix
    nix: 2.3.12
    install: nix-env -if https://github.com/fluidattacks/makes/archive/23.04.tar.gz
    jobs:
      include:
        - script: m . /helloWorld 1 2 3
    ```

### Importing via Nix

You can also import Makes from Nix:

```nix
let
  # Import the framework
  makes = import "${builtins.fetchGit {
    url = "https://github.com/fluidattacks/makes";
    ref = "refs/tags/23.04";
    rev = ""; # Add a commit here
  }}/src/args/agnostic.nix" { };
in
# Use the framework
makes.makePythonPypiEnvironment {
  name = "example";
  sourcesYaml = ./sources.yaml;
}
```

Most functions documented in the [api/extensions](api/extensions/) section
are available.

For a detailed list check out
[Makes' agnostic args](https://github.com/fluidattacks/makes/blob/main/src/args/agnostic.nix).

## Want to get your hands dirty?

Jump right into our [hands-on example](https://github.com/fluidattacks/makes-example)!
