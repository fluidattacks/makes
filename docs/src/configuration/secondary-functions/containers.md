## makeContainerImage

Build a container image
in [OCI Format](https://github.com/opencontainers/image-spec).

A container image is composed of:

- 0 or more layers (binary blobs).
    - Each layer contains a snapshot of the root file system (`/`),
        they represent portions of it.
    - When the container is executed
        all layers are squashed together
        to compose the root
        of the file system (`/`).
- A JSON manifest (metadata)
    that describes important aspects of the container,
    for instance its layers, environment variables, entrypoint, etc.

Resources:

- [Nix and layered docker images](https://grahamc.com/blog/nix-and-layered-docker-images)

Types:

- makeContainerImage (`function { ... } -> package`):
    - layers (`listOf package`): Optional.
        Layers of the container.
        Defaults to `[ ]`.
    - maxLayers (`ints.positive`): Optional.
        Maximum number of layers the container can have.
        Defaults to `65`.
    - config (`attrsOf anything`): Optional.
        Configuration manifest as described in
        [OCI Runtime Configuration Manifest](https://github.com/moby/docker-image-spec)
        Defaults to `{ }`.

Example:

=== "makes.nix"

    ```nix
    { inputs, makeContainerImage, makeDerivation, ... }:
    {
      jobs."/myContainer" = makeContainerImage {
        config = {
          Env = [
            # Do not use this for sensitive values, it's not safe.
            "EXAMPLE_ENV_VAR=example-value"
          ];
          WorkingDir = "/working-dir";
        };
        layers = [
          inputs.nixpkgs.coreutils # ls, cat, etc
          (makeDerivation {
            name = "custom-layer";
            builder = ''
              # $out represents the final container root file system: /
              #
              # The following commands are equivalent in Docker to:
              #   RUN mkdir /working-dir
              #   RUN echo my-file-contents > /working-dir/my-file
              #
              mkdir -p $out/working-dir
              echo my-file-contents > $out/working-dir/my-file
            '';
          })
        ];
      };
    }
    ```
