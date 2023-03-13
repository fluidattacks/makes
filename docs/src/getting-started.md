# Getting started

## Installation

1.  [Install Nix](https://nixos.org/download).

    ???+ tip

        We recommend getting the Single-user installation
        if you're new to Nix.

1.  Install Makes:

    ```bash
    nix-env -if https://github.com/fluidattacks/makes/archive/23.04.tar.gz
    ```

## Usage

### Using the CLI

The Makes command has the following syntax:

```bash
$ m <repo> <job>
```

where:

- `<repo>` is a GitHub, GitLab or local repository.
- `<job>` is a Makes job
  that exists within the referenced repository.
  If no job is specified,
  Makes displays all available jobs.

You can try:

- `$ m github:fluidattacks/makes@main`
- `$ m github:fluidattacks/makes@main /helloWorld`
- `$ m gitlab:fluidattacks/makes-example-2@main`
- `$ m /path/to/local/repo`

Makes is powered by [Nix](https://nixos.org).
This means that it is able to run
on any of the
[Nix's supported platforms](https://nixos.org/manual/nix/unstable/installation/supported-platforms.html).

We have **thoroughly** tested it in
x86_64 hardware architectures
running Linux and MacOS (darwin) machines.

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

For a defailed list check out
[Makes' agnostic args](https://github.com/fluidattacks/makes/blob/main/src/args/agnostic.nix).

## Want to get your hands dirty?

Jump right into our [hands-on example](https://github.com/fluidattacks/makes-example)!
