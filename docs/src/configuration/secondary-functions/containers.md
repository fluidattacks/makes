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

    This function accepts all parameters from the underlying [dockerTools](https://github.com/NixOS/nixpkgs/raw/refs/heads/master/doc/build-helpers/images/dockertools.section.md) functions, while providing defaults for several key attributes:

    - layered (`bool`): Optional.
        If `true`, uses the `nixpkgs.dockerTools.buildLayeredImage` function
        to build the OCI image,
        otherwise the `nixpkgs.dockerTools.buildImage` function is used.
        Defaults to `true`.
    - name (`string`): Optional.
        Name of the created image.
        Defaults to `"container-image"`.
    - tag (`string`): Optional.
        Tag of the created image.
        Defaults to `"latest"`.
    - created (`string`): Optional.
        Creation date of the image in ISO-8601 format.
        Defaults to `"1970-01-01T00:00:01Z"`.
    - layers (`listOf package`): Optional.
        An alias for `contents`. Represents the layers of the container.
        Defaults to `[ ]`.

Additionally, all other attributes from the underlying `dockerTools` functions can be passed directly.

Possible attributes when `layered` is

- `true`: See [here](https://github.com/NixOS/nixpkgs/blob/master/doc/build-helpers/images/dockertools.section.md#inputs-ssec-pkgs-dockertools-streamlayeredimage-inputs).
- `false`: See [here](https://github.com/NixOS/nixpkgs/blob/master/doc/build-helpers/images/dockertools.section.md#inputs-ssec-pkgs-dockertools-buildimage-inputs).

The output of this job is the path to the build OCI image in the nix store.

Example:

=== "makes_multi_layer.nix"

    ```nix
    # example for layered = true
    { inputs, makeContainerImage, makeDerivation, ... }:
    {
      # Note: Some attributes are only available when layered = true.
      jobs."/multiLayerContainer" = makeContainerImage {
        # base image configuration
        # to get image hash see: https://github.com/NixOS/nixpkgs/blob/master/doc/build-helpers/images/dockertools.section.md#finding-the-digest-and-hash-values-to-use-for-dockertoolspullimage
        fromImage = inputs.nixpkgs.dockerTools.pullImage {
          imageName = "docker.io/library/alpine"; # can be any OCI registry
          imageDigest = "sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c";
          hash = "sha256-BLd0y9w1FIBJO5o4Nu5Wuv9dtGhgvh+gysULwnR9lOo=";
          finalImageTag = "3.21.3";
        };

        # image metadata
        name = "my-application";
        tag = "1.0.0";
        created = "now";

        # container configuration
        config = {
          Env = [
            "NODE_ENV=production"
            "LOG_LEVEL=info"
          ];
          WorkingDir = "/app";
          ExposedPorts = {
            "8080/tcp" = {};
          };
          Cmd = [ "/bin/sh" "-c" "node /app/server.js" ];
          Labels = {
            "org.opencontainers.image.source" = "https://github.com/myorg/myapp";
            "org.opencontainers.image.description" = "My application container";
          };
        };

        # control layering behavior
        layered = true;
        maxLayers = 100;

        # image contents/layers
        layers = [
          inputs.nixpkgs.coreutils
          inputs.nixpkgs.nodejs_20

          # custom application files
          (makeDerivation {
            name = "application-files";
            builder = ''
              mkdir -p $out/app
              cp -r ${./src}/* $out/app/
              chmod +x $out/app/server.js
            '';
          })
        ];

        # additional setup commands
        extraCommands = ''
          mkdir -p tmp
          chmod 1777 tmp
        '';
      };
    }
    ```

=== "makes_single_layer.nix"

    ```nix
    # example for layered = false.
    { inputs, makeContainerImage, makeDerivation, ... }:
    {
      # Note: Some attributes are only available when layered = false.
      jobs."/singleLayerContainer" = makeContainerImage {
        # specify non-layered image
        layered = false;

        # image metadata
        name = "static-service";
        tag = "2.1.0";
        created = "2026-01-19T10:30:00Z";

        # container configuration
        config = {
          Env = [
            "APP_ENV=production"
            "DEBUG=false"
          ];
          WorkingDir = "/service";
          User = "nobody";
          Entrypoint = [ "/service/entrypoint.sh" ];
          Cmd = [ "serve" "--port=8080" ];
        };

        # image contents/layers, will be merged to one layer
        layers = [
          inputs.nixpkgs.busybox
          inputs.nixpkgs.nginx

          # custom configuration files
          (makeDerivation {
            name = "service-config";
            builder = ''
              mkdir -p $out/service/config
              cp ${./config}/* $out/service/config/

              # Create entrypoint script
              mkdir -p $out/service
              cat > $out/service/entrypoint.sh << 'EOF'
              #!/bin/sh
              echo "Starting service..."
              exec "$@"
              EOF
              chmod +x $out/service/entrypoint.sh
            '';
          })
        ];

        # commands to run as root during build
        runAsRoot = ''
          #!${inputs.nixpkgs.runtimeShell}
          mkdir -p /var/cache/nginx
          chmod 755 /var/cache/nginx
        '';

        # additional configuration
        includeStorePaths = true;
        diskSize = 1024;
        copyToRoot = inputs.nixpkgs.buildEnv {
          name = "image-root";
          paths = [ inputs.nixpkgs.fakeroot ];
          pathsToLink = [ "/bin" ];
        };
      };
    }
    ```
