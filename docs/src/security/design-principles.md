# Design Principles

## Least Privilege

- The Makes CLI is a python application that runs in user-space.
  The privileges required are:

    - Write access to the `${HOME}`,
      which is normally owned by the user,
      so no extra privileges
      other than what the user already has are required.
    - Creating temporary files/directories,
      which respects the `${TMPDIR}` environment variable,
      which is a functionality normally available to a user,
      so no extra privileges are required.
    - A system with Nix installed.
    - (optional) privileges to create Kernel namespaces.

- The Makes framework is simply a library
  that aids the developer in creating build scripts,
  so no privileges are required,
  the Makes framework is just source code
  that the user can opt-in to use.

- When containers are built,
  they are build by assembling an OCI-compliant image
  (TAR files per each layer plus a JSON manifest),
  without resorting to privileged daemons like that of Docker.
  They are generated as any other build (hermetic, pure, etc)
  using information from the Nix Store.

## Fail-Safe Defaults

- Generated files are created inside user-owned folders by default,
  which inherit the security
  that the user has previously defined for the directory.

  An user may opt-out from this behavior by setting environment variables,
  but user-owned folders are selected by default.

- In the most common configuration,
  the contents of the `/nix/store`
  are never published to the internet.

  A user may want to share artifacts with other users
  in order to improve performance
  by writing artifacts to a binary cache,
  so that other users can download the artifacts
  if they have already been built by other user,
  but this behavior
  requires configuring a read+write binary cache
  and setting the corresponding access secret.

  A read-only binary cache (<https://cache.nixos.org>)
  and no write binary cache
  is the default configuration,

## Economy of Mechanism

- The Makes CLI is essentially a wrapper over Nix,
  so the surface is as small as possible (~1000 loc).
- The Makes Framework defines a common set of utilities
  a user can opt-in to use,
  saving the user the work of writing that functionality themselves
  which would require the same amount of code anyway.

## Complete Mediation

## Open Design

- Makes is Free and Open Source Software,
    anyone can read its internals:
    https://github.com/fluidattacks/makes

## Separation of Privilege

## Least Common Mechanism

- In the most common case
    each user of Makes has a personal `/nix/store`
    and a personal installation of Nix.
    The `/nix/store` contents are not shared between users by default,
    unless the user configures a read+write binary cache
    and sets the corresponding binary cache secret.

## Psychological Acceptability

- The Makes CLI is easy to use.
    Performing an installation using the default values
    yields a sufficiently secure version of the system.
    Users familiar with other build tools would feel at home.
