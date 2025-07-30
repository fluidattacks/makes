# ⚠️ Deprecation notice ⚠️

After a [thorough review](https://gitlab.com/fluidattacks/universe/-/issues/14974#note_2427180773) of Makes and other build system alternatives, Fluid Attacks has decided to transition fully to [Nix Flakes](https://nixos.wiki/wiki/Flakes) for all our builds.

This decision brings significant benefits, including the opportunity to rely on and contribute to the incredible Nix community instead of maintaining our own build system.

It also means that Makes is no longer maintained and will be archived.

More information can be found at https://github.com/fluidattacks/makes/issues/1439.

# 🦄 Makes

A CI/CD framework
powered by [Nix](https://nixos.org/).

![Makes demo](/docs/src/assets/demo.svg "Makes demo")

[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/5703/badge)](https://bestpractices.coreinfrastructure.org/projects/5703)
![Linux](https://img.shields.io/badge/Linux-blue)
![MacOS](https://img.shields.io/badge/MacOS-blue)
![GitHub](https://img.shields.io/badge/GitHub-brightgreen)
![GitLab](https://img.shields.io/badge/GitLab-brightgreen)
![Local](https://img.shields.io/badge/Local-brightgreen)
![Docker](https://img.shields.io/badge/Docker-brightgreen)
![Kubernetes](https://img.shields.io/badge/Kubernetes-brightgreen)
[![Scc Count Badge](https://sloc.xyz/github/fluidattacks/makes/?category=lines)](https://github.com/fluidattacks/makes/)
![Nomad](https://img.shields.io/badge/Nomad-brightgreen)
![AWS Batch](https://img.shields.io/badge/AWS%20Batch-brightgreen)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/fluidattacks/makes?color=blueviolet&label=Commits&labelColor=blueviolet)
![Contributors](https://img.shields.io/github/contributors/fluidattacks/makes?color=blueviolet&label=Contributors&labelColor=blueviolet)

## Why

Ever needed to

- run applications locally
  to try out your code?
- Execute CI/CD pipelines locally
  to make sure jobs are being passed?
- Keep execution environments frozen
  for strict dependency control
  against supply chain attacks?
- Know the exact dependency tree of your application?

Well, we have!

## What

Makes is an open-source, production-ready framework
for building CI/CD pipelines
and application environments.

It is

| Attribute                                                                                         | Description                                                                     |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| [<img src="https://img.shields.io/badge/attr-secure-brightgreen.svg" alt="secure">](#secure)      | Cryptographically signed dependencies for apps and CI/CD pipelines              |
| [<img src="https://img.shields.io/badge/attr-easy-orange.svg" alt="easy">](#easy)                 | Can be installed with just one command and has dozens of generic CI/CD builtins |
| [<img src="https://img.shields.io/badge/attr-fast-blueviolet.svg" alt="fast">](#fast)             | Supports a distributed and completely granular cache                            |
| [<img src="https://img.shields.io/badge/attr-portable-violet.svg" alt="portable">](#portable)     | Runs on Docker, VMs, and any Linux-based OS                                     |
| [<img src="https://img.shields.io/badge/attr-extensible-blue.svg" alt="extensible">](#extensible) | can be extended to work with any technology                                     |

## Installation

[Installation](https://github.com/fluidattacks/makes/blob/main/docs/src/getting-started.md)

## Documentation

You can run `m . /docs/dev` to serve the docs site on localhost or directly see the `docs/src` directory.

## Issues

Found a bug?
create a new item
in the project's [issues](https://github.com/fluidattacks/makes/issues)
