# Getting started

## Installation

1. [Install Nix](https://nixos.org/download).

    ???+ tip

        We recommend getting the Multi-user installation
        for compatibility.

1. Install Makes:

    ```bash
    nix-env -if https://github.com/fluidattacks/makes/archive/24.12.tar.gz
    ```

## Quickstart

1. Create a `makes.nix` file in your project root:

    === "makes.nix"

    ```nix
    { makeScript, ...}: {
      jobs = {
        "/helloWorld" = makeScript {
          name = "helloWorld";
          entrypoint = "echo 'Hello World!'";
        };
      };
    }
    ```

2. Invoke it with the `m` command while standing in the project root:

    ```bash
    m . /helloWorld
    ```

3. Explore [Essentials](/configuration/essentials/)
   and [Core functions](/configuration/core-functions/)
   for more complex cases
   like creating production/development environments,
   and CI/CD jobs.

4. Explore [CLI](/running-makes/cli/)
    and [Container](/running-makes/container/)
    for invoking makes in different scenarios and environments.

## Importing via Nix

You can also import Makes from Nix:

```nix
let
  # Import the framework
  makes = import "${builtins.fetchTarball {
    sha256 = ""; # Tarball sha256
    url = "https://api.github.com/repos/fluidattacks/makes/tarball/24.12";
  }}/src/args/agnostic.nix" { };
in
# Use the framework
makes.makePythonEnvironment {
  pythonProjectDir = ./.;
  pythonVersion = "3.11";
}
```

For a detailed list of available utilities check out
[Makes' agnostic args](https://github.com/fluidattacks/makes/blob/main/src/args/agnostic.nix).
