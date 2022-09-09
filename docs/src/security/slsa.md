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

Our current SLSA level is 0.
The following is a detail of the levels achieved
on each of the requirements:

| Requirement                    | Level |
| :----------------------------- | :---: |
| Source - Version Controlled    |   4   |
| Source - Verified History      |   4   |
| Source - Retained Indefinitely |   4   |
| Source - Two Person Reviewed   |   3   |

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

# Source - Version controlled

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

# Source - Verified history

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

# Source - Retained indefinitely

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

# Source - Two Person Reviewed

Every change in the revision’s history
is agreed to by at least one trusted person
prior to submission
and each of these trusted persons
are authenticated into the platform (using 2FA) first.
Only project maintainers can merge Pull Requests
and therefore append a change into the revision's history.

<!-- References -->

[github_actions]: https://docs.github.com/en/actions
[makes]: https://github.com/fluidattacks/makes
[nix]: https://nixos.org/
