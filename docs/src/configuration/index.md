# Introduction

A Makes project is identified by a `makes.nix` file
in the top level directory.

Example:

=== "makes.nix"

    ```nix
    { makeScript, ... }: {
      imports = [
        ./another/subdirectory/makes.nix
      ];
      inputs = {
        nixpkgs = fetchNixpkgs {
          rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
          sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
        };
      };
      jobs = {
        "/helloWorld" = makeScript {
          name = "/helloWorld";
          entrypoint = "echo 'Hello World!'"
        };
      };
    }
    ```
