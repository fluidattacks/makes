<!--
SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors

SPDX-License-Identifier: MIT
-->

# Threat Model

## Spoofing

- A user can mistype the Makes installation command
  and wrongly install a different (potentially malicious) tool.

  Mitigation:

  - The installation command is given in plain-text,
    users can copy-paste it to avoid typos.

- A user can mistype the target project to be built with Makes,
  and end-up building (and potentially running)
  a different (potentially malicious) project.

  Mitigation:

  - The most common use case
    (running makes on the project in the current working directory)
    has a very convenient syntax: `$ m .`,
    which is very unlikely to be mistyped.
  - When referencing a project over the internet,
    the user is forced to use a git provider (github/gitlab),
    the owner account (which should be trusted by the user),
    the target repository,
    and a branch, commit or tag.

    By using a commit,
    the user can force the integrity of the downloaded data
    to match what they expect.

## Tampering

- The Nix Store can be tampered with
  if no good installation measures are taken by the user.

  Mitigation:

  - The Nix installation is responsibility of the user,
    but in general,
    a user could bind mount `/nix` as a read-only file system,
    and make the `/nix/store` only accessible by root
    and the `nixbld` group users,
    reducing an attack vector to the physical or local layer,
    which can be further protected
    by the use of frameworks like [SLSA](https://slsa.dev/),
    and full disk encryption using [LUKS](https://en.wikipedia.org/wiki/LUKS).

## Repudiation

- In single tenant setups,
  for instance when developers run Makes in their laptops,
  there is nothing to repudiate,
  there is only one user performing builds (the developer).
  However,
  in multi-tenant setups,
  for instance when Makes is run in a shared CI/CD system,
  a user could deny running a build.

  Mitigation:

  - Makes produces
    [SLSA Provenance Attestations](https://slsa.dev/provenance/v0.2),
    which identify the builder and the built artifact.
  - Most CI/CD systems
    (and particularly the ones supported by Makes)
    offer logs collection,
    so it would be easy to associate a build
    with the identity that triggered it.
    It is responsibility of the users
    to configure such CI/CD systems
    in a secure way and to protect (and backup) the logs.

## Information Disclosure

## Denial of Service

## Elevation of Privileges
