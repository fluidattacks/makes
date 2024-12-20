## makeRubyGemsInstall

Fetch and install the specified Ruby gems
from the [RubyGems][rubygems].

Types:

- makeRubyGemsInstall (`function { ... } -> package`):
    - name (`str`):
        Custom name to assign to the build step, be creative, it helps in debugging.
    - ruby (`enum [ "3.1" "3.2" "3.3" ]`):
        Version of the Ruby interpreter.
    - searchPaths (`asIn makeSearchPaths`): Optional.
        Arguments here will be passed as-is to `makeSearchPaths`.
        Defaults to `makeSearchPaths`'s defaults.
    - sourcesYaml (`package`):
        `sources.yaml` file
        computed as explained in the pre-requisites section.

Example:

=== "makes.nix"

    ```nix
    { makeRubyGemsInstall, ... }:
    {
      jobs."myRubyGemsInstall" = makeRubyGemsInstall {
        name = "example";
        ruby = "3.1";
        sourcesYaml = projectPath "/makes/example/sources.yaml";
      };
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
    - ruby (`enum [ "3.1" "3.2" "3.3" ]`):
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

=== "makes.nix"

    ```nix
    { inputs, makeRubyGemsEnvironment, makeScript, ... }:
    let
      env = makeRubyGemsEnvironment {
        name = "example";
        ruby = "3.1";
        searchPathsBuild.bin = [ inputs.nixpkgs.gcc ];
        searchPathsRuntime.rpath = [ inputs.nixpkgs.gcc.cc.lib ];
        sourcesYaml = projectPath "/makes/example/sources.yaml";
      };
    in
    {
      jobs."myRubyGemsEnvironment" = makeScript {
        entrypoint = "slimrb --version";
        name = "example";
        searchPaths.source = [ env ];
      };
    }
    ```

???+ tip

    Refer to [makeRubyLock](/api/builtins/utilities/#makerubylock)
    to learn how to generate a `sourcesYaml`.

[rubygems]: https://rubygems.org/
