## fetchUrl

Fetch a file from the specified URL.

Types:

- fetchUrl (`function { ... } -> package`):

  - url (`str`):
    URL to download.
  - sha256 (`str`):
    SHA256 of the expected output,
    In order to get the SHA256
    you can omit this parameter and execute Makes,
    Makes will tell you the correct SHA256 on failure.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      fetchUrl,
      ...
    }:
    fetchUrl {
      url = "https://github.com/fluidattacks/makes/blob/16aafa1e3ed4cc99eb354842341fbf6f478a211c/README.md";
      sha256 = "18scrymrar0bv7s92hfqfb01bv5pibyjw6dxp3i8nylmnh6gjv15";
    }
    ```

## fetchArchive

Fetch a Zip (.zip) or Tape Archive (.tar) from the specified URL
and unpack it.

Types:

- fetchArchive (`function { ... } -> package`):

  - url (`str`):
    URL to download.
  - sha256 (`str`):
    SHA256 of the expected output,
    In order to get the SHA256
    you can omit this parameter and execute Makes,
    Makes will tell you the correct SHA256 on failure.
  - stripRoot (`bool`): Optional.
    Most archives have a symbolic top-level directory
    that is discarded during unpack phase.
    If this is not the case you can set this flag to `false`.
    Defaults to `true`.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      fetchArchive,
      ...
    }:
    fetchArchive {
      url = "https://github.com/fluidattacks/makes/archive/16aafa1e3ed4cc99eb354842341fbf6f478a211c.zip";
      sha256 = "16zx89lzv5n048h5l9f8dgpvdj0l38hx7aapc7h1d1mjc1ca2i6a";
    }
    ```

## fetchGithub

Fetch a commit from the specified Git repository at GitHub.

Types:

- fetchGithub (`function { ... } -> package`):

  - owner (`str`):
    Owner of the repository.
  - repo (`str`):
    Name of the repository.
  - rev (`str`):
    Commit, branch or tag to fetch.
  - sha256 (`str`):
    SHA256 of the expected output,
    In order to get the SHA256
    you can omit this parameter and execute Makes,
    Makes will tell you the correct SHA256 on failure.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      fetchGithub,
      ...
    }:
    fetchGithub {
      owner = "kamadorueda";
      repo = "mailmap-linter";
      rev = "e0799aa47ac5ce6776ca8581ba50ace362e5d0ce";
      sha256 = "02nr39rn4hicfam1rccbqhn6w6pl25xq7fl2kw0s0ahxzvfk24mh";
    }
    ```

## fetchGitlab

Fetch a commit from the specified Git repository at GitLab.

Types:

- fetchGitlab (`function { ... } -> package`):

  - owner (`str`):
    Owner of the repository.
  - repo (`str`):
    Name of the repository.
  - rev (`str`):
    Commit, branch or tag to fetch.
  - sha256 (`str`):
    SHA256 of the expected output,
    In order to get the SHA256
    you can omit this parameter and execute Makes,
    Makes will tell you the correct SHA256 on failure.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      fetchGitlab,
      ...
    }:
    fetchGitlab {
      owner = "fluidattacks";
      repo = "product";
      rev = "ff231a9bf8aa3f0807f3431b402e7af08d136341";
      sha256 = "1sfbif0bchdpw4rlfpv9gs4l4bmg8l24fqh2hg6m39msrvh1w6h3";
    }
    ```

## fetchNixpkgs

Fetch a commit from the
[Nixpkgs](https://github.com/NixOS/nixpkgs) repository.

???+ warning

    By default all licenses in the Nixpkgs repository are accepted.
    Options to decline individual licenses are provided below.

Types:

- fetchNixpkgs (`function { ... } -> anything`):
  - rev (`str`):
    Commit, branch or tag to fetch.
  - allowUnfree (`bool`): Optional.
    Allow software that do not respect the freedom of its users.
    Defaults to `true`.
  - acceptAndroidSdkLicense (`bool`): Optional.
    Accept the Android SDK license.
    Defaults to `true`.
  - overalys (`listOf overlayType`): Optional.
    Overlays to apply to the Nixpkgs set.
    Defaults to `[ ]`.
  - sha256 (`str`):
    SHA256 of the expected output,
    In order to get the SHA256
    you can omit this parameter and execute Makes,
    Makes will tell you the correct SHA256 on failure.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      fetchNixpkgs,
      ...
    }:
    let nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
    in
    nixpkgs.awscli
    ```

## fetchRubyGem

Fetch a Ruby gem
from [RubyGems](https://rubygems.org/).

Types:

- fetchRubyGem (`function { ... } -> package`):
  - sha256 (`str`):
    SHA256 of the expected output,
    In order to get the SHA256
    you can omit this parameter and execute Makes,
    Makes will tell you the correct SHA256 on failure.
  - url (`str`):
    url of the gem to download.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      fetchRubyGem,
      ...
    }:
    fetchRubyGem {
      sha256 = "04nc8x27hlzlrr5c2gn7mar4vdr0apw5xg22wp6m8dx3wqr04a0y";
      url = "https://rubygems.org/downloads/ast-2.4.2.gem";
    }
    ```
