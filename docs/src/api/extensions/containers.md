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
    [OCI Runtime Configuration Manifest](https://github.com/moby/moby/blob/master/image/spec/v1.2.)
    Defaults to `{ }`.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      inputs,
      makeContainerImage,
      makeDerivation,
      ...
    }:
    makeContainerImage {
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
    }
    ```

=== "Invocation"

    ```bash
    $ m . /example

        Creating layer 1 from paths: ['/nix/store/zqaqyidzsqc7z03g4ajgizy2lz1m19xz-libunistring-0.9.10']
        Creating layer 2 from paths: ['/nix/store/xjjdyb66g3cxd5880zspazsp5f16lbxz-libidn2-2.3.1']
        Creating layer 3 from paths: ['/nix/store/wvgyhnd3rn6dhxzbr5r71gx2q9mhgshj-glibc-2.32-48']
        Creating layer 4 from paths: ['/nix/store/ip0pxdd49l1v3cmxsvw8ziwmqhyzg5pf-attr-2.4.48']
        Creating layer 5 from paths: ['/nix/store/26vpasbj38nhj462kqclwp2i6s3hhdba-acl-2.3.1']
        Creating layer 6 from paths: ['/nix/store/937f5738d2frws07ixcpg5ip176pfss1-coreutils-8.32']
        Creating layer 7 from paths: ['/nix/store/fc24830z8lqa657grb3snvjjv9vxs7ql-custom-layer']
        Creating layer 8 with customisation...
        Adding manifests...
        Done.

        /nix/store/dvif4xy1l0qsjblxvzzcr6map1hg22w5-container-image.tar.gz

    $ docker load < /nix/store/dvif4xy1l0qsjblxvzzcr6map1hg22w5-container-image.tar.gz

        b5507f5bda26: Loading layer  133.1kB/133.1kB
        da2b3a66ea19: Loading layer  1.894MB/1.894MB
        eb4c566a2922: Loading layer  10.24kB/10.24kB
        19b7be559bbc: Loading layer  61.44kB/61.44kB
        Loaded image: container-image:latest

    $ docker run container-image:latest pwd

        /working-dir

    $ docker run container-image:latest ls .

        my-file

    $ docker run container-image:latest cat my-file

        my-file-contents

    $ docker run container-image:latest ls /

        bin
        dev
        etc
        libexec
        nix
        proc
        sys
        working-dir
    ```
