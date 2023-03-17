## calculateCvss3

Calculate [CVSS3](https://www.first.org/cvss/v3.0/specification-document)
score and severity for a
[CVSS3 Vector String](https://www.first.org/cvss/v3.0/specification-document#Vector-String).

Types:

- calculateCvss3 (`function str -> package`):
    - (`str`):
        CVSS3 Vector String
        to calculate.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      makeScript,
      calculateCvss3,
      ...
    }:
    makeScript {
      replace = {
        __argCalculate__ = calculateCvss3
          "CVSS:3.0/S:C/C:H/I:H/A:N/AV:P/AC:H/PR:H/UI:R/E:H/RL:O/RC:R/CR:H/IR:X/AR:X/MAC:H/MPR:X/MUI:X/MC:L/MA:X";
      };
      entrypoint = ''
        cat "__argCalculate__"
      '';
      name = "example";
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        {"score": {"base": 6.5, "temporal": 6.0, "environmental": 5.3}, "severity": {"base": "Medium", "temporal": "Medium", "environmental": "Medium"}}
    ```

## chunks

Split a given list into N chunks
for workload distributed parallelization.

Types:

- chunks (`function list, ints.positive -> listOf (listOf Any)`):
    - (`list`):
        List to split into chunks.
    - (`ints.positive`):
        Number of chunks to create from list.

Example:

=== "main.nix"

    ```nix
    {
      chunks,
      inputs,
      makeDerivation,
      makeDerivationParallel,
      ...
    }: let
    numbers = [0 1 2 3 4 5 6 7 8 9];
    myChunks =  chunks numbers 3; # [[0 1 2 3] [4 5 6] [7 8 9]]

    buildNumber = n: makeDerivation {
      name = "build-number-${n}";
      env.envNumber = n;
      builder = ''
        echo "$envNumber"
        touch "$out"
      '';
    };
    in
      makeDerivationParallel {
        dependencies = builtins.map buildNumber (inputs.nixpkgs.lib.lists.elemAt myChunks 0);
        name = "build-numbers-0";
      }
    ```

## libGit

A small template for doing git kung-fu.

Types:

- libGit (`package`):
  A package that can be sourced to setup functions in the current scope.
  The list of available functions is documented below:
    - `is_git_repository`:
        Return 0 if the provided path is a git repository.

        ```bash
        if is_git_repository /path/to/anywhere; then
          # custom logic
        fi
        ```

    - `require_git_repository`:
        Stops the execution
        if the provided path is not a git repository.

        ```bash
        require_git_repository /path/to/anywhere
        ```

    - `get_abbrev_rev`:
        If available, returns an abbreviated name for the provided revision.
        Otherwise returns the revision unchanged.

        ```bash
        # Would return main, trunk, develop, etc
        get_abbrev_rev /path/to/anywhere HEAD
        ```

    - `get_commit_from_rev`:
        If available, returns the full commit of the provided revision.
        Otherwise returns an error.

        ```bash
        # Would return the full commit (e026a413...)
        get_commit_from_rev /path/to/anywhere HEAD
        ```

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      libGit,
      makeScript,
      ...
    }:
    makeScript {
      entrypoint = ''
        require_git_repository /some-path-that-do-not-exists

        echo other business logic goes here ...
      '';
      name = "example";
      searchPaths = {
        source = [ libGit ];
      };
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        [CRITICAL] We require a git repository, but this one is not: /some-path-that-do-not-exists
    ```

## makeSslCertificate

Self sign certificates
by using the `openssl req` command,
then using `openssl x509`
to print out the certificate
in text form.

Types:

- makeSslCertificate (`function { ... } -> package`):
    - days (`ints.positive`): Optional.
        Ammount of days to certify the certificate for.
        Defaults to `30`.
    - keyType (`str`): Optional.
        Defines the key type for the certificate
        (option used for the `-newkey` option on the `req` command).
        It uses the form `rsa:nbits`, where `nbits` is the number of bits.
        Defaults to `rsa:4096`.
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - options (`listOf (listOf str)`):
        Contains a list of options to create the certificate with your own needs.
        Here you can use the same options used with `openssl req`.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      makeScript,
      makeSslCertificate,
      ...
    }:
    let
      sslCertificate = makeSslCertificate {
        name = "name-example";
        options = [
          [ "-subj" "/CN=localhost" ]
        ];
      };
    in
    makeScript {
      replace = {
        __argSslCertificate__ = sslCertificate;
      };
      entrypoint = ''
        cat "__argSslCertificate__"
      '';
      name = "example";
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        -----BEGIN PRIVATE KEY-----
        ...
        -----END PRIVATE KEY-----
    ```

## pathShebangs

Replace common [shebangs](https://bash.cyberciti.biz/guide/Shebang)
for their Nix equivalent.

For example:

- `#! /bin/env xxx` -> `/nix/store/..-name/bin/xxx`
- `#! /usr/bin/env xxx` -> `/nix/store/..-name/bin/xxx`
- `#! /path/to/my/xxx` -> `/nix/store/..-name/bin/xxx`

Types:

- pathShebangs (`package`):
    When sourced,
    it exports a Bash function called `patch_shebangs`
    into the evaluation context.
    This function receives one or more files or directories as arguments
    and replace shebangs of the executable files in-place.
    Note that only shebangs that resolve to executables in the `"${PATH}"`
    (a.k.a. `searchPaths.bin`) will be taken into account.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      __nixpkgs__,
      makeDerivation,
      patchShebangs,
      ...
    }:
    makeDerivation {
      env = {
        envFile = builtins.toFile "my_file.sh" ''
          #! /usr/bin/env bash

          echo Hello!
        '';
      };
      builder = ''
        copy $envFile $out

        chmod +x $out
        patch_shebangs $out

        cat $out
      '';
      name = "example";
      searchPaths = {
        bin = [ __nixpkgs__.bash ]; # Propagate bash so `patch_shebangs` "sees" it
        source = [ patchShebangs ];
      };
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        #! /nix/store/dpjnjrqbgbm8a5wvi1hya01vd8wyvsq4-bash-4.4-p23/bin/bash

        echo Hello!
    ```

## sublist

Return a sublist of a given list using a starting and an ending index.

Types:

- sublist (`function list, ints.positive, ints.positive -> listOf Any`):
    - (`list`):
        List to get sublist from.
    - (`ints.positive`):
        Starting list index.
    - (`ints.positive`):
        Ending list index.

Example:

=== "main.nix"

    ```nix
    {
      sublist,
      ...
    }: let
      list = [0 1 2 3 4 5 6 7 8 9];
      sublist = sublist list 3 5; # [3 4]
    in {
      inherit sublist;
    }
    ```
