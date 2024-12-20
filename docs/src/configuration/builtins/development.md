## dev

Create declarative development environments.

Can be used with [direnv](https://direnv.net/)
to make your shell automatically load
the development environment and its required dependencies.

Types:

- dev (`attrsOf (asIn makeSearchPaths)`): Optional.
    Mapping of environment name to searchPaths.
    Defaults to `{ }`.

Example:

=== "makes.nix"

    ```nix
    {
      inputs,
      ...
    }: {
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

---

Example usage with direnv:

=== "On a remote project"

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

=== "On a local project"

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
