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
    - withSetuptools_67_7_2 (`bool`): Optional.
        Bootstrap setuptools 67.7.2 to the environment
        Defaults to `false`.
    - withSetuptoolsScm_7_1_0 (`bool`) Optional.
        Bootstrap setuptools-scm 7.1.0 to the environment
        Defaults to `false`.
    - withWheel_0_40_0 (`bool`): Optional.
        Bootstrap wheel 0.40.0 to the environment
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
      withSetuptools_67_7_2 = true;
      withSetuptoolsScm_7_1_0 = true;
      withWheel_0_40_0 = true;
    }
    ```

???+ tip

    Refer to [makePythonLock](/api/builtins/utilities/#makepythonlock)
    to learn how to generate a `sourcesYaml`.

## makePythonPyprojectPackage

Create a python package bundle using nixpkgs build functions.
This bundle includes the package itself, some modifications
over the tests and its python environments.

Types:

- makePythonPypiEnvironment: (`function Input -> Bundle`):
  - Input: `AttrsOf`
    - buildEnv: `function {...} -> Derivation`
      The nixpkgs buildEnv.override function.
      Commonly found at `nixpkgs."${python_version}".buildEnv.override`
    - buildPythonPackage: `function {...} -> Derivation`
      The nixpkgs buildPythonPackage function.
      Commonly found at `nixpkgs."${python_version}".pkgs.buildPythonPackage`
    - pkgDeps: `AttrsOf`
      The package dependencies.
      Usually other python packages build with nix,
      but can be also a nix derivation of a binary.
      - runtime_deps: `List[Derivation]`
      - build_deps: `List[Derivation]`
      - test_deps: `List[Derivation]`
    - src: `NixPath`
      The nix path to the source code of the python package.
      i.e. not only be the package itself, it should also contain
      a tests folder/module, the pyproject conf and any other meta-package
      data that the build or tests requires (e.g. custom mypy conf).
  - Bundle: `AttrsOf`
    - check: `AttrsOf`
      Builds of the package only including one test.
      - tests:`Derivation`
      - types: `Derivation`
    - env: `AttrsOf`
      - dev: `Derivation`
        The python environment containing only
        runtime_deps and test_deps
      - runtime: `Derivation`
        The python environment containing only
        the package itself and its runtime_deps.
    - pkg: `Derivation`
      The output of the nixpkgs buildPythonPackage function
      i.e. the python package

???+ tip

    The default implemented tests require `mypy` and `pytest` as `test_deps`.
    If you do not want the default, you can override the checkPhase
    of the package i.e. using `pythonOverrideUtils` or using the
    `overridePythonAttrs` function included on the derivation of
    nix built python packages.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      inputs,
      makeScript,
      makePythonPyprojectPackage,
      ...
    }: let
      nixpkgs = inputs.nixpkgs;
      python_version = "python311";
      python_pkgs = nixpkgs."${python_version}Packages";
      bundle = makePythonPyprojectPackage {
        src = ./.;
        buildEnv = nixpkgs."${python_version}".buildEnv.override;
        buildPythonPackage = nixpkgs."${python_version}".pkgs.buildPythonPackage;
        pkgDeps = {
          runtime_deps = with python_pkgs; [click];
          build_deps = with python_pkgs; [flit-core];
          test_deps = with python_pkgs; [
            mypy
            pytest
          ];
        };
      };
      env = bundle.env.runtime;
    in
      makeScript {
        name = "my-cli";
        searchPaths = {
          bin = [
            env
          ];
        };
        entrypoint = "my-cli \"\${@}\"";
        # Assuming that the pyproject conf has
        # a definition of `my-cli` as a cli entrypoint
      }
    ```

???+ tip

    Because env.runtime include the package,
    all tests are triggered when building the environment.
    If is desirable only to trigger an specific check phase,
    then use the check derivations that override this phase.

???+ tip

    To avoid performance issues use a shared cache
    system (e.g. cachix) or an override over the package
    to skip tests (unsafe way) to ensure that tests are
    executed only once (or never).
    This can also help on performance over heavy
    compilation/build processes.
