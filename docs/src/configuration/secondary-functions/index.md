# Introduction

Makes also supports secondary functions
for more specific tasks
like creating containers,
setting up language-specific environments,
and more.

???+ warning

    Makes is currently moving to a lean-core architecture,
    meaning that most secondary functions
    will be deprecated in the future
    in favor of a plugins approach.

    Secondary functions
    can be replaced by nixpkgs functions
    or implementations using core functions.


Secondary functions can be used for jobs. Example:

=== "makes.nix"

    ```nix
    { makePythonEnvironment, projectPath, ... }:
    {
      jobs = {
        "/myPythonEnvironment" = makePythonEnvironment {
          pythonProjectDir = projectPath "/my/python/project";
          pythonVersion = "3.11";
        };
      };
    }
    ```
