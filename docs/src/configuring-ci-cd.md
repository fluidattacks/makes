# Configuring CI/CD

A Makes container can be found
in the [container registry](https://github.com/fluidattacks/makes/pkgs/container/makes).

You can use it
to run Makes on any CI/CD provider
that supports containers.

Below you will find examples
for running makes
on some of the most popular
CI/CD providers.

## Configuring on GitHub Actions

[GitHub Actions](https://github.com/features/actions)
is configured through
[workflow files](https://docs.github.com/en/actions/reference/)
located in a `.github/workflows` directory in the root of the project.

The smallest possible workflow file
looks like this:

```yaml
# .github/workflows/dev.yml
name: Makes CI
on: [push, pull_request]
jobs:
  helloWorld:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@2541b1294d2704b0964813337f33b291d3f8596b
      - uses: docker://ghcr.io/fluidattacks/makes:23.04
        # You can use any name you like here
        name: helloWorld
        # You can pass secrets (if required) as environment variables like this:
        env:
          SECRET_NAME: ${{ secrets.SECRET_IN_YOUR_GITHUB }}
        with:
          args: m . /helloWorld 1 2 3

  # Add more jobs here, you can copy paste jobs.helloWorld and modify the `args`
```

## Configuring on GitLab CI/CD

[GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
is configured through a
[.gitlab-ci.yml](https://docs.gitlab.com/ee/ci/yaml/) file
located in the root of the project.

The smallest possible .gitlab-ci.yml
looks like this:

```yaml
# /path/to/my/project/.gitlab-ci.yml
/helloWorld:
  image: ghcr.io/fluidattacks/makes:23.04
  script:
    - m . /helloWorld 1 2 3
# Add more jobs here, you can copy paste /helloWorld and modify the `script`
```

Secrets can be propagated to Makes
through [GitLab Variables](https://docs.gitlab.com/ee/ci/variables/),
which are passed automatically to the running container
as environment variables.

## Configuring on Travis CI

[Travis CI](https://travis-ci.org/)
is configured through a [.travis.yml](https://config.travis-ci.com/) file
located in the root of the project.

The smallest possible .travis.yml
looks like this:

```yaml
# /path/to/my/project/.travis.yml
os: linux
language: nix
nix: 2.3.12
install: nix-env -if https://github.com/fluidattacks/makes/archive/23.04.tar.gz
env:
  global:
    # Encrypted environment variable
    secure: cipher-text-goes-here...
    # Publicly visible environment variable
    NAME: value
jobs:
  include:
    - script: m . /helloWorld 1 2 3
  # You can add more jobs like this:
  # - script: m . /formatBash
```

Secrets can be propagated to Makes through
[Travis Environment Variables](https://docs.travis-ci.com/user/environment-variables),
which are passed automatically to the running container
as environment variables.
We highly recommend you to use encrypted environment variables.

## Configuring the cache

If your CI/CD will run on different machines
then it's a good idea
to setup a distributed cache system
using [Cachix](https://cachix.org/).

In order to do this:

1. Create or sign-up to your Cachix account.
1. Create a new cache with:
   - Write access: `API token`.
   - Read access: `Public` or `Private`.
1. Configure `makes.nix` as explained in the following sections

### Configuring trusted-users

If you decided to go
with a Multi-user installation
when installing Nix,
you will have to take additional steps
in order to make the cache work.

As the Multi-user installation
does not trust your user by default,
you will have to add yourself
to the `trusted-users` in the
[Nix Configuration File](https://www.mankier.com/5/nix.conf).
