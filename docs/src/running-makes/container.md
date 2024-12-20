# Container

## Usage

A Makes container can be found
in the [container registry](https://github.com/fluidattacks/makes/pkgs/container/makes).

We currently support `linux/amd64` and `linux/arm64` architectures.

You can use it
to run Makes on any service
that supports containers,
including most CI/CD providers.

The biggest advantage of this is the fact that you can run
any makes job while using the same container.

Example:

=== "GitHub Actions"

    ```yaml
    # .github/workflows/dev.yml
    name: Makes CI
    on: [push, pull_request]
    jobs:
      lintNix:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@f095bcc56b7c2baf48f3ac70d6d6782f4f553222
          - uses: docker://ghcr.io/fluidattacks/makes:24.12
            name: lintNix
            with:
              args: sh -c "chown -R root:root /github/workspace && m . /lintNix"
    ```

    ???+ note

        We use `chown -R root:root /github/workspace` to solve the error:
        `fatal: detected dubious ownership in repository at ...`, this message
        typically indicates an issue with the ownership or permissions of the repository.
        See the [community discussion](https://github.com/orgs/community/discussions/48355)
        for more information.

=== "GitLab CI"

    ```yaml
    # .gitlab-ci.yml
    /lintNix:
      image: ghcr.io/fluidattacks/makes:24.12
      script:
        - m . /lintNix
    ```

=== "Travis CI"

    ```yaml
    # .travis.yml
    os: linux
    language: nix
    nix: 2.3.12
    install: nix-env -if https://github.com/fluidattacks/makes/archive/24.12.tar.gz
    jobs:
      include:
        - script: m . /lintNix
    ```
