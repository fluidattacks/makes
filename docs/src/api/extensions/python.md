## makePythonVersion

Get a specific Python interpreter.

Types:

- makePythonVersion (`function str -> package`):
    - (`enum ["3.8" "3.9" "3.10" "3.11"]`):
        Python version of the interpreter to return.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      makePythonVersion,
      makeScript,
      ...
    }:
    makeScript {
      entrypoint = ''
        python --version
      '';
      name = "example";
      searchPaths = {
        bin = [ (makePythonVersion "3.8") ];
      };
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        Python 3.8.9
    ```

## makePythonPypiEnvironment

Create a virtual environment
where a provided set of Python packages
from [PyPi](https://pypi.org/)
is installed.

Pre-requisites:
[Generating a sourcesYaml](/api/builtins/utilities/#makepythonlock)

Types:

- makePythonPypiEnvironment (`function { ... } -> package`):
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - searchPathsBuild (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`
        and used while installing the Python dependencies.
        Defaults to `makeSearchPaths`'s defaults.
    - searchPathsRuntime (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`
        and propagated to the runtime environment.
        Defaults to `makeSearchPaths`'s defaults.
    - sourcesYaml (`package`):
        `sources.yaml` file
        computed as explained in the pre-requisites section.

  For building a few special packages you may need to boostrap
  dependencies in the build environment.
  The following flags are available for convenience:

    - withCython_0_29_24 (`bool`): Optional.
        Bootstrap cython 0.29.24 to the environment
        Defaults to `false`.
    - withNumpy_1_24_0 (`bool`): Optional.
        Bootstrap numpy 1.24.0 to the environment
        Defaults to `false`.
    - withSetuptools_57_4_0 (`bool`): Optional.
        Bootstrap setuptools 57.4.0 to the environment
        Defaults to `false`.
    - withSetuptoolsScm_5_0_2 (`bool`) Optional.
        Bootstrap setuptools-scm 5.0.2 to the environment
        Defaults to `false`.
    - withSetuptoolsScm_6_0_1 (`bool`) Optional.
        Bootstrap setuptools-scm 6.0.1 to the environment
        Defaults to `false`.
    - withWheel_0_37_0 (`bool`): Optional.
        Bootstrap wheel 0.37.0 to the environment
        Defaults to `false`.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      inputs,
      makePythonPypiEnvironment,
      projectPath,
      ...
    }:
    makePythonPypiEnvironment {
      name = "example";
      # If some packages require compilers to be built,
      # you can provide them like this:
      searchPathsBuild = {
        bin = [ inputs.nixpkgs.gcc ];
      };
      # You can propagate packages to the runtime environment if needed, too
      searchPathsRuntime = {
        bin = [ inputs.nixpkgs.htop ];
      };
      sourcesYaml = projectPath "/makes/example/sources.yaml";
      # Other packages require a few bootstrapped dependencies,
      # enable them like this:
      withCython_0_29_24 = true;
      withSetuptools_57_4_0 = true;
      withSetuptoolsScm_6_0_1 = true;
      withWheel_0_37_0 = true;
    }
    ```

???+ tip

    Refer to [makePythonLock](/api/builtins/utilities/#makepythonlock)
    to learn how to generate a `sourcesYaml`.
