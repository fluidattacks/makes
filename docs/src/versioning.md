# Versioning scheme

We use [calendar versioning](https://calver.org/) for stable releases.

Versioning is the same for both GitHub tags and Containers.

You can find
the full list of versions in the
[GitHub releases page](https://github.com/fluidattacks/makes/releases).

The Makes ecosystem has two components:
the framework itself, and the CLI (a.k.a. `$ m`).

## Stable releases

Stable releases are the ones that **do not have** the `Pre-release` label.
they are frozen.
We don't touch them under any circumstances.

## Unstable releases

Unstable releases are the ones
that **do have** the `Pre-release` label.
These releases have the latest Makes features
but can also come with breaking changes or bugs.

## Versioning scheme for the framework

You can ensure
that your project is always evaluated
with the same version of Makes
by creating a `makes.lock.nix` in the root of your project,
for instance:

```nix
# /path/to/my/project/makes.lock.nix
{
  makesSrc = builtins.fetchTarball {
    sha256 = ""; # Tarball sha256
    url = "https://api.github.com/repos/fluidattacks/makes/tarball/24.12";
  };
}
```

???+ tip

    We recommend using `builtins.fetchTarball`
    over `builtins.fetchGit`
    due to reproducibility issues
    mentioned in [nixpkgs](https://github.com/NixOS/nix/issues/3533).

## Compatibility information

For the whole ecosystem to work
you need to use the **same version**
of the framework and the CLI.
For example: `24.12`.
