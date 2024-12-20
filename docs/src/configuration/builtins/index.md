# Introduction

Builtins offer out-of-the-box functionality
for specific tasks
like linting, testing, and more.

???+ warning

    Makes is currently moving to a lean-core architecture,
    meaning that most builtins
    will be deprecated in the future
    in favor of a plugins approach.

    Builtins
    can be replaced by nixpkgs functions
    or implementations using core functions.

Builtins can be invoked from `makes.nix` files
without having to import them. Example:

=== "makes.nix"

    ```nix
    {
      formatNix = {
        enable = true;
        targets = [ "/" ];
      };
    }
    ```
