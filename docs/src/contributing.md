# Contributing

- Bug reports: [here][makes_issues]
- Feature requests: [here][makes_issues]
- Give us a star: [here][makes]
- Feedback: [here][makes_issues]

## Code contributions

We accept anything that benefits the community,
thanks for sharing your work with the world.
We can discuss implementation details [here][makes_issues].

### Guidelines

1. Write your idea: [here][makes_issues]
1. Fork [Makes on GitHub][makes]
1. [Git][git]-clone your fork
1. Hack as much as you like!
1. [Git][git]-commit your changes.
1. [Git][git]-push changes to your fork
1. Create a **Pull Request** from your fork to [Makes][makes]

#### Testing your local changes

You can run local changes by simply running `m . <job>`.
If you're adding new files, make sure to `git add` them first.

#### Adding documentation

- All changes must be documented in the same PR.
- You can run `m . /docs/dev` to serve the docs site
  on localhost.

#### Adding tests

- Tests are located under `tests`.
- Make sure to add new tests
  to the [GitHub Actions pipelines](https://github.com/fluidattacks/makes/tree/main/.github/workflows)
  as well.

#### Adding yourself to the mailmap

You must add yourself to the
[.mailmap](https://github.com/fluidattacks/makes/blob/main/.mailmap) file.
Make sure to test it with `m . /lintGitMailMap`.

#### Writing a valid commit message

- Your commit message must follow this [syntax](https://github.com/fluidattacks/makes/tree/main/test/lint-commit-msg).
- You must sign your commits by adding a `Signed-off-by` line at the end of your
  commit message.
- You can take a look at other commits [here](https://github.com/fluidattacks/makes/commits/main).
- Make sure to test it with `m . /tests/commitlint`.

#### Other PR rules

A PR must:

- Only be one commit ahead of main.
- Have a title and body equal to its commmit message.

#### Examples

- [feat(build): #262 lint git mailmap](https://github.com/fluidattacks/makes/commit/01fcd5790dd54b117da63bcc2480437135da8bb3)
- [feat(build): #232 lint terraform](https://github.com/fluidattacks/makes/commit/081835b563c712b7650dbc5bf1e306d4aff159cf)
- [feat(build): #232 test terraform](https://github.com/fluidattacks/makes/commit/571cf059b521cb97396210f9fe4659ee74f675b4)
- [feat(build): #232 deploy terraform](https://github.com/fluidattacks/makes/commit/f827da16b685b07d7f987c668c0fe089aefa7931)
- [feat(build): #252 aws secrets from env](https://github.com/fluidattacks/makes/commit/1c9f06a809bd92d56939d5809ce46058856fdf0a)
- [feat(build): #232 make parallel utils](https://github.com/fluidattacks/makes/commit/99e9f77482a6cbc9858a7a928a91a8a8aa9ff353)

### The legal side of contributions

All of the code
that you submit to our code repository
will be licensed under the [MIT license](https://mit-license.org).

Please add a `Signed-off-by: Full Name <email>` to your commits as explained [here](https://wiki.linuxfoundation.org/dco)
to signal that you agree
to the terms of the following
[Developer Certificate of Origin](https://developercertificate.org/).

Thank you!

### Review process

Once a pull request is opened in the repository,
a maintainer must follow the following steps
to review it:

1. Check that the proposed change has an associated issue,
    enough discussion has happened on it,
    and there is consensus in the implementation details,
    and if we agree that implement it is a good idea.
1. Check if the change modifies the [Architecture](/architecture/)
    in any way, and that it has been updated.
1. Check if the implementation follows the
    [Secure Design Principles](/security/design-principles/),
    and documents there
    any new interactions,
    or updates the documentation accordingly.
1. Check if the implementation introduces new threats,
    or changes/removes an existing threat,
    and if the [Threat Model](/security/threat-model/)
    documentation has been updated to reflect it.
1. Check if the change adds or modifies
    an existing security property of the system,
    and if the [Software Assurance](/security/assurance/)
    documentation has been updated to reflect it.
1. Check if the CI/CD succeeded.
    No job should fail
    unless something unrelated to the pull request happened.
1. The _Developer Certificate of Origin_ was accepted,
    normally through checking
    that the job in the CI/CD that verifies it succeeded.
1. The steps mentioned in the sections above were followed,
    particularly check if the code is readable,
    maintainable,
    proper tests were added or updated,
    the corresponding docs were added or updated,
    and the architecture and design seems to be of good quality.

<!--  -->

[git]: https://git-scm.com/
[github_workflows]: https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions
[makes]: https://github.com/fluidattacks/makes
[makes_issues]: https://github.com/fluidattacks/makes/issues
