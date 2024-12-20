# Supply Chain Levels for Software Artifacts

The [SLSA framework](https://slsa.dev/)
helps organizations measure
the level of assurance
that the Software Artifacts they produce
actually contain and use what they intended (integrity),
by ensuring that the whole build and release process,
and all of the involved sources and dependencies
cannot be tampered with.

In this document,
we use the
[version 0.1 of the specification](https://slsa.dev/spec/v0.1/requirements).

Our current SLSA level is 2.
The following is a detail of the levels achieved
on each of the requirements:

| Requirement                        | Level |
| :--------------------------------- | :---: |
| Source - Version Controlled        |   4   |
| Source - Verified History          |   4   |
| Source - Retained Indefinitely     |   4   |
| Source - Two Person Reviewed       |   3   |
| Build - Scripted Build             |   4   |
| Build - Build Service              |   4   |
| Build - Build As Code              |   4   |
| Build - Ephemeral Environment      |   4   |
| Build - Isolated                   |   2   |
| Build - Parameter-less             |   4   |
| Build - Hermetic                   |   4   |
| Build - Reproducible               |   4   |
| Provenance - Available             |   4   |
| Provenance - Authenticated         |   4   |
| Provenance - Service Generated     |   4   |
| Provenance - Non-Falsifiable       |   4   |
| Provenance - Dependencies Complete |   4   |
| Common - Security                  |   4   |
| Common - Access                    |   4   |
| Common - Superusers                |   3   |

For clarity,
this is how SLSA definitions map into our infrastructure:

- **Source**: Git repository at:
    [github.com/fluidattacks/makes][makes].
- **Platform**: [GitHub Actions][github_actions],
    [Makes][makes],
    and the [Nix package manager][nix].
- **Build service**:
    [GitHub Actions][github_actions],
    using GitHub hosted runners.
- **Build**: A Nix derivation.
- **Environment**: A sandbox
    that [Chroot](https://en.wikipedia.org/wiki/Chroot)s
    into an empty temporary directory,
    provides private versions
    of `/proc`, `/dev`, `/dev/shm`, and `/dev/pts`,
    and uses a private PID, mount, network, IPC, and UTS namespace
    to isolate itself from other processes in the system.
- **Steps**: Instructions declared
    in the corresponding Makes configuration files
    written using the Nix programming language
    and shell scripting, versioned as-code in the _source_.

## Source Requirements

### Version controlled

Every change to the source is tracked on GitHub,
using the Git version control system.

- **Change history**: There exists a record
    of the history of changes
    that went into the revision.
    Each change contains:
    the identities of the uploader and reviewers (if any),
    timestamps of the reviews (if any) and submission,
    the change description/justification,
    the content of the change,
    and the parent revisions.

    For example: [PR 649](https://github.com/fluidattacks/makes/pull/649).

- **Immutable reference**:
    There exists a way to indefinitely reference a particular,
    immutable revision.
    For example:
    [c61feb1be11abc4d7ffed52c660a45c57f06599c](https://github.com/fluidattacks/makes/commit/c61feb1be11abc4d7ffed52c660a45c57f06599c).

### Verified history

Every change in the revision’s history
need to pass through a Pull Request.

In order to approve a Pull Request
the reviewer need to be strongly authenticated into GitHub.
The authentication process requires 2FA,
and the dates of the change
are recorded in the Pull Request.

Only users who were previously granted access
by a platform Admin can review Pull Requests.
External contributors can create a Pull Request
without any special privileges,
but it won't be merged
until reviewers submit their approval.

For example:
[PR 649](https://github.com/fluidattacks/makes/pull/649).

### Retained indefinitely

The revision and its change history
are preserved indefinitely
and cannot be deleted
or modified (not even with multi-party approval).
Additionally,
the main branch is protected
against accidental history overwrite
using GitHub's branch protection rules.

At the moment,
no legal requirement
impedes us to preserve indefinitely our change history,
and no obliteration policy is in effect.
In fact, our source code is Free and Open Source Software:
Anyone can download or fork the repository.

### Two Person Reviewed

Every change in the revision’s history
is agreed to by at least one trusted person
prior to submission
and each of these trusted persons
are authenticated into the platform (using 2FA) first.
Only project maintainers can merge Pull Requests
and therefore append a change into the revision's history.

## Build Requirements

### Scripted Build

All build steps were fully defined
using GitHub Actions, Makes and Nix.

Manual commands are not necessary to invoke the build script.
A new build is triggered automatically
each time new changes are pushed to the repository.

For example:

- [.github/workflows/prod.yml](https://github.com/fluidattacks/makes/blob/27b4938a95990e3239626bf7f5c67e1f60ed8e21/.github/workflows/prod.yml)
- [src/cli/makes.nix](https://github.com/fluidattacks/makes/blob/19a2a579557204859dfa647967bbc4db32616f35/src/cli/makes.nix)

### Build Service

All build steps run on GitHub Actions
using GitHub hosted runners.

For example:

- [Actions tab](https://github.com/fluidattacks/makes/actions)

### Build As Code

All build steps have been stored and versioned
in the Git Repository.

For example:

- [.github/workflows](https://github.com/fluidattacks/makes/blob/27b4938a95990e3239626bf7f5c67e1f60ed8e21/.github/workflows)

### Ephemeral Environment

According to the [GitHub Actions documentation](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners),

- "Each GitHub-hosted runner
    is a new virtual machine (VM)
    hosted by GitHub with the runner application
    and other tools preinstalled."
- "When the job begins,
    GitHub automatically provisions a new VM for that job.
    All steps in the job execute on the VM,
    allowing the steps in that job to share information
    using the runner's filesystem.
    You can run workflows directly on the VM
    or in a Docker container.
    When the job has finished,
    the VM is automatically decommissioned."

Additionally,
the [Nix package manager][nix]
provides an ephemeral environment to each of the derivations.
On Linux,
the environment is a sandbox
that [Chroot](https://en.wikipedia.org/wiki/Chroot)s
into an empty temporary directory,
provides private versions
of `/proc`, `/dev`, `/dev/shm`, and `/dev/pts`,
and uses a private PID, mount, network, IPC, and UTS namespace
to isolate itself from other processes in the system.

### Isolated

Our build service
ensures that the build steps
run in an isolated environment
free of influence from other build instances,
whether prior or concurrent,
by using containerization technologies.

Builds are executed using the [Nix package manager][nix],
which prevents builds
from accessing any external environment variables,
network resources, sockets,
or paths in the file system.
and provides private versions
of `/proc`, `/dev`, `/dev/shm`, and `/dev/pts`,
and uses a private PID, mount, network, IPC, and UTS namespace
to isolate the build from other builds
happening concurrently in the system.

Input-addressed build caches are used to speed-up the pipeline.

### Parameter-less

The build output cannot be affected by user parameters
other than the build entry point
and the top-level source location.

In order to modify the build output,
a change to the source code must happen first.

### Hermetic

Builds are executed using the [Nix package manager][nix],
which prevents builds
from accessing any external environment variables,
network resources, sockets,
or paths in the file system.

All transitive build steps, sources, and dependencies
are fully declared up front with immutable references.

For example:

- [makes/cli/pypi/pypi-sources.yaml](https://github.com/fluidattacks/makes/blob/27b4938a95990e3239626bf7f5c67e1f60ed8e21/makes/cli/pypi/pypi-sources.yaml).

The [Nix package manager][nix]:

- Fetches all of the declared artifacts
    into a trusted control plane (the /nix/store).
- Mounts into the build sandbox
    the specific /nix/store paths required by it.
- Allows a build to fetch artifacts over the network
    if and only if the expected artifact integrity is specified.
- Validates the integrity of each artifact
    before allowing a build to use it,
    and fails the build if the verification fails.
- Denies network connectivity if no expected hash is specified.

### Reproducible

All of our build scripts are intended to be reproducible.

The reproducibility guarantees of our build scripts
are that of the [Nix package manager][nix].

## Provenance Requirements

### Available

Provenance is produced by Makes,
and exposed by the build service
as a JSON document
together with the artifacts produced by the build.

Only builds that produce artifacts generate provenance,
because if a build does not produce artifacts,
then there wouldn't be something to verify the provenance of.

### Authenticated

The authenticity of the provenance
comes from the fact
that it can be downloaded
from the build service itself,
and therefore the authenticity claim
is as strong as the _Build and Source Requirements_ are secure.

The integrity of the provenance
is displayed in the logs
and generated by Makes.

### Service Generated

The data in the provenance
is exposed by the build service,
and is generated by Makes.

Regular users of the service
are not able to inject
or alter the contents
because a build is fully determined
and automated by its configuration,
and the configuration comes directly from the source.

### Non-Falsifiable

The provenance
cannot be falsified by the build service's users:

- There is no secret material
    to demonstrate the non-falsifiable nature of the provenance
    (see _Provenance - Authenticated_).
- Even if such secret material existed,
    builds are run in an hermetic environment,
    and therefore they wouldn't be available to the build steps
    (see _Build - Hermetic_).
- Every field in the provenance is generated
    by the build service in a trusted control plane,
    which is fully defined by the build configuration,
    which comes directly from the Source,
    and therefore is as secure as the Source is
    (see _Source - Verified History_).

### Dependencies Complete

The provenance contains all of dependencies
that were available while running the build steps.

This is guaranteed by the fact
that builds are hermetic
(see _Build - Hermetic_).
So for a build to succeed,
all of its dependencies must be declared,
and therefore the build tool (Makes and Nix)
who fetched them at build time,
have strong knowledge of their existence.

## Common Requirements

### Security

Please read the [Security page](/security/).

### Access

Our build service (GitHub Actions) is SaaS,
and we use GitHub hosted runners.
Only some GitHub employees
may have access to the runners.
We cannot access the build service infrastructure
physically nor remotely.

### Superusers

Only a small number of platform admins may override the guarantees provided by SLSA.
Particularly through disabling security options
in the repository configuration page.
Doing so does not currently require approval
of a second platform admin.

<!-- References -->

[github_actions]: https://docs.github.com/en/actions
[makes]: https://github.com/fluidattacks/makes
[nix]: https://nixos.org/
