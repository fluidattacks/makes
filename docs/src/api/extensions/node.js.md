## makeNodeJsVersion

Get a specific Node.js version interpreter.

Types:

- makeNodeJsVersion (`function str -> package`):
    - (`enum [ "14" "16" "18" ]`):
        Node.js version to use.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      makeNodeJsVersion,
      makeScript,
      ...
    }:
    makeScript {
      entrypoint = ''
        node --version
      '';
      name = "example";
      searchPaths = {
        bin = [ (makeNodeJsVersion "16") ];
      };
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        v16.2.0
    ```

## makeNodeJsModules

Cook the `node_modules` directory
for the given Node.js project.

Types:

- makeNodeJsModules (`function { ... } -> package`):
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - nodeJsVersion (`enum [ "14" "16" "18" ]`):
        Node.js version to use.
    - packageJson (`package`):
        Path to the `package.json` of your project.
    - packageLockJson (`package`):
        Path to the `package-lock.json` of your project.
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.
    - shouldIgnoreScripts (`bool`): Optional.
        Enable to propagate the `--ignore-scripts true` flag to npm.
        Defaults to `false`.

Example:

=== "package.json"

    ```json
    # /path/to/my/project/makes/example/package.json
    {
      "dependencies": {
        "hello-world-npm": "*"
      }
    }
    ```

=== "package-lock.json"

    ```json
    # /path/to/my/project/makes/example/package-lock.json
    {
      "requires": true,
      "lockfileVersion": 1,
      "dependencies": {
        "hello-world-npm": {
          "version": "1.1.1",
          "resolved": "https://registry.npmjs.org/hello-world-npm/-/hello-world-npm-1.1.1.tgz",
          "integrity": "sha1-JQgw7wAItDftk+a+WZk0ua0Lkwg="
        }
      }
    }
    ```

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      makeNodeJsModules,
      makeScript,
      projectPath,
      ...
    }:
    let
      hello = makeNodeJsModules {
        name = "hello-world-npm";
        nodeJsVersion = "16";
        packageJson =
          projectPath "/path/to/my/project/makes/example/package.json";
        packageLockJson =
          projectPath "/path/to/my/project/makes/example/package-lock.json";
      };
    in
    makeScript {
      replace = {
        __argHello__ = hello;
      };
      entrypoint = ''
        ls __argHello__
      '';
      name = "example";
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        hello-world-npm
    ```

## makeNodeJsEnvironment

Setup a `makeNodeJsModules` in the environment
using `makeSearchPaths`.
It appends:

- `node` to `PATH`.
- `node_modules/.bin` to `PATH`.
- `node_modules` to [NODE_PATH](https://nodejs.org/api/modules.html).

Pre-requisites:
[Generating a package-lock.json](/api/builtins/utilities#makenodejslock)

Types:

- makeNodeJsEnvironment (`function { ... } -> package`):
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - nodeJsVersion (`enum [ "14" "16" "18" ]`):
        Node.js version to use.
    - packageJson (`package`):
        Path to the `package.json` of your project.
    - packageLockJson (`package`):
        Path to the `package-lock.json` of your project.
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.
    - shouldIgnoreScripts (`bool`): Optional.
        Enable to propagate the `--ignore-scripts true` flag to npm.
        Defaults to `false`.

Example:

=== "package.json"

    ```json
    # /path/to/my/project/makes/example/package.json
    {
      "dependencies": {
        "hello-world-npm": "*"
      }
    }
    ```

=== "package-lock.json"

    ```json
    # /path/to/my/project/makes/example/package-lock.json
    {
      "requires": true,
      "lockfileVersion": 1,
      "dependencies": {
        "hello-world-npm": {
          "version": "1.1.1",
          "resolved": "https://registry.npmjs.org/hello-world-npm/-/hello-world-npm-1.1.1.tgz",
          "integrity": "sha1-JQgw7wAItDftk+a+WZk0ua0Lkwg="
        }
      }
    }
    ```

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      makeNodeJsEnvironment,
      makeScript,
      ...
    }:
    let
      hello = makeNodeJsEnvironment {
        name = "hello-world-npm";
        nodeJsVersion = "16";
        packageJson =
          projectPath "/path/to/my/project/makes/example/package.json";
        packageLockJson =
          projectPath "/path/to/my/project/makes/example/package-lock.json";
      };
    in
    makeScript {
      entrypoint = ''
        hello-world-npm
      '';
      name = "example";
      searchPaths = {
        source = [ hello ];
      };
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        Hello World NPM
    ```
