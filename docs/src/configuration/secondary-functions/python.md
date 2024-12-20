## makePythonEnvironment

Create a source-able Python virtual environment using
[makePythonPoetryEnvironment](#makepythonpoetryenvironment).

Pre-requisites:
Having both `pyproject.toml` and `poetry.lock`.

Types:

- makePythonEnvironment: (`function { ... } -> package`):
    - pythonProjectDir (`path`): Required.
        Python project where both
        `pyproject.toml` and `poetry.lock`
        are located.
    - pythonVersion (`str`): Required.
        Python version used to build the environment.
        Supported versions are `3.9`, `3.10`, `3.11` and `3.12`.
    - preferWheels (`bool`): Optional.
        Use pre-compiled wheels from PyPI.
        Defaults to `true`.
    - overrides (`function {...} -> package`): Optional.
        Override build attributes for libraries within the environment.
        For more information see [here](https://github.com/nix-community/poetry2nix/blob/master/docs/edgecases.md).
        Defaults to `(self: super: {})`.

        ???+ note

            By default we override every python package deleting the
            `homeless-shelter` directory and changing the `HOME` variable,
            we make this to assure purity of builds without sandboxing.

Example:

=== "makes.nix"

    ```nix
    { makePythonEnvironment, projectPath, ... }:
    {
      jobs."myPythonEnvironment" = makePythonEnvironment {
        pythonProjectDir = projectPath "/makes/example";
        pythonVersion = "3.11";
        preferWheels = true;
        # Consider pygments requiring setuptools to build properly
        overrides = self: super: {
          pygments = super.pygments.overridePythonAttrs (
            old: {
              preUnpack =
                ''
                  export HOME=$(mktemp -d)
                  rm -rf /homeless-shelter
                ''
                + (old.preUnpack or "");
              buildInputs = [super.setuptools];
            }
          );
        };
      };
    }
    ```

???+ tip

    Refer to [makePythonLock](/api/builtins/utilities/#makepythonlock)
    to learn how to generate a `poetry.lock`.

## makePythonPoetryEnvironment

Create a Python virtual environment using
[poetry2nix](https://github.com/nix-community/poetry2nix/tree/74921da7e0cc8918adc2e9989bd3e9c127b25ff6).

Pre-requisites:
Having both `pyproject.toml` and `poetry.lock`.

Types:

- makePythonPoetryEnvironment: (`function { ... } -> poetry2nixBundle`):
    - pythonProjectDir (`path`): Required.
        Python project where both
        `pyproject.toml` and `poetry.lock`
        are located.
    - pythonVersion (`str`): Required.
        Python version used to build the environment.
        Supported versions are `3.9`, `3.10`, `3.11` and `3.12`.
    - preferWheels (`bool`): Optional.
        Use pre-compiled wheels from PyPI.
        Defaults to `true`.
    - overrides (`function {...} -> package`): Optional.
        Override build attributes for libraries within the environment.
        For more information see [here](https://github.com/nix-community/poetry2nix/blob/master/docs/edgecases.md).
        Defaults to `(self: super: {})`.

        ???+ note

            By default we override every python package deleting the
            `homeless-shelter` directory and changing the `HOME` variable,
            we make this to assure purity of builds without sandboxing.

Example:

=== "makes.nix"

    ```nix
    { makePythonPoetryEnvironment, projectPath, ... }:
    {
      jobs."myPythonPoetryEnvironment" = makePythonPoetryEnvironment {
        pythonProjectDir = projectPath "/makes/example";
        pythonVersion = "3.11";
        preferWheels = true;
        # Consider pygments requiring setuptools to build properly
        overrides = self: super: {
          pygments = super.pygments.overridePythonAttrs (
            old: {
              preUnpack =
                ''
                  export HOME=$(mktemp -d)
                  rm -rf /homeless-shelter
                ''
                + (old.preUnpack or "");
              buildInputs = [super.setuptools];
            }
          );
        };
      };
    }
    ```

???+ tip

    Refer to [makePythonLock](/api/builtins/utilities/#makepythonlock)
    to learn how to generate a `poetry.lock`.

## makePythonPyprojectPackage

Create a python package bundle using nixpkgs build functions.
This bundle includes the package itself, some modifications
over the tests and its python environments.

Types:

- makePythonPyprojectPackage: `Input -> Bundle`
- Input: `Attrs`
    - buildEnv: `Attrs -> PythonEnvDerivation`
        The nixpkgs buildEnv.override function.
        Commonly found at `nixpkgs."${python_version}".buildEnv.override`
    - buildPythonPackage: `Attrs -> PythonPkgDerivation`
        The nixpkgs buildPythonPackage function.
        Commonly found at `nixpkgs."${python_version}".pkgs.buildPythonPackage`
    - pkgDeps: `Attrs`
        The package dependencies.
        Usually other python packages build with nix,
        but can be also a nix derivation of a binary.

        - runtime_deps: `listOf Derivation`
        - build_deps: `listOf Derivation`
        - test_deps: `listOf Derivation`
    - src: `NixPath`
        The nix path to the source code of the python package.
        i.e. not only the package itself, it should also contain
        a tests folder/module, the pyproject conf and any other meta-package
        data that the build or tests requires (e.g. custom mypy conf).
- Bundle: `Attrs`
    - check: `Attrs`
        Builds of the package only including one test.
        - tests: `Derivation`
        - types: `Derivation`
    - env: `Attrs`
        - dev: `PythonEnvDerivation`
          The python environment containing only
          runtime_deps and test_deps
        - runtime: `PythonEnvDerivation`
          The python environment containing only
          the package itself and its runtime_deps.
    - pkg: `PythonPkgDerivation`
        The output of the nixpkgs buildPythonPackage function
        i.e. the python package

???+ tip

    The default implemented tests require `mypy` and `pytest` as `test_deps`.
    If you do not want the default, you can override the checkPhase
    of the package i.e. using `pythonOverrideUtils` or using the
    `overridePythonAttrs` function included on the derivation of
    nix built python packages.

Example:

=== "makes.nix"

    ```nix
    { inputs, makeScript, makePythonPyprojectPackage, ... }: let
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
      {
        jobs."myPythonPyprojectPackage" = makeScript {
          name = "myPythonPyprojectPackage";
          searchPaths.bin = [ env ];
          entrypoint = ''my-cli "$@"'';
          # Assuming that the pyproject conf has
          # a definition of `my-cli` as a cli entrypoint
        };
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

## makePythonVscodeSettings

Generate visual studio code configuration for python development.

Types:

- makePythonVscodeSettings: `Input -> SourceAble`
- `Input` = `Attrs`
    - name: `str`
    - env: `PythonEnvDerivation`
        A python environment derivation. e.g. can be builded from nixpkgs
        standard builders or from some `env` of the outputs of `makePythonPyprojectPackage`
    - bins: `listOf Derivation`
        Derivations to include on the `searchPaths.bins` input

Example:

=== "makes.nix"

    ```nix
    { inputs, makePythonPyprojectPackage, makePythonVscodeSettings, outputs, projectPath, ... }: let
      root = projectPath "/my_package";
      bundle = makePythonPyprojectPackage {
        inherit (inputs) buildEnv buildPythonPackage;
        pkgDeps = {
          runtime_deps = [];
          build_deps = [];
          test_deps = with inputs.python_pkgs; [
            mypy
            pytest
          ];
        };
        src = root;
      };
    in
      {
        jobs."myPythonVscodeSettings" = makePythonVscodeSettings {
          env = bundle.env.dev;
          bins = [];
          name = "my-package-env-dev";
        };
        dev.myPackage.source = [outputs."/my-env"];
      }
    ```

=== ".envrc"

    ```bash
    source "$(m . /dev/myPackage)/template"
    ```

## pythonOverrideUtils

Integrating python packages built with nix can create conflicts when
integrating various into one environment. This utils helps unifying
the dependencies into one and only one version per package.

Types:

- `PythonOverride` = `PythonPkgDerivation -> PythonPkgDerivation`
    A functions that creates a new modified `PythonPkgDerivation` from the original.

- pythonOverrideUtils: `Attrs`
    - compose: `(listOf functions) -> _A -> _Z`
        Function composition, the last function on the list is the first applied.
        For each function `_R -> _S` on the list, its predecessor must match
        their domain with the range of the function i.e. `_S -> _T`.
    - no_check_override: `PythonOverride`
        Skips the python package tests that are triggered on the build process.
        This override is defined through `recursive_python_pkg_override`.
    - recursive_python_pkg_override: `(Derivation -> bool) -> PythonOverride -> PythonOverride`
        Search over all the tree of sub-dependencies the derivation
        that evaluates to true as defined by the supplied first argument
        filter `Derivation -> bool`.
        If match, the supplied `PythonOverride` (second arg) is applied.
    - replace_pkg: `(listOf str) -> PythonPkgDerivation -> PythonOverride`
        Replace all python packages that match the supplied list of names,
        with the supplied python package.
        The returned override is defined through `recursive_python_pkg_override`
