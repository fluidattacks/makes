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

```nix
# /path/to/my/project/makes/example/main.nix
{ libGit
, makeScript
, ...
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

```bash
$ m . /example

    [CRITICAL] We require a git repository, but this one is not: /some-path-that-do-not-exists
```
