## makeRubyVersion

Get a specific Ruby interpreter.

Types:

- makeRubyVersion (`function str -> package`):
    - (`enum [ "2.7" "3.0" "3.1" ]`):
        Version of the Ruby interpreter.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      makeRubyVersion,
      makeScript,
      ...
    }:
    makeScript {
      entrypoint = ''
        ruby --version
      '';
      name = "example";
      searchPaths = {
        bin = [ (makeRubyVersion "2.7") ];
      };
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        ruby 2.6.8p205 (2021-07-07) [x86_64-linux]
    ```

## makeRubyGemsInstall

Fetch and install the specified Ruby gems
from the [RubyGems][rubygems].

Types:

- makeRubyGemsInstall (`function { ... } -> package`):
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - ruby (`enum [ "2.7" "3.0" ]`):
        Version of the Ruby interpreter.
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.
    - sourcesYaml (`package`):
        `sources.yaml` file
        computed as explained in the pre-requisites section.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      makeRubyGemsInstall,
      ...
    }:
    makeRubyGemsInstall {
      name = "example";
      ruby = "3.0";
      sourcesYaml = projectPath "/makes/example/sources.yaml";
    }
    ```

???+ tip

    Refer to [makeRubyLock](/api/builtins/utilities/#makerubylock)
    to learn how to generate a `sourcesYaml`.

## makeRubyGemsEnvironment

Create an environment where the specified Ruby gems
from [RubyGems][rubygems]
are available.

Types:

- makeRubyGemsEnvironment (`function { ... } -> package`):
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - ruby (`enum [ "2.7" "3.0" ]`):
        Version of the Ruby interpreter.
    - searchPathsBuild (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`
        and used while installing gems.
        Defaults to `makeSearchPaths`'s defaults.
    - searchPathsRuntime (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`
        and propagated to the runtime environment.
        Defaults to `makeSearchPaths`'s defaults.
    - sourcesYaml (`package`):
        `sources.yaml` file
        computed as explained in the pre-requisites section.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      inputs,
      makeRubyGemsEnvironment,
      makeScript,
      ...
    }:
    let
      env = makeRubyGemsEnvironment {
        name = "example";
        ruby = "3.0";
        searchPathsBuild.bin = [ inputs.nixpkgs.gcc ];
        searchPathsRuntime.rpath = [ inputs.nixpkgs.gcc.cc.lib ];
        sourcesYaml = projectPath "/makes/example/sources.yaml";
      };
    in
    makeScript {
      entrypoint = ''
        slimrb --version
      '';
      name = "example";
      searchPaths.source = [ env ];
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        Slim 4.1.0
    ```

???+ tip

    Refer to [makeRubyLock](/api/builtins/utilities/#makerubylock)
    to learn how to generate a `sourcesYaml`.

[rubygems]: https://rubygems.org/
