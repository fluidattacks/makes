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

=== "makes.nix"

    ```nix
    { libGit, makeScript, ... }:
    {
      jobs."myLibGit" = makeScript {
        entrypoint = ''
          require_git_repository /some-path-that-do-not-exists

          echo other business logic goes here ...
        '';
        name = "myLibGit";
        searchPaths.source = [ libGit ];
      };
    }
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

=== "makes.nix"

    ```nix
    { makeScript, makeSslCertificate, ... }:
    let
      sslCertificate = makeSslCertificate {
        name = "name-example";
        options = [
          [ "-subj" "/CN=localhost" ]
        ];
      };
    in
    {
      jobs."mySslCertificate" = makeScript {
        replace.__argSslCertificate__ = sslCertificate;
        entrypoint = ''
          cat "__argSslCertificate__"
        '';
        name = "mySslCertificate";
      };
    }
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

=== "makes.nix"

    ```nix
    { __nixpkgs__, makeDerivation, patchShebangs, ... }:
    {
      jobs."myPatchShebangs" = makeDerivation {
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
        name = "myPatchShebangs";
        searchPaths = {
          bin = [ __nixpkgs__.bash ]; # Propagate bash so `patch_shebangs` "sees" it
          source = [ patchShebangs ];
        };
      };
    }
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

=== "makes.nix"

    ```nix
    { sublist, ... }: let
      list = [0 1 2 3 4 5 6 7 8 9];
      sublist = sublist list 3 5; # [3 4]
    in {
      jobs."mySublist" = sublist;
    }
    ```
