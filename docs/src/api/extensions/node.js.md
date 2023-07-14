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
    - registryTokens (`attrsOf str`): Optional.
        Provide auth tokens for private NPM registries from environment variables.
        Defaults to `{ }`.

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

Example with private registries:

=== "package.json"

    ```json
    # /path/to/my/project/makes/example/package.json
    {
      "dependencies": {
        "@fortawesome/fontawesome-pro": "*"
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
        "@fortawesome/fontawesome-pro": {
          "version": "6.4.0",
          "resolved": "https://npm.fontawesome.com/@fortawesome/fontawesome-pro/-/6.4.0/fontawesome-pro-6.4.0.tgz",
          "integrity": "sha512-VtoAOuV0KAjdO979RHGko5krp3UsKMnXH1SaHnQvlz4PcgErcsk5ZPugoMhc3sW5lkrRl8NnaGwkGzB3gzVSxQ=="
        }
      }
    }
    ```

=== "main.nix"

    ```nix
    # /path/to/my/project/main.nix
    {
      makeNodeJsModules,
      makeScript,
      makeSecretForEnvFromSops,
      projectPath,
      ...
    }:
    let
      secrets = makeSecretForEnvFromSops {
        manifest = "/path/to/my/project/secrets.yaml";
        name = "example-secrets";
        vars = ["FONTAWESOME_NPM_AUTH_TOKEN"];
      }
      fontawesome = makeNodeJsModules {
        name = "fontawesome-pro-example";
        nodeJsVersion = "18";
        packageJson = projectPath "/path/to/my/project/package.json";
        packageLockJson = projectPath "/path/to/my/project/package-lock.json";
        registryTokens = {
          "npm.fontawesome.com": "FONTAWESOME_NPM_AUTH_TOKEN"
        };
        searchPaths.source = [ secrets ];
      };
    in
    makeScript {
      replace = {
        __argFontawesome__ = fontawesome;
      };
      entrypoint = ''
        ls __argFontawesome__
      '';
      name = "example";
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        @fortawesome
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
