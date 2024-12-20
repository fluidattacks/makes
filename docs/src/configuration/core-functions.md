# Core functions

You may have noticed that all previous examples
used a function called `makeScript`.

This function is part of a set of builtins
that will allow you to define makes jobs.

## makeSearchPaths

On Linux
software dependencies
can be located anywhere in the file system.

We can control where
programs find other programs,
dependencies, libraries, etc,
through special environment variables.

Below we describe shortly the purpose
of the environment variables we currently support.

- [CLASSPATH](https://www.javatpoint.com/how-to-set-classpath-in-java):
    Location of user-defined classes and packages.
- [CRYSTAL_LIBRARY_PATH](https://crystal-lang.org/reference/guides/static_linking.html):
    Location of Crystal libraries.
- [GEM_PATH](https://guides.rubygems.org/command-reference):
    Location of libraries for Ruby.
- [LD_LIBRARY_PATH](https://linuxhint.com/what-is-ld-library-path/):
    Location of libraries for Dynamic Linking Loaders.
- [MYPYPATH](https://mypy.readthedocs.io/en/stable/running_mypy.html):
    Location of library stubs and static types
    for [MyPy](https://mypy.readthedocs.io/en/stable/).
- [NODE_PATH](https://nodejs.org/api/modules.html):
    Location of Node.js modules.
- [OCAMLPATH](https://github.com/ocaml/ocaml/issues/8898):
    Location of OCaml libraries.
- [CAML_LD_LIBRARY_PATH](https://ocaml.org/manual/runtime.html):
    Location of OCaml stublibs.
- [PATH](https://opensource.com/article/17/6/set-path-linux):
    Location of directories where executable programs are located.
- [PKG_CONFIG_PATH](https://linux.die.net/man/1/pkg-config):
    Location of pkg-config packages.
- [PYTHONPATH](https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH):
    Location of Python modules and site-packages.

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

Types:

- makeSearchPaths (`function { ... } -> package`):
    - `bin` (`listOf coercibleToStr`): Optional.
        Append `/bin`
        of each element in the list
        to PATH.
        Defaults to `[ ]`.
    - `rpath` (`listOf coercibleToStr`): Optional.
        Append `/lib` and `/lib64`
        of each element in the list
        to LD_LIBRARY_PATH.
        Defaults to `[ ]`.
    - `source` (`listOf coercibleToStr`): Optional.
        Source (as in Bash's `source` command)
        each element in the list.
        Defaults to `[ ]`.

Types specific to Crystal:

- makeSearchPaths (`function { ... } -> package`):
    - `crystalLib` (`listOf coercibleToStr`): Optional.
        Append `/lib`
        of each element in the list
        to CRYSTAL_LIBRARY_PATH.
        Defaults to `[ ]`.

Types specific to Java:

- makeSearchPaths (`function { ... } -> package`):
    - `javaClass` (`listOf coercibleToStr`): Optional.
        Append each element in the list
        to CLASSPATH.
        Defaults to `[ ]`.

Types specific to Kubernetes:

- makeSearchPaths (`function { ... } -> package`):
    - `kubeConfig` (`listOf coercibleToStr`): Optional.
        Append each element in the list
        to [KUBECONFIG](https://kubernetes.io/docs/concepts/configuration/).
        Defaults to `[ ]`.

Types specific to pkg-config:

- makeSearchPaths (`function { ... } -> package`):
    - `pkgConfig` (`listOf coercibleToStr`): Optional.
        Append `/lib/pkgconfig`
        of each element in the list
        to PKG_CONFIG_PATH.
        Defaults to `[ ]`.

Types specific to OCaml:

- makeSearchPaths (`function { ... } -> package`):
    - `ocamlBin` (`listOf coercibleToStr`): Optional.
        Append `/bin`
        of each element in the list
        to PATH.
        Defaults to `[ ]`.
    - `ocamlLib` (`listOf coercibleToStr`): Optional.
        Append `/`
        of each element in the list
        to OCAMLPATH.
        Defaults to `[ ]`.
    - `ocamlStublib` (`listOf coercibleToStr`): Optional.
        Append `/stublib`
        of each element in the list
        to CAML_LD_LIBRARY_PATH.
        Defaults to `[ ]`

Types specific to Python:

- makeSearchPaths (`function { ... } -> package`):
    - `pythonMypy` (`listOf coercibleToStr`): Optional.
        Append `/`
        of each element in the list
        to MYPYPATH.
        Defaults to `[ ]`.
    - `pythonMypy39` (`listOf coercibleToStr`): Optional.
        Append `/lib/python3.9/site-packages`
        of each element in the list
        to MYPYPATH.
        Defaults to `[ ]`.
    - `pythonMypy310` (`listOf coercibleToStr`): Optional.
        Append `/lib/python3.10/site-packages`
        of each element in the list
        to MYPYPATH.
        Defaults to `[ ]`.
    - `pythonMypy311` (`listOf coercibleToStr`): Optional.
        Append `/lib/python3.11/site-packages`
        of each element in the list
        to MYPYPATH.
        Defaults to `[ ]`.
    - `pythonPackage` (`listOf coercibleToStr`): Optional.
        Append `/`
        of each element in the list
        to PYTHONPATH.
        Defaults to `[ ]`.
    - `pythonPackage39` (`listOf coercibleToStr`): Optional.
        Append `/lib/python3.9/site-packages`
        of each element in the list
        to PYTHONPATH.
        Defaults to `[ ]`.
    - `pythonPackage310` (`listOf coercibleToStr`): Optional.
        Append `/lib/python3.10/site-packages`
        of each element in the list
        to PYTHONPATH.
        Defaults to `[ ]`.
    - `pythonPackage311` (`listOf coercibleToStr`): Optional.
        Append `/lib/python3.11/site-packages`
        of each element in the list
        to PYTHONPATH.
        Defaults to `[ ]`.

Types specific to Node.js:

- makeSearchPaths (`function { ... } -> package`):
    - `nodeBin` (`listOf coercibleToStr`): Optional.
        Append `/.bin`
        of each element in the list
        to PATH.
        Defaults to `[ ]`.
    - `nodeModule` (`listOf coercibleToStr`): Optional.
        Append `/`
        of each element in the list
        to NODE_PATH.
        Defaults to `[ ]`.

Types specific to Ruby:

- makeSearchPaths (`function { ... } -> package`):
    - `rubyBin` (`listOf coercibleToStr`): Optional.
        Append `/bin`
        of each element in the list
        to PATH.
        Defaults to `[ ]`.
    - `rubyGemPath` (`listOf coercibleToStr`): Optional.
        Append `/`
        of each element in the list
        to GEM_PATH.
        Defaults to `[ ]`.

Types for non covered cases:

- makeSearchPaths (`function { ... } -> package`):
    - `export` (`listOf (tuple [ str coercibleToStr str ])`): Optional.
        Export (as in Bash's `export` command)
        each tuple in the list.

        Defaults to `[ ]`.

        Tuples elements are:

        - Name of the environment variable to export.
        - Base package to export from.
        - Relative path with respect to the package that should be appended.

Example:

=== "makes.nix"

    ```nix
    { inputs, makeSearchPaths, ... }:
    {
      jobs."mySearchPaths" = makeSearchPaths {
        bin = [ inputs.nixpkgs.git ];
        source = [
          [ ./template.sh "a" "b" "c" ]
          # add more as you need ...
        ];
        export = [
          [ "PATH" inputs.nixpkgs.bash "/bin"]
          [ "CPATH" inputs.nixpkgs.glib.dev "/include/glib-2.0"]
          # add more as you need ...
        ];
      };
    }
    ```

=== "template.sh"

    ```bash
    # /path/to/my/project/makes/example/template
    echo "${@}"
    ```

=== "Equals to"

    ```bash
    export PATH"/nix/store/...-git/bin${PATH:+:}${PATH:-}"
    export PATH="/nix/store/...-bash/bin${PATH:+:}${PATH:-}"
    export CPATH="/nix/store/...-glib-dev/include/glib-2.0${CPATH:+:}${CPATH:-}"

    if test -e "/nix/store/...-template/template"
    then source "/nix/store/...-template/template" '1' '2' '3'
    else source "/nix/store/...-template" '1' '2' '3'
    fi
    ```

## makeDerivation

Perform a build step in an **isolated** environment:

- External environment variables are not visible by the builder script.
    This means you **can't** use secrets here.
- Search Paths as in `makeSearchPaths` are completely empty.
- The `HOME` environment variable is set to `/homeless-shelter`.
- Only [GNU coreutils][gnu_coreutils] commands (cat, echo, ls, ...)
    are present by default.
- An environment variable called `out` is present
    and represents the derivation's output.
    The derivation **must** produce an output,
    may be a file, or a directory.
- Convenience bash functions are exported:
    - `echo_stderr`: Like `echo` but to standard error.
    - `debug`: Like `echo_stderr` but with a `[DEBUG]` prefix.
    - `info`: Like `echo_stderr` but with a `[INFO]` prefix.
    - `warn`: Like `echo_stderr` but with a `[WARNING]` prefix.
    - `error`: Like `echo_stderr` but with a `[ERROR]` prefix.
        Returns exit code 1 to signal failure.
    - `critical`: Like `echo_stderr` but with a `[CRITICAL]` prefix.
        Exits immediately with exit code 1, aborting the entire execution.
    - `copy`: Like `cp` but making paths writeable after copying them.
    - `require_env_var`: `error`s when the specified env var is not set,
        or set to an empty value.

        ```bash
        require_env_var USERNAME
        ```

- After the build, for all paths in `$out`:
    - User and group ownership are removed
    - Last-modified timestamps are reset to `1970-01-01T00:00:00+00:00`.

Types:

- makeDerivation (`function { ... } -> package`):
    - builder (`either str package`):
        A Bash script that performs the build step.
    - env (`attrsOf str`): Optional.
        Environment variables that will be propagated to the `builder`.
        Variable names must start with `env`.
        Defaults to `{ }`.
    - local (`bool`): Optional.
        Should we always build locally this step?
        Thus effectively ignoring any configured binary caches.
        Defaults to `false`.
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.

Example:

=== "makes.nix"

    ```nix
    { inputs, makeDerivation, ... }:
    {
      jobs."myDerivation" = makeDerivation {
        env.envVersion = "1.0";
        builder = ''
          debug Version is $envVersion
          info Running tree command on $PWD
          mkdir dir
          touch dir/file
          tree dir > $out
        '';
        name = "myDerivation";
        searchPaths.bin = [ inputs.nixpkgs.tree ];
      };
    }
    ```

## makeTemplate

Replace placeholders with the specified values
in a file of any format.

Types:

- makeTemplate (`function { ... } -> package`):
    - local (`bool`): Optional.
        Should we always build locally this step?
        Thus effectively ignoring any configured binary caches.
        Defaults to `true`.
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - replace (`attrsOf strLike`): Optional.
        Placeholders will be replaced in the script with their respective value.
        Variable names must start with `__arg`, end with `__`
        and have at least 6 characters long.
        Defaults to `{ }`.
    - template (`either str package`):
        A string, file, output or package
        in which placeholders will be replaced.

Example:

=== "makes.nix"

    ```nix
    { inputs, makeTemplate, ... }:
    {
      jobs."myTemplate" = makeTemplate {
        name = "example";
        replace = {
          __argBash__ = inputs.nixpkgs.bash;
          __argVersion__ = "1.0";
        };
        template = ''
          Bash is: __argBash__
          Version is: __argVersion__
        '';
      };
    }
    ```

## makeScript

Wrap a Bash script
that runs in a **almost-isolated** environment.

- The file system is **not** isolated, the script runs in user-space.
- External environment variables are visible by the script.
    You can use this to propagate secrets.
- Search Paths as in `makeSearchPaths` are completely empty.
- The `HOME_IMPURE` environment variable is set to the user's home directory.
- The `HOME` environment variable is set to a temporary directory.
- Only [GNU coreutils][gnu_coreutils] commands (cat, echo, ls, ...)
    are present by default.
- An environment variable called `STATE` points to a directory
    that can be used to store the script's state (if any).
    That state can be optionally persisted.
    That state can be optionally shared across repositories.
- Convenience bash functions are exported:
    - `running_in_ci_cd_provider`:
        Detects if we are running on the CI/CD provider (gitlab/github/etc).

        ```bash
        if running_in_ci_cd_provider; then
          # ci/cd logic
        else
          # non ci/cd logic
        fi
        ```

    - `prompt_user_for_confirmation`:
        Warns the user about a possibly destructive action
        that will be executed soon
        and aborts if the user does not confirm aproppriately.

        This function assumes a positive answer
        when running on the CI/CD provider
        because there is no human interaction.
    - `prompt_user_for_input`:
        Ask the user to type information
        or optionally use a default value by pressing ENTER.

        This function assumes the default value
        when running on the CI/CD provider
        because there is no human interaction.

        ```bash
        user_supplied_input="$(prompt_user_for_input "default123123")"

        info Supplied input: "${user_supplied_input}"
        ```

- After the build, the script is executed.

Types:

- makeScript (`function { ... } -> package`):
    - entrypoint (`either str package`):
        A Bash script that performs the build step.
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - replace (`attrsOf strLike`): Optional.
        Placeholders will be replaced in the script with their respective value.
        Variable names must start with `__arg`, end with `__`
        and have at least 6 characters long.
        Defaults to `{ }`.
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.
    - persistState (`bool`): Optional.
        If true, state will _not_ be cleared before each script run.
        Defaults to `false`.
    - globalState (`bool`): Optional.
        If true, script state will be written to `globalStateDir` and
        to `projectStateDir` otherwise.
        Defaults to `false`, if `projectStateDir` is specified or derived.

        ???+ note

            - It is implicitly `true`, if `projectStateDir == globalStateDir`.
            - `projectStateDir == globalStateDir` is the default if
            `projectIdentifier` is not configured.
            - Hence, generally enable project local state by
                - either setting `projectIdentifier`
                - or `projectStateDir` different from `globalStateDir`.

Example:

=== "makes.nix"

    ```nix
    { inputs, makeScript, ... }:
    {
      jobs."myScript" = makeScript {
        replace.__argVersion__ = "1.0";
        entrypoint = ''
          debug Version is __argVersion__
          info pwd is $PWD
          info Running tree command on $STATE
          mkdir $STATE/dir
          touch $STATE/dir/file
          tree $STATE
        '';
        name = "example";
        searchPaths.bin = [ inputs.nixpkgs.tree ];
      };
    }
    ```

## projectPath

Copy a path from the current Makes project
being evaluated to the Nix store
in the **most** pure and reproducible way possible.

Types:

- projectPath (`function str -> package`):
    - (`str`):
        Absolute path, assumming the repository is located at `"/"`.

Example:

=== "makes.nix"

    ```nix
    # Consider the following path within the repository: /src/nix
    { makeScript, projectPath, ... }:
    {
      jobs."myProjectPath" = makeScript {
        replace = {
          __argPath__ = projectPath "/src/nix";
        };
        entrypoint = ''
          info Path is: __argPath__
          info Path contents are:
          ls __argPath__
        '';
        name = "myProjectPath";
      };
    }
    ```

[gnu_coreutils]: https://wiki.debian.org/coreutils
