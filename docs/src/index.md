# Overview

A CI/CD framework
powered by [Nix](https://nixos.org/).

![Makes demo](assets/demo.svg "Makes demo")

## Why

Ever needed to

- run applications locally
    to try out your code;
- execute CI/CD pipelines locally
    to make sure jobs are being passed;
- keep execution environments frozen
    for strict dependency control
    against supply chain attacks;
- know the exact dependency tree of your application.

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
