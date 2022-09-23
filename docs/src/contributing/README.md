<!--
SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors

SPDX-License-Identifier: MIT
-->

# Contributing to Makes

- Bug reports: [here][makes_issues]
- Feature requests: [here][makes_issues]
- Give us a star: [here][makes]
- Feedback: [here][makes_issues]

## Code contributions

We accept anything that benefits the community,
thanks for sharing your work with the world.
We can discuss implementation details [here][makes_issues].

1. Write your idea: [here][makes_issues]
1. Fork [Makes on GitHub][makes]
1. [Git][git]-clone your fork
1. Hack as much as you like!
1. [Git][git]-commit your changes.
1. [Git][git]-push changes to your fork
1. Create a **Pull Request** from your fork to [Makes][makes]

Guidelines:

- Keep it simple
- Remember we write code for humans, not machines
- Write an argument: `/src/args`
- Write a module (if applies): `/src/evaluator/modules`
- Write docs: `/README.md` or `/docs`
- Write a test: `/makes.nix` or `/makes/**/main.nix`
- Write a test [GitHub workflow][github_workflows]: `/.github/workflows/dev.yml`

Examples:

- [feat(build): #262 lint git mailmap](https://github.com/fluidattacks/makes/commit/01fcd5790dd54b117da63bcc2480437135da8bb3)
- [feat(build): #232 lint terraform](https://github.com/fluidattacks/makes/commit/081835b563c712b7650dbc5bf1e306d4aff159cf)
- [feat(build): #232 test terraform](https://github.com/fluidattacks/makes/commit/571cf059b521cb97396210f9fe4659ee74f675b4)
- [feat(build): #232 deploy terraform](https://github.com/fluidattacks/makes/commit/f827da16b685b07d7f987c668c0fe089aefa7931)
- [feat(build): #252 aws secrets from env](https://github.com/fluidattacks/makes/commit/1c9f06a809bd92d56939d5809ce46058856fdf0a)
- [feat(build): #232 make parallel utils](https://github.com/fluidattacks/makes/commit/99e9f77482a6cbc9858a7a928a91a8a8aa9ff353)

## The legal side of contributions

All of the code
that you submit to our code repository
will be licensed under the [MIT license](https://mit-license.org).

Please add a `Signed-off-by: Full Name <email>` to your commits as explained [here](https://wiki.linuxfoundation.org/dco)
to signal that you agree
to the terms of the following
[Developer Certificate of Origin](https://developercertificate.org/).

Thank you!

<!--  -->

[git]: https://git-scm.com/
[github_workflows]: https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions
[makes]: https://github.com/fluidattacks/makes
[makes_issues]: https://github.com/fluidattacks/makes/issues
