## makeNodeJsModules

Cook the `node_modules` directory
for the given Node.js project
using [node2nix](https://github.com/svanderburg/node2nix).

Types:

- makeNodeJsModules (`function { ... } -> package`):
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - nodeJsVersion (`enum [ "18" ]`):
        Node.js version to use.
    - packageJson (`package`):
        Path to the `package.json` of your project.
    - packageLockJson (`package`):
        Path to the `package-lock.json` of your project.
    - packageOverrides (`Attrs`): Optional.
        Override behaviors when building `node_modules`.
        See [node2nix arguments](https://github.com/svanderburg/node2nix/blob/315e1b85a6761152f57a41ccea5e2570981ec670/nix/node-env.nix#L568)
        for more.

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
      inputs,
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
        packageOverrides = {
          # Ignore post-install scripts
          npmFlags = "--ignore-scripts true";
          # Provide patchelf when building node_modules
          buildInputs = [inputs.nixpkgs.patchelf];
        };
      };
    in
    makeScript {
      replace = {
        __argHello__ = hello;
      };
      entrypoint = ''
        ls __argHello__
        ls __argHello__/lib
      '';
      name = "example";
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        /bin /lib
        /node_modules
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
    - nodeJsVersion (`enum [ "18" ]`):
        Node.js version to use.
    - packageJson (`package`):
        Path to the `package.json` of your project.
    - packageLockJson (`package`):
        Path to the `package-lock.json` of your project.
    - packageOverrides (`Attrs`): Optional.
        Override behaviors when building `node_modules`.
        See [node2nix arguments](https://github.com/svanderburg/node2nix/blob/315e1b85a6761152f57a41ccea5e2570981ec670/nix/node-env.nix#L568)
        for more.

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
        packageOverrides = {
          # Ignore post-install scripts
          npmFlags = "--ignore-scripts true";
          # Provide patchelf when building node_modules
          buildInputs = [inputs.nixpkgs.patchelf];
        };
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
