# 🦄 Makes

A software supply chain framework
powered by [Nix][nix].

Ever needed to run applications locally
to try out your code?
Execute CI/CD pipelines locally
to make sure jobs are being passed?
Keep execution environments frozen
for strict dependency control
against supply chain attacks?
Know the exact dependency tree of your application?
Well, we have!

[Makes][makes] is an open-source, production-ready framework
for building CI/CD pipelines
and application environments.
It cryptographically signs direct and indirect dependencies,
supports a distributed and completely granular cache,
runs on Docker, VMs and any Linux-based OS,
can be installed with just one command,
and can be extended to work with any technology.

The goal of [Makes][makes] is to provide
an immutable software supply chain
while keeping technical implementation
as simple as possible.

[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/5703/badge)](https://bestpractices.coreinfrastructure.org/projects/5703)
![Linux](https://img.shields.io/badge/Linux-blue)
![MacOS](https://img.shields.io/badge/MacOS-blue)
![GitHub](https://img.shields.io/badge/GitHub-brightgreen)
![GitLab](https://img.shields.io/badge/GitLab-brightgreen)
![Local](https://img.shields.io/badge/Local-brightgreen)
![Docker](https://img.shields.io/badge/Docker-brightgreen)
![Kubernetes](https://img.shields.io/badge/Kubernetes-brightgreen)
![Nomad](https://img.shields.io/badge/Nomad-brightgreen)
![AWS Batch](https://img.shields.io/badge/AWS%20Batch-brightgreen)

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/fluidattacks/makes?color=blueviolet&label=Commits&labelColor=blueviolet)
![Contributors](https://img.shields.io/github/contributors/fluidattacks/makes?color=blueviolet&label=Contributors&labelColor=blueviolet)

## Want to get your hands dirty?

Jump right into our [hands-on example](https://github.com/fluidattacks/makes-example)!

## At a glance

### Cloud native applications with Kubernetes ☸

This is how easy it is to deploy an application
built with [Makes][makes] into [Kubernetes][kubernetes]:

```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
        - name: example
          image: ghcr.io/fluidattacks/makes:22.11
          command: [m]
          args:
            - github:fluidattacks/makes@main
            - /helloWorld
```

### Large scale computing on the cloud 🏋

Not a problem!

This is how running [Makes][makes]
on [AWS Batch][aws_batch] looks like:

```nix
{ outputs
, ...
}:
{
  computeOnAwsBatch = {
    helloWorld = {
      attemptDurationSeconds = 43200;
      command = [ "m" "github:fluidattacks/makes@main" "/helloWorld" ];
      definition = "makes";
      environment = [ "ENV_VAR_FOR_MY_JOB" ];
      memory = 1800;
      queue = "ec2_spot";
      setup = [
        # Use default authentication for AWS
        outputs."/secretsForAwsFromEnv/__default__"
      ];
      vcpus = 1;
    };
  };
}
```

### Declarative infra, declarative CI/CD, pure profit

This is how creating a [CI/CD][ci_cd] pipeline
for deploying infrastructure with [Terraform][terraform]
and [Makes][makes] looks like:

```nix
# /path/to/my/project/makes.nix
{ outputs
, ...
}:
{
  # Authenticate securely 🛡 through environment variables
  secretsForTerraformFromEnv = {
    myAwesomeMicroService = {
      githubToken = "ENV_VAR_FOR_GITHUB_API_TOKEN";
      salesforceApiToken = "ENV_VAR_FOR_SALESFORCE_API_TOKEN";
    };
  };

  # Authenticate securely 🛡 to AWS with environment variables
  secretsForAwsFromEnv = {
    myAwesomeMicroService = {
      accessKeyId = "ENV_VAR_FOR_MY_APP_AWS_ACCESS_KEY_ID";
      secretAccessKey = "ENV_VAR_FOR_MY_APP_AWS_SECRET_ACCESS_KEY";
    };
  };

  # Deploy to production 🚀 !!
  deployTerraform = {
    modules = {
      myAwesomeMicroService = {
        setup = [
          outputs."/secretsForTerraformFromEnv/myAwesomeMicroService"
          outputs."/secretsForAwsFromEnv/myAwesomeMicroService"
        ];
        src = "/infra/microServices/myAwesomeMicroService";
        version = "0.14";
      };
    };
  };
}
```

Easy, isn't it?

Now 🔥 it up with: `$ m . /deployTerraform/myAwesomeMicroService`

```text
Makes v22.11-linux

[INFO] Making environment variables for Terraform for myAwesomeMicroService:
[INFO] - TF_VAR_githubToken from GITHUB_API_TOKEN
[INFO] - TF_VAR_salesforceApiToken from SALESFORCE_API_TOKEN

[INFO] Making secrets for AWS from environment variables for myAwesomeMicroService:
[INFO] - AWS_ACCESS_KEY_ID from MAKES_PROD_AWS_ACCESS_KEY_ID
[INFO] - AWS_CONFIG_FILE=/tmp/tmp.mSVQ2KvnaB
[INFO] - AWS_DEFAULT_REGION=us-east-1
[INFO] - AWS_SECRET_ACCESS_KEY from MAKES_PROD_AWS_SECRET_ACCESS_KEY
[INFO] - AWS_SESSION_TOKEN from AWS_SESSION_TOKEN
[INFO] - AWS_SHARED_CREDENTIALS_FILE=/tmp/tmp.ZMLtadaKhZ

[INFO] Initializing /nix/store/lwcrnykdfidang01ahnpwa8ylh1ihwxs-infra

Initializing the backend...
...

Initializing provider plugins...
- Installed hashicorp/aws v3.23.0 (signed by HashiCorp)
...

Terraform has been successfully initialized!
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

Live demo: [here](https://asciinema.org/a/479680)

### From dev to prod 🌟

This is how your final users are going to interact
with applications packaged with [Makes][makes]:

`$ m github:org/repo@branch /yourAwesomeApplication arg1 arg2 ...`

And how your developers are going to develop `yourAwesomeApplication` locally:

`$ m . /yourAwesomeApplication arg1 arg2 ...`

It works on dev, it works on prod, :100:% reproducibility!

## Production ready

Yes, [Makes][makes] is production ready.

Real life projects that run entirely on [Makes][makes]:

- [Fluid Attacks][fluid_attacks] monorepo:
  https://gitlab.com/fluidattacks/product

### Demos

- Running Makes on GitHub Actions:
  click [here](/static/makes_on_github_actions.png)
- Running Makes GitLab:
  click [here](/static/makes_on_gitlab.png)
- Makes CLI:
  click [here](https://asciinema.org/a/478175)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

# Contents

- [Why](#why)
- [Goal](#goal)
- [Getting started](#getting-started)
  - [Getting started as a final user](#getting-started-as-a-final-user)
  - [Getting started as developer](#getting-started-as-developer)
  - [Learning the language](#learning-the-language)
  - [Versioning scheme](#versioning-scheme)
    - [Versioning scheme for the framework](#versioning-scheme-for-the-framework)
    - [Compatibility information](#compatibility-information)
- [Configuring CI/CD](#configuring-cicd)
  - [Providers comparison](#providers-comparison)
    - [Configuring on GitHub Actions](#configuring-on-github-actions)
    - [Configuring on GitLab CI/CD](#configuring-on-gitlab-cicd)
    - [Configuring on Travis CI](#configuring-on-travis-ci)
  - [Configuring the cache](#configuring-the-cache)
- [Makes.nix reference](#makesnix-reference)
  - [Development](#development)
    - [dev](#dev)
  - [Format](#format)
    - [formatBash](#formatbash)
    - [formatMarkdown](#formatmarkdown)
    - [formatNix](#formatnix)
    - [formatPython](#formatpython)
    - [formatTerraform](#formatterraform)
    - [formatYaml](#formatyaml)
  - [Lint](#lint)
    - [lintBash](#lintbash)
    - [lintClojure](#lintclojure)
    - [lintGitCommitMsg](#lintgitcommitmsg)
    - [lintGitMailMap](#lintgitmailmap)
    - [lintMarkdown](#lintmarkdown)
    - [lintNix](#lintnix)
    - [lintPython](#lintpython)
    - [lintTerraform](#lintterraform)
    - [lintWithAjv](#lintwithajv)
    - [lintWithLizard](#lintwithlizard)
  - [Test](#test)
    - [testPython](#testpython)
    - [testTerraform](#testterraform)
  - [Security](#security)
    - [secureKubernetesWithRbacPolice](#securekuberneteswithrbacpolice)
    - [securePythonWithBandit](#securepythonwithbandit)
  - [Deploy](#deploy)
    - [computeOnAwsBatch](#computeonawsbatch)
    - [deployContainerImage](#deploycontainerimage)
    - [deployTerraform](#deployterraform)
    - [taintTerraform](#taintterraform)
    - [deployNomad](#deploynomad)
  - [Performance](#performance)
    - [cache](#cache)
  - [Environment](#environment)
    - [envVars](#envvars)
    - [envVarsForTerraform](#envvarsforterraform)
  - [Secrets](#secrets)
    - [secretsForAwsFromEnv](#secretsforawsfromenv)
    - [secretsForAwsFromGitlab](#secretsforawsfromgitlab)
    - [secretsForEnvFromSops](#secretsforenvfromsops)
    - [secretsForGpgFromEnv](#secretsforgpgfromenv)
    - [secretsForKubernetesConfigFromAws](#secretsforkubernetesconfigfromaws)
    - [secretsForTerraformFromEnv](#secretsforterraformfromenv)
  - [Utilities](#utilities)
    - [makeNodeJsLock](#makenodejslock)
    - [makePythonLock](#makepythonlock)
    - [makeRubyLock](#makerubylock)
    - [makeSopsEncryptedFile](#makesopsencryptedfile)
    - [workspaceForTerraformFromEnv](#workspaceforterraformfromenv)
  - [Framework Configuration](#framework-configuration)
    - [extendingMakesDirs](#extendingmakesdirs)
    - [inputs](#inputs)
  - [Database](#database)
    - [dynamoDb](#dynamodb)
  - [Examples](#examples)
    - [helloWorld](#helloworld)
  - [Monitoring](#monitoring)
    - [calculateScorecard](#calculatescorecard)
- [Extending Makes](#extending-makes)
  - [Main.nix format](#mainnix-format)
    - [Derivations](#derivations)
  - [Main.nix reference](#mainnix-reference)
    - [Fundamentals](#fundamentals)
      - [makeSearchPaths](#makesearchpaths)
      - [makeDerivation](#makederivation)
      - [makeTemplate](#maketemplate)
      - [makeScript](#makescript)
      - [projectPath](#projectpath)
    - [Fetchers](#fetchers)
      - [fetchUrl](#fetchurl)
      - [fetchArchive](#fetcharchive)
      - [fetchGithub](#fetchgithub)
      - [fetchGitlab](#fetchgitlab)
      - [fetchNixpkgs](#fetchnixpkgs)
      - [fetchRubyGem](#fetchrubygem)
    - [Git](#git)
      - [libGit](#libgit)
    - [Node.js](#nodejs)
      - [makeNodeJsVersion](#makenodejsversion)
      - [makeNodeJsModules](#makenodejsmodules)
      - [makeNodeJsEnvironment](#makenodejsenvironment)
    - [Python](#python)
      - [makePythonVersion](#makepythonversion)
      - [makePythonPypiEnvironment](#makepythonpypienvironment)
    - [Ruby](#ruby)
      - [makeRubyVersion](#makerubyversion)
      - [makeRubyGemsInstall](#makerubygemsinstall)
      - [makeRubyGemsEnvironment](#makerubygemsenvironment)
    - [Containers](#containers)
      - [makeContainerImage](#makecontainerimage)
    - [Format conversion](#format-conversion)
      - [fromJson](#fromjson)
      - [fromToml](#fromtoml)
      - [fromYaml](#fromyaml)
      - [toBashArray](#tobasharray)
      - [toBashMap](#tobashmap)
      - [toFileJson](#tofilejson)
      - [toFileJsonFromFileYaml](#tofilejsonfromfileyaml)
      - [toFileYaml](#tofileyaml)
    - [Patchers](#patchers)
      - [pathShebangs](#pathshebangs)
    - [Others](#others)
      - [chunks](#chunks)
      - [calculateCvss3](#calculatecvss3)
      - [makeSslCertificate](#makesslcertificate)
      - [sublist](#sublist)
- [Migrating to Makes](#migrating-to-makes)
  - [From a Nix project](#from-a-nix-project)
- [Contact an expert](#contact-an-expert)
- [Contributors](#contributors)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Why

Designing a fast, reliable, reproducible, easy-to-use
[CI/CD][ci_cd] system **is no easy task**.

While there are free and paid tools in the market like:
[Ansible][ansible],
[APT][apt],
[Apache Ant][apache_ant],
[Apache Maven][apache_maven],
[Buck][buck],
[Chef][chef],
[Docker][docker],
[Gradle][gradle],
[Grunt][grunt],
[Gulp][gulp],
[Maven][apache_maven],
[GNU Make][gnu_make],
[Leiningen][leiningen],
[NPM][npm],
[pip][pip],
[Packer][packer],
[Rake][rake],
[RPM][rpm],
[sbt][sbt],
[SCons][scons],
and
[yum][yum]:

1. Real world production systems are composed of several programming languages.

   Tools normally focus only 1.

1. Real world production systems contain hundreds of thousands of dependencies:

   - Compilers
   - Shared-Object libraries (.so)
   - Runtime interpreters
   - Configuration files
   - Vendor artifacts
   - Accounts / Credentials / Secrets

   Tools normally cannot fetch, configure, or setup such dependencies
   in an easy, automated, secure way.
   They just build or install.

1. Real world production systems have tens to hundreds of developers.
   They work across the globe from different machines,
   stacks and operative systems.

   Tools normally cannot guarantee all of them
   an exactly equal, comfortable developing environment.

1. Real world production systems
   have tens to thousands of production servers
   that need to be deployed to.

   Tools normally cover the: How to build? and not the: How to deploy?
   (or the other way around).

1. Real world production systems
   are made of several micro-components
   that one need to orchestrate correctly,
   or fix sunday morning, instead of sharing with family :parasol_on_ground:.

1. Real world production systems
   need to be **reliable** and **100% available**.

   But how with so much friction?

You can use [Nix][nix] instead, which features:

1. A single build-tool for everything

1. Easy, powerful, modular and expressive dependency declaration.
   From compilers to vendor artifacts.

1. Guarantees each developer an **exact**,
   [reproducible][reproducible_builds],
   comfortable environment in which to build and run stuff.
   Isolating as much as possible,
   reducing a lot of bugs along the way.
1. Defines a way for you to deploy software **perfectly**.

1. And therefore helps you build **reliable** and **100% available** systems.

So, if [Nix][nix] is that powerful: Why [Makes][makes], then?

1. [Makes][makes] stands on the shoulders of [Nix][nix].

1. [Makes][makes] is **specialized** on creating [CI/CD][ci_cd] systems
   that deliver **reliable** software to your end-users.

1. [Makes][makes] incorporates common workflows
   for formatting, linting, building, testing, managing infrastructure as code
   with [Terraform][terraform],
   deploying to [Kubernetes][kubernetes] clusters,
   creating development environments, etc.
   You can enable such workflows in a few clicks,
   with as little code as possible, in many providers.

1. [Makes][makes] hides unnecessary boilerplate and complexity
   so you can focus in the business:
   **Adding value** to your **customers**, daily!

# Goal

- :star2: Simplicity: Easy setup with:
  a laptop, or
  [Docker][docker], or
  [GitHub Actions][github_actions], or
  [GitLab CI][gitlab_ci], or
  [Travis CI][travis_ci], or
  [Circle CI][circle_ci],
  and more!
- :beers: Sensible defaults: **Good for all** projects of any size, **out-of-the-box**.
- :dancers: Reproducibility: **Any member** of your team
  builds and get **exactly the same results**.
- :woman_technologist: Dev environments:
  **Any member** of your team
  with the required secrets
  **can execute the entire CI/CD pipeline**.
- :horse_racing: Performance:
  A highly granular **caching** system
  so you only have to **build things once**.
- :shipit: Extendibility: You can add custom workflows, easily.

# Getting started

Makes is powered by [Nix][nix].
This means that Makes is able to run
on any of the [Nix's supported platforms][nix_platforms].

We have **thoroughly** tested it in
[x86_64][x86_64] hardware architectures
running Linux and MacOS (darwin) machines.

In order to use Makes you'll need to:

1. Make sure that Nix is installed on your system.
   If it is not, please follow [this tutorial][nix_download].

   If everything went well you should be able to run:

   ```bash
   $ nix --version
   ```

   Note: Makes is compatible with [Nix][nix] `2.9`.
   We recomend using [Nix][nix] on its latest version

1. Install Makes by running:

   `$ nix-env -if https://github.com/fluidattacks/makes/archive/22.11.tar.gz`

   We will install two commands in your system:
   `$ m`, and `$ m-v22.11`.

Makes targets two kind of users:

- Final users: People that want to use projects built with Makes.
- Developers: People who develop projects with Makes.

## Getting started as a final user

1. List outputs of a [Makes] project:

   - For GitHub [Makes][makes] projects, run:

     `$ m github:owner/repo@rev`

   - For GitLab [Makes][makes] projects, run:

     `$ m gitlab:owner/repo@rev`

1. Build and run an output: `$ m github:fluidattacks/makes@main /helloWorld 1 2 3`

   ```
   [INFO] Hello from Makes! Jane Doe.
   [INFO] You called us with CLI arguments: [ 1 2 3 ].
   ```

## Getting started as developer

1. Locate in the root of your project:

   `$ cd /path/to/my/project`

1. Create a configuration file named `makes.nix`
   with the following contents:

   ```nix
   # /path/to/my/project/makes.nix
   {
     helloWorld = {
       enable = true;
       name = "Jane Doe";
     };
   }
   ```

   We have tens of [CI/CD][ci_cd] actions
   that you can include in jour project as simple as this.

1. Now run makes!

   - List all available outputs: `$ m .`

     ```txt
     Outputs list for project: /path/to/my/project
       /helloWorld
     ```

   - Build and run an output: `$ m . /helloWorld 1 2 3`

     ```
     [INFO] Hello from Makes! Jane Doe.
     [INFO] You called us with CLI arguments: [ 1 2 3 ].
     ```

## Learning the language

Most of [Makes][makes] syntax
is written in [Bash][bash]
and the [Nix][nix] expression language.
We highly recommend you the following resources:

- [Bash][bash]:
  - [Shell Scripting Tutorial][bash_tutorial_shell_scripting]
- [Nix][nix] Expression Language:
  - [Nix Pills][nix_pills]

## Versioning scheme

We use [calendar versioning][calver].

You can assume that the current month release is stable,
for instance: `21.01` (if today were January 2021).
The stable version is frozen. We don't touch it under any circumstances.

Development/unstable releases are tagged with the next month
[calendar version][calver], for instance `21.02` (if today were January 2021).
Please don't use unstable releases in production.

The [Makes][makes] ecosystem has two components:
the framework itself, and the CLI (a.k.a. `$ m`).

### Versioning scheme for the framework

You can ensure
that your project is always evaluated
with the same version of [Makes][makes]
by creating a `makes.lock.nix` in the root of your project,
for instance:

```nix
# /path/to/my/project/makes.lock.nix
{
  makesSrc = builtins.fetchGit {
    url = "https://github.com/fluidattacks/makes";
    ref = "refs/tags/22.11";
    rev = ""; # Add a commit here
  };
}
```

### Compatibility information

For the whole ecosystem to work
you need to use the **same version**
of the framework and the CLI.
For example: `22.11`.

# Configuring CI/CD

## Providers comparison

We've thoroughly tested these providers throughout the years,
below is a small table that clearly expresses their trade-offs.

| Provider                         | Easy   | Config | Scale  | SaaS   | Security |
| -------------------------------- | ------ | ------ | ------ | ------ | -------- |
| [GitHub Actions][github_actions] | :star: | :star: |        | :star: |          |
| [GitLab CI/CD][gitlab_ci]        | :star: | :star: |        | :star: | :star:   |
| [Travis CI][travis_ci]           |        |        | :star: | :star: | :star:   |

If you are getting started in the world of [CI/CD][ci_cd]
it's a good idea to try [GitHub Actions][github_actions].

If you want **serious** security try [GitLab CI/CD][gitlab_ci].

We didn't like [Travis CI][travis_ci]
because managing encrypted secrets is ugly,
and it does not support running custom container images.

Notes:

- By deploying multiple runner agents (bastions)
  you can make of GitLab a highly scalable and cost-effective solution.

  This is not the out-of-the box behavior.

### Configuring on GitHub Actions

[GitHub Actions][github_actions]
is configured through [workflow files][github_workflows]
located in a `.github/workflows` directory in the root of the project.

The smallest possible [workflow file][github_workflows]
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
      - uses: docker://ghcr.io/fluidattacks/makes:22.11
        # You can use any name you like here
        name: helloWorld
        # You can pass secrets (if required) as environment variables like this:
        env:
          SECRET_NAME: ${{ secrets.SECRET_IN_YOUR_GITHUB }}
        with:
          args: m . /helloWorld 1 2 3

  # Add more jobs here, you can copy paste jobs.helloWorld and modify the `args`
```

### Configuring on GitLab CI/CD

[GitLab CI/CD][gitlab_ci]
is configured through a [.gitlab-ci.yaml][gitlab_ci_ref] file
located in the root of the project.

The smallest possible [.gitlab-ci.yaml][gitlab_ci_ref]
looks like this:

```yaml
# /path/to/my/project/.gitlab-ci.yaml
/helloWorld:
  image: ghcr.io/fluidattacks/makes:22.11
  script:
    - m . /helloWorld 1 2 3
# Add more jobs here, you can copy paste /helloWorld and modify the `script`
```

Secrets can be propagated to Makes through [GitLab Variables][gitlab_vars],
which are passed automatically to the running container
as environment variables.

### Configuring on Travis CI

[Travis CI][travis_ci]
is configured through a [.travis.yml][travis_ci_ref] file
located in the root of the project.

The smallest possible [.travis.yml][travis_ci_ref]
looks like this:

```yaml
# /path/to/my/project/.travis.yml
os: linux
language: nix
nix: 2.3.12
install: nix-env -if https://github.com/fluidattacks/makes/archive/22.11.tar.gz
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
[Travis Environment Variables][travis_env_vars],
which are passed automatically to the running container
as environment variables.
We highly recommend you to use encrypted environment variables as
explained in the [Travis Environment Variables Reference][travis_env_vars].

## Configuring the cache

If your CI/CD will run on different machines
then it's a good idea
to setup a distributed cache system with [Cachix][cachix].

In order to do this:

1. Create or sign-up to your [Cachix][cachix] account.
1. Create a new cache with:
   - Write access: `API token`.
   - Read access: `Public` or `Private`.
1. Configure `makes.nix` as explained in the following sections

# Makes.nix reference

A Makes project is identified by a `makes.nix` file
in the top level directory.

A `makes.nix` file should be:

- An attribute set of configuration options:

  ```nix
  {
    configOption1 = {
      # ...
    };
    configOption2 = {
      # ...
    };
  }
  ```

- A function that receives one or more arguments
  and returns an attribute set of configuration options:

  ```nix
  { argA
  , argB
  , ...
  }:
  {
    configOption1 = {
      # ...
    };
    configOption2 = {
      # ...
    };
  }
  ```

Below we document all configuration options you can tweak in a `makes.nix`.

## Development

### dev

Create declarative development environments.

Can be used with [direnv][direnv]
to make your shell automatically load
the development environment and its required dependencies.

Types:

- dev (`attrsOf (asIn makeSearchPaths)`): Optional.
  Mapping of environment name to searchPaths.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ inputs
, ...
}:
{
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };

  dev = {
    example = {
      # A development environment with `hello` package
      bin = [
        inputs.nixpkgs.hello
      ];
    };
  };
}
```

Example invocation: `$ m . /dev/example`

---

Example usage with [direnv][direnv]
on remote projects:

```bash
$ cat /path/to/some/dir/.envrc

    source "$(m github:fluidattacks/makes@main /dev/example)/template"

# Now every time you enter /path/to/some/dir
# the shell will automatically load the environment
$ cd /path/to/some/dir

    direnv: loading /path/to/some/dir/.envrc
    direnv: export ~PATH

/path/to/some/dir $ hello

    Hello, world!

# If you exit the directory, the development environment is unloaded
/path/to/some/dir $ cd ..

    direnv: unloading

/path/to/some $ hello

    hello: command not found
```

---

Example usage with [direnv][direnv]
on a local project:

```bash
$ cat /path/to/some/dir/.envrc

    cd /path/to/my/project
    source "$(m . /dev/example)/template"

# Now every time you enter /path/to/some/dir
# the shell will automatically load the environment
$ cd /path/to/some/dir

    direnv: loading /path/to/some/dir/.envrc
    direnv: export ~PATH

/path/to/some/dir $ hello

    Hello, world!

# If you exit the directory, the development environment is unloaded
/path/to/some/dir $ cd ..

    direnv: unloading

/path/to/some $ hello

    hello: command not found
```

## Format

Formatters help your code be consistent, beautiful and more maintainable.

### formatBash

Ensure that Bash code is formatted according to [shfmt][shfmt].

Types:

- formatBash:
  - enable (`boolean`): Optional.
    Defaults to false.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

```nix
{
  formatBash = {
    enable = true;
    targets = [
      "/" # Entire project
      "/file.sh" # A file
      "/directory" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /formatBash`

### formatMarkdown

:warning: This function is only available on Linux at the moment.

Ensure that Markdown code is formatted according to [doctoc][doctoc].

Types:

- formatMarkdown:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - doctocArgs (`listOf str`): Optional.
    Extra CLI flags to propagate to [doctoc][doctoc].
    Defaults to `[ ]`.
  - targets (`listOf str`):
    Files (relative to the project) to format.

Example `makes.nix`:

```nix
{
  formatMarkdown = {
    enable = true;
    doctocArgs = [ "--title" "# Contents" ];
    targets = [ "/README.md" ];
  };
}
```

Example invocation: `$ m . /formatMarkdown`

### formatNix

Ensure that Nix code is formatted according to [Alejandra][alejandra].

Types:

- formatNix:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

```nix
{
  formatNix = {
    enable = true;
    targets = [
      "/" # Entire project
      "/file.nix" # A file
      "/directory" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /formatNix`

### formatPython

Ensure that Python code is formatted according to [Black][black]
and [isort][isort].

Types:

- formatPython:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

```nix
{
  formatPython = {
    enable = true;
    targets = [
      "/" # Entire project
      "/file.py" # A file
      "/directory" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /formatPython`

### formatTerraform

Ensure that [Terraform][terraform] code
is formatted according to [Terraform FMT][terraform_fmt].

Types:

- formatTerraform:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

```nix
{
  formatTerraform = {
    enable = true;
    targets = [
      "/" # Entire project
      "/main.tf" # A file
      "/terraform/module" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /formatTerraform`

### formatYaml

Ensure that [YAML][yaml] code
is formatted according to [yamlfix][yamlfix].

Types:

- formatYaml:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to format.
    Defaults to the entire project.

Example `makes.nix`:

```nix
{
  formatYaml = {
    enable = true;
    targets = [
      "/" # Entire project
      "/main.yaml" # A file
      "/yamls/" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /formatYaml`

## Lint

Linters ensure source code follows
best practices.

### lintBash

Lints Bash code with [ShellCheck][shellcheck].

Types:

- lintBash:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to lint.
    Defaults to the entire project.

Example `makes.nix`:

```nix
{
  lintBash = {
    enable = true;
    targets = [
      "/" # Entire project
      "/file.sh" # A file
      "/directory" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /lintBash`

### lintClojure

Lints clojure code with [clj-kondo][clj-kondo].

Types:

- lintClojure (`attrsOf (listOf str)`): Optional.
  Mapping of custom names to lists of paths (relative to the project) to lint.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{
  lintClojure = {
    example1 = [
      "/" # Entire project
      "/file.clj" # A file
    ];
    example2 = [
      "/directory" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /lintClojure/example1`

Example invocation: `$ m . /lintClojure/example2`

### lintGitCommitMsg

:warning: This function is only available on Linux at the moment.

It creates a commit diff
between you current branch
and the main branch of the repository.
All commits included in the diff
are linted using [Commitlint][commitlint].

Types:

- lintGitCommitMsg:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - branch (`str`): Optional.
    Name of the main branch.
    Defaults to `main`.
  - config (`str`): Optional.
    Path to a configuration file for [Commitlint][commitlint].
    Defaults to
    [config.js](./src/evaluator/modules/lint-git-commit-msg/config.js).
  - parser (`str`): Optional.
    [Commitlint][commitlint] parser definitions.
    Defaults to
    [parser.js](./src/evaluator/modules/lint-git-commit-msg/parser.js).

Example `makes.nix`:

```nix
{
  lintGitCommitMsg = {
    enable = true;
    branch = "my-branch-name";
    # If you want to use custom configs or parsers you can do it like this:
    # config = "/src/config/config.js";
    # parser = "/src/config/parser.js";
  };
}
```

Example invocation: `$ m . /lintGitCommitMsg`

### lintGitMailMap

Lint the [Git][git] [MailMap][git_mailmap] of the project
with [MailMap Linter][mailmap_linter].

Types:

- lintGitMailmap:
  - enable (`boolean`): Optional.
    Defaults to `false`.

Example `makes.nix`:

```nix
{
  lintGitMailMap = {
    enable = true;
  };
}
```

Example invocation: `$ m . /lintGitMailMap`

### lintMarkdown

Lints Markdown code with [Markdown lint tool][markdown_lint].

Types:

- lintMarkdown (`attrsOf moduleType`): Optional.
  Definitions of config and associated paths to lint.
  Defaults to `{ }`.
- moduleType (`submodule`):
  - config (`str`): Optional.
    Path to the config file.
    Defaults to [config.rb](./src/evaluator/modules/lint-markdown/config.rb).
  - targets (`listOf str`): Required.
    paths to lint with `config`.

Example `makes.nix`:

```nix
{
  lintMarkdown = {
    all = {
      # You can pass custom configs like this:
      # config = "/src/config/markdown.rb";
      targets = [ "/" ];
    };
    others = {
      targets = [ "/others" ];
    };
  };
}
```

Example invocation: `$ m . /lintMarkdown/all`

Example invocation: `$ m . /lintMarkdown/others`

### lintNix

Lints Nix code with [nix-linter][nix_linter].

Types:

- lintNix:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - targets (`listOf str`): Optional.
    Files or directories (relative to the project) to lint.
    Defaults to the entire project.

Example `makes.nix`:

```nix
{
  lintNix = {
    enable = true;
    targets = [
      "/" # Entire project
      "/file.nix" # A file
      "/directory" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /lintNix`

### lintPython

Lints Python code with [mypy][mypy], [Prospector][prospector]
and (if configured) [import-linter][import_linter].

Types:

- lintPython:
  - dirsOfModules (`attrsOf dirOfModulesType`): Optional.
    Definitions of directories of python packages/modules to lint.
    Defaults to `{ }`.
  - imports (`attrsOf importsType`): Optional.
    Definitions of python packages whose imports will be linted.
    Defaults to `{ }`.
  - modules (`attrsOf moduleType`): Optional.
    Definitions of python packages/modules to lint.
    Defaults to `{ }`.
- dirOfModulesType (`submodule`):
  - python (`enum ["3.8" "3.9" "3.10" "3.11"]`):
    Python interpreter version that your package/module is designed for.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.
  - src (`str`):
    Path to the directory that contains inside many packages/modules.
- importsType (`submodule`):
  - config (`str`):
    Path to the [import-linter][import_linter] configuration file.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.
  - src (`str`):
    Path to the package/module.
- moduleType (`submodule`):
  - python (`enum ["3.8" "3.9" "3.10" "3.11"]`):
    Python interpreter version that your package/module is designed for.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.
  - src (`str`):
    Path to the package/module.

Example `makes.nix`:

```nix
{
  lintPython = {
    dirsOfModules = {
      makes = {
        python = "3.8";
        src = "/src/cli";
      };
    };
    imports = {
      cli = {
        config = "/src/cli/imports.cfg";
        src = "/src/cli";
      };
    };
    modules = {
      cliMain = {
        python = "3.8";
        src = "/src/cli/main";
      };
    };
  };
}
```

Example invocation: `$ m . /lintPython/dirOfModules/makes`

Example invocation: `$ m . /lintPython/dirOfModules/makes/main`

Example invocation: `$ m . /lintPython/module/cliMain`

### lintTerraform

Lint [Terraform][terraform] code
with [TFLint][tflint].

Types:

- lintTerraform:
  - config (`str`): Optional.
    Path to a [TFLint][tflint] configuration file.
    Defaults to [config.hcl](./src/evaluator/modules/lint-terraform/config.hcl).
  - modules (`attrsOf moduleType`): Optional.
    Path to [Terraform][terraform] modules to lint.
    Defaults to `{ }`.
- moduleType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`str`):
    Path to the [Terraform][terraform] module.
  - version (`enum [ "0.14" "0.15" "1.0" ]`):
    [Terraform][terraform] version your module is built with.

Example `makes.nix`:

```nix
{
  lintTerraform = {
    # You can use a custom configuration like this:
    # config = "/src/config/tflint.hcl";
    modules = {
      module1 = {
        src = "/my/module1";
        version = "0.14";
      };
      module2 = {
        src = "/my/module2";
        version = "0.15";
      };
    };
  };
}
```

Example invocation: `$ m . /lintTerraform/module1`

Example invocation: `$ m . /lintTerraform/module2`

### lintWithAjv

:warning: This function is only available on Linux at the moment.

Lints [JSON][json] and [YAML][yaml] data files
with [JSON Schemas][json_schema].
It uses [ajv-cli][ajv_cli].

Types:

- lintWithAjv (`attrsOf schemaType`): Optional.
  Definitions of schema and associated data to lint.
  Defaults to `{ }`.
- schemaType (`submodule`):
  - schema (`str`): Required.
    Path to the [JSON Schema][json_schema].
  - targets (`listOf str`): Required.
    [YAML][yaml] or [JSON][json]
    data files to lint with `schema`.

Example `makes.nix`:

```nix
{
  lintWithAjv = {
    users = {
      schema = "/users/schema.json";
      targets = [
        "/users/data1.json"
        "/users/data.yaml"
      ];
    };
    colors = {
      schema = "/colors/schema.json";
      targets = [
        "/colors/data1.json"
        "/colors/data2.yaml"
      ];
    };
  };
}
```

Example invocation: `$ m . /lintWithAjv/users`

Example invocation: `$ m . /lintWithAjv/colors`

### lintWithLizard

Using [Lizard][lizard] to check
Ciclomatic Complexity and functions length
in all supported languages by [Lizard][lizard]

Types:

- lintWithLizard (`attrsOf (listOf str)`): Optional.
  Mapping of custom names to lists of paths (relative to the project) to lint.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{
  lintWithLizard = {
    example1 = [
      "/" # Entire project
      "/file.py" # A file
    ];
    example2 = [
      "/directory" # A directory within the project
    ];
  };
}
```

Example invocation: `$ m . /lintWithLizard/example1`

Example invocation: `$ m . /lintWithLizard/example2`

## Test

### testPython

Test [Python][python] code
with [pytest][pytest].

Types:

- testPython (`attrsOf targetType`): Optional.
  Mapping of names to [pytest][pytest] targets.
  Defaults to `{ }`.
- targetType (`submodule`):

  - python (`enum ["3.8" "3.9" "3.10" "3.11"]`):
    Python interpreter version that your package/module is designed for.
  - src (`str`):
    Path to the file or directory that contains the tests code.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.
  - extraFlags (`listOf str`): Optional.
    Extra command line arguments to propagate to [pytest][pytest].
    Defaults to `[ ]`.
  - extraSrcs (`attrsOf package`): Optional.
    Place extra sources at the same level of your project code
    so you can reference them via relative paths.

    The final test structure looks like this:

    ```bash
    /tmp/some-random-unique-dir
    ├── __project__  # The entire source code of your project
    │   ├── ...
    │   └── path/to/src
    ... # repeat for all extraSrcs
    ├── "${extraSrcName}"
    │   └── "${extraSrcValue}"
    ...
    ```

    And we will run [pytest][pytest] like this:

    `$ pytest /tmp/some-random-unique-dir/__project__/path/to/src`

    Defaults to `{ }`.

Example `makes.nix`:

```nix
{
  testPython = {
    example = {
      python = "3.9";
      src = "/test/test-python";
    };
  };
}
```

```bash
$ tree test/test-python/

  test/test-python/
  └── test_something.py

$ cat test/test-python/test_something.py

  1 def test_one_plus_one_equals_two() -> None:
  2     assert (1 + 1) == 2
```

Example invocation: `$ m . /testPython/example`

### testTerraform

Test [Terraform][terraform] code
by performing a `terraform plan`
over the specified [Terraform][terraform] modules.

Types:

- testTerraform:
  - modules (`attrsOf moduleType`): Optional.
    Path to [Terraform][terraform] modules to lint.
    Defaults to `{ }`.
- moduleType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`str`):
    Path to the [Terraform][terraform] module.
  - version (`enum [ "0.14" "0.15" "1.0" ]`):
    [Terraform][terraform] version your module is built with.
  - debug (`bool`): Optional.
    Enable maximum level of debugging
    and remove parallelism so logs are clean.
    Defaults to `false`.

Example `makes.nix`:

```nix
{
  testTerraform = {
    modules = {
      module1 = {
        src = "/my/module1";
        version = "0.14";
      };
      module2 = {
        src = "/my/module2";
        version = "1.0";
      };
    };
  };
}
```

Example invocation: `$ m . /testTerraform/module1`

Example invocation: `$ m . /testTerraform/module2`

## Security

### secureKubernetesWithRbacPolice

:warning: This function is only available on Linux at the moment.

Secure Kubernetes clusters with [rbac-police][rbac-police].

Types:

- secureKubernetesWithRbacPolice (`attrsOf kubernetesWithRbacPolice`): Optional.
  Defaults to `{ }`.
- kubernetesWithRbacPolice (`submodule`):

  - severity (`str`):
    Only evaluate policies with severity >= threshold.
    Defaults to `Low`.

  - setup (`listOf package`):
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.

Example `makes.nix`:

```nix
{ outputs
, secretsForAwsFromGitlab
, secretsForKubernetesConfigFromAws
, secureKubernetesWithRbacPolice
, ...
}:
{
  secretsForAwsFromGitlab = {
    makesProd = {
      roleArn = "arn:aws:iam::123456789012:role/prod";
      duration = 7200;
      retries = 30;
    };
  };
  secretsForKubernetesConfigFromAws = {
    makes = {
      cluster = "makes-k8s";
      region = "us-east-1";
    };
  };
  secureKubernetesWithRbacPolice = {
    makes = {
      severity = "Low";
      setup = [
        outputs."/secretsForAwsFromGitlab/makesProd"
        outputs."/secretsForKubernetesConfigFromAws/makes"
      ];
    };
  };
}
```

Example invocation: `$ m . /secureKubernetesWithRbacPolice/makes`

### securePythonWithBandit

Secure Python code with [Bandit][bandit].

Types:

- securePythonWithBandit (`attrsOf projectType`): Optional.
  Definitions of directories of python packages/modules to lint.
  Defaults to `{ }`.
- projectType (`submodule`):
  - python (`enum ["3.8" "3.9" "3.10" "3.11"]`):
    Python interpreter version that your package/module is designed for.
  - target (`str`):
    Relative path to the package/module.

Example `makes.nix`:

```nix
{
  securePythonWithBandit = {
    cli = {
      python = "3.8";
      target = "/src/cli";
    };
  };
}
```

Example invocation: `$ m . /securePythonWithBandit/cli`

## Deploy

### computeOnAwsBatch

Submit a job to an [AWS BATCH][aws_batch] queue.

Types:

- computeOnAwsBatch (`attrsOf jobType`): Optional.
  Job groups to submit.
  Defaults to `{ }`.
- jobType (`submodule`):

  - allowDuplicates (`bool`): Optional.
    Set to `false` in order to prevent submitting the job
    if there is already a job in the queue with the same name.
    Defaults to `false`.
  - attempts (`ints.positive`): Optional.
    If the value of attempts is greater than one,
    the job is retried on failure the same number of attempts as the value.
    Defaults to `1`.
  - attemptDurationSeconds (`ints.positive`): Optional.
    The time duration in seconds
    (measured from the job attempt's startedAt timestamp)
    after which [AWS Batch][aws_batch] terminates your jobs
    if they have not finished.
  - command (`listOf str`):
    The command to send to the container.
    It overrides the one specified
    in the [AWS Batch][aws_batch] job definition.
    Additional arguments can be propagated when running this module output.
  - definition (`str`):
    Name of the [AWS Batch][aws_batch] job definition
    that we will use as base for submitting the job.
    In general an [AWS Batch][aws_batch] job definition is required
    in order to specify which container image
    our job is going to run on.

    The most basic [AWS Batch][aws_batch] job definition
    to run a [Makes][makes] job is (in [Terraform][terraform] syntax):

    ```tf
    resource "aws_batch_job_definition" "makes" {
      name = "makes"
      type = "container"
      container_properties = jsonencode({
        # This image cannot be parametrized later.
        #
        # If you need to run jobs on different container images,
        # simply  create many `aws_batch_job_definition`s
        image = "ghcr.io/fluidattacks/makes:22.11"

        # Below arguments can be parametrized later,
        # but they are required for the job definition to be created
        # so let's put some dummy values here
        memory  = 512
        vcpus   = 1
      })
    }
    ```

  - environment (`listOf str`): Optional.
    Name of the environment variables
    whose names and values should be copied from the machine running Makes
    to the machine on [AWS Batch][aws_batch] running the job.
    Defaults to `[ ]`.
  - includePositionalArgsInName (`bool`): Optional.
    Enable to make positional arguments part of the job name.
    This is useful for identifying jobs
    in the [AWS Batch][aws_batch] console
    more easily.
    Defaults to `true`.
  - memory (`ints.positive`):
    Amount of memory, in MiB that is reserved for the job.
  - parallel (`ints.positive`): Optional.
    Number of parallel jobs to trigger using
    [Batch Array Jobs](https://docs.aws.amazon.com/batch/latest/userguide/array_jobs.html).
  - propagateTags (`bool`): Optional.
    Enable tags to be propagated into the ECS tasks.
    Defaults to `true`.
  - queue (`nullOr str`):
    Name of the [AWS Batch][aws_batch] queue we should submit the job to.
    It can be set to `null`,
    causing Makes to read
    the `MAKES_COMPUTE_ON_AWS_BATCH_QUEUE` environment variable at runtime.
  - setup (`listOf package`):
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - tags (`attrsOf str`): Optional.
    Tags to apply to the batch job.
    Defaults to `{ }`.
  - vcpus (`ints.positive`):
    Amount of virtual CPUs that is reserved for the job.

Example `makes.nix`:

```nix
{ outputs
, ...
}:
{
  computeOnAwsBatch = {
    helloWorld = {
      attempts = 1;
      attemptDurationSeconds = 43200;
      command = [ "m" "github:fluidattacks/makes@main" "/helloWorld" ];
      definition = "makes";
      environment = [ "ENV_VAR_FOR_WHATEVER" ];
      memory = 1800;
      queue = "ec2_spot";
      setup = [
        # Use default authentication for AWS
        outputs."/secretsForAwsFromEnv/__default__"
      ];
      tags = {
        "Management:Product" = "awesome_app";
      }
      vcpus = 1;
    };
  };
}
```

Example invocation: `$ m . /computeOnAwsBatch/helloWorld`

Example invocation: `$ m . /computeOnAwsBatch/helloWorld 1 2 3`

Note that positional arguments (`[ "1" "2" "3" ]` in this case)
will be appended to the end of `command`
before sending the job to [AWS Batch][aws_batch].

### deployContainerImage

Deploy a set of container images in [OCI Format][oci_format]
to the specified container registries.

For details on how to build container images in [OCI Format][oci_format]
please read the `makeContainerImage` reference.

Types:

- deployContainerImage:
  - images (`attrsOf imageType`): Optional.
    Definitions of container images to deploy.
    Defaults to `{ }`.
- imageType (`submodule`):
  - attempts (`ints.positive`): Optional.
    If the value of attempts is greater than one,
    the job is retried on failure the same number of attempts as the value.
    Defaults to `1`.
  - credentials:
    - token (`str`):
      Name of the [environment variable][env_var]
      that stores the value of the registry token.
    - user (`str`):
      Name of the [environment variable][env_var]
      that stores the value of the registry user.
  - registry (`str`):
    Registry in which the image will be copied to.
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`package`):
    Derivation that contains the container image in [OCI Format][oci_format].
  - tag (`str`):
    The tag under which the image will be stored in the registry.

Example `makes.nix`:

```nix
{ inputs
, outputs
, ...
}:
{
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };

  deployContainerImage = {
    images = {
      nginxDockerHub = {
        credentials = {
          token = "DOCKER_HUB_PASS";
          user = "DOCKER_HUB_USER";
        };
        src = inputs.nixpkgs.dockerTools.examples.nginx;
        registry = "docker.io";
        tag = "fluidattacks/nginx:latest";
      };
      redisGitHub = {
        credentials = {
          token = "GITHUB_TOKEN";
          user = "GITHUB_ACTOR";
        };
        src = inputs.nixpkgs.dockerTools.examples.redis;
        registry = "ghcr.io";
        tag = "fluidattacks/redis:$(date +%Y.%m)"; # Tag from command
      };
      makesGitLab = {
        credentials = {
          token = "CI_REGISTRY_PASSWORD";
          user = "CI_REGISTRY_USER";
        };
        src = outputs."/containerImage";
        registry = "registry.gitlab.com";
        tag = "fluidattacks/product/makes:$MY_VAR"; # Tag from env var
      };
    };
  };
```

Example invocation: `$ DOCKER_HUB_USER=user DOCKER_HUB_PASS=123 m . /deployContainerImage/nginxDockerHub`

Example invocation: `$ GITHUB_ACTOR=user GITHUB_TOKEN=123 m . /deployContainerImage/makesGitHub`

Example invocation: `$ CI_REGISTRY_USER=user CI_REGISTRY_PASSWORD=123 m . /deployContainerImage/makesGitLab`

### deployTerraform

Deploy [Terraform][terraform] code
by performing a `terraform apply`
over the specified [Terraform][terraform] modules.

Types:

- deployTerraform:
  - modules (`attrsOf moduleType`): Optional.
    Path to [Terraform][terraform] modules to lint.
    Defaults to `{ }`.
- moduleType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`str`):
    Path to the [Terraform][terraform] module.
  - version (`enum [ "0.14" "0.15" "1.0" ]`):
    [Terraform][terraform] version your module is built with.

Example `makes.nix`:

```nix
{
  deployTerraform = {
    modules = {
      module1 = {
        src = "/my/module1";
        version = "0.14";
      };
      module2 = {
        src = "/my/module2";
        version = "1.0";
      };
    };
  };
}
```

Example invocation: `$ m . /deployTerraform/module1`

Example invocation: `$ m . /deployTerraform/module2`

### taintTerraform

Taint [Terraform][terraform] code
by performing a `terraform taint $resource`
over the specified [Terraform][terraform] modules.

Types:

- taintTerraform:
  - modules (`attrsOf moduleType`): Optional.
    Path to [Terraform][terraform] modules to lint.
    Defaults to `{ }`.
- moduleType (`submodule`):
  - reDeploy (`bool`): Optional.
    Perform a `terraform apply` after tainting resources.
    Defaults to `false`.
  - resources (`listOf str`):
    Resources to taint.
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`str`):
    Path to the [Terraform][terraform] module.
  - version (`enum [ "0.14" "0.15" "1.0" ]`):
    [Terraform][terraform] version your module is built with.

Example `makes.nix`:

```nix
{
  taintTerraform = {
    modules = {
      module = {
        resources = [ "null_resource.example" ];
        src = "/test/terraform/module";
        version = "0.14";
      };
    };
  };
}
```

Example invocation: `$ m . /taintTerraform/module`

### deployNomad

Deploy [Nomad][nomad] code
by performing a `nomad plan`
over the specified [Nomad][nomad] jobs / namespaces.

Types:

- deployNomad:
  - jobs (`attrsOf jobsType`): Optional.
    Path to [Nomad][nomad] jobs to deploy.
    Defaults to `{ }`.
  - namespaces (`attrsOf namespacesType`): Optional.
    Path to [Nomad][nomad] namespaces to deploy.
    Defaults to `{ }`.
- jobsType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`path`):
    Path to the [Nomad][nomad] job (hcl or json).
  - version (`enum [ "1.0" "1.1" ]`):
    [Nomad][nomad] version your job is built with.
    Defaults to `"1.1"`.
  - namespace (`str`):
    [Nomad][nomad] namespace to deploy the job into.
- namespacesType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - jobs (`attrOf path`):
    Attributes of path to the [Nomad][nomad] jobs (hcl or json).
  - version (`enum [ "1.0" "1.1" ]`):
    [Nomad][nomad] version your jobs are built with.
    Defaults to `"1.1"`.

Example `makes.nix`:

```nix
{
  deployNomad = {
    jobs = {
      job1 = {
        src = ./my/job1.hcl;
        namespace = "default";
      };
      job2 = {
        src = ./my/job2.json;
        namespace = "default";
      };
    };
    namespaces = {
      dev.jobs = {
        job1 = ./my/dev/job1.hcl;
        job2 = ./my/dev/job2.json;
      };
      staging.jobs = {
        job1 = ./my/staging/job1.hcl;
        job2 = ./my/staging/job2.json;
      };
    };
  };
}
```

Example invocation: `$ m . /deployNomad/default/job1`

Example invocation: `$ m . /deployNomad/staging/job2`

## Performance

### cache

Configure caches to read,
and optionally a [Cachix][cachix] cache for reading and writting.

Types:

- cache:
  - readNixos (`bool`): Optional.
    Set to `true` in order to add https://cache.nixos.org as a read cache.
    Defaults to `true`.
  - readExtra (`listOf readCacheType`): Optional.
    Extra caches to read, if any.
    Defaults to `[ ]`.
  - readAndWrite:
    - enable (`boolean`): Optional.
      Defaults to `false`.
    - name (`str`):
      Name of the [Cachix][cachix] cache.
    - pubKey (`str`):
      Public key of the [Cachix][cachix] cache.
- readCacheType (`submodule`):
  - url (`str`):
    URL of the cache.
  - pubKey (`str`):
    Public key of the cache.

Required environment variables:

- `CACHIX_AUTH_TOKEN`: API token of the [Cachix][cachix] cache.
  - For Public caches:
    If not set the cache will be read, but not written to.
  - For private caches:
    If not set the cache won't be read, nor written to.

Example `makes.nix`:

```nix
{
  cache = {
    readNixos = true;
    readExtra = [
      {
        url = "https://example.com";
        pubKey = "example.example.org-1:123...";
      }
      {
        url = "https://example2.com";
        pubKey = "example2.example2.org-1:123...";
      }
    ];
    readAndWrite = {
      enable = true;
      name = "makes";
      pubKey = "makes.cachix.org-1:HbCQcdlYyT/mYuOx6rlgkNkonTGUjVr3D+YpuGRmO+Y=";
    };
  };
}
```

## Environment

### envVars

:warning: Do not propagate sensitive information here, it's not safe.
Use [Makes Secrets][makes_secrets] instead.

Allows you to map environment variables from a name to a value.

Types:

- envVars (`attrsOf (attrsOf str)`): Optional.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ inputs
, outputs
, ...
}:
{
  envVars = {
    example = {
      # Equals to: export awsDefaultRegion=us-east-1
      awsDefaultRegion = "us-east-1";
    };
    otherExample = {
      # Equals to: export license=/nix/store/...-my-license
      license = outputs."/MyLicense";
      # Equals to: export bash=/nix/store/...-bash
      bash = inputs.nixpkgs.bash;
    };
  };
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };
}
```

Example invocation: `$ m . /envVars/example`

Example invocation: `$ m . /envVars/otherExample`

### envVarsForTerraform

:warning: Do not propagate sensitive information here, it's not safe.
Use [Makes Secrets][makes_secrets] instead.

Allows you to map [Terraform][terraform] variables from a name to a value.

Types:

- envVarsForTerraform (`attrsOf (attrsOf str)`): Optional.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ inputs
, outputs
, ...
}:
{
  envVarsForTerraform = {
    example = {
      # Equals to: export TF_VAR_awsDefaultRegion=us-east-1
      awsDefaultRegion = "us-east-1";
    };
    otherExample = {
      # Equals to: export TF_VAR_license=/nix/store/...-my-license
      license = outputs."/MyLicense";
      # Equals to: export TF_VAR_bash=/nix/store/...-bash
      bash = inputs.nixpkgs.bash;
    };
  };
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };
}
```

Example `main.tf`:

```tf
variable "awsDefaultRegion" {}
```

Example invocation: `$ m . /envVarsForTerraform/example`

Example invocation: `$ m . /envVarsForTerraform/otherExample`

## Secrets

Managing secrets is critical for application security.

The following functions are secure
and allow you to re-use secrets
across different [Makes][makes] components.

### secretsForAwsFromEnv

Load [Amazon Web Services (AWS)][aws] secrets
from [Environment Variables][env_var].

Types:

- secretsForAwsFromEnv (`attrsOf awsFromEnvType`): Optional.
  Defaults to `{ }`.
- awsFromEnvType (`submodule`):

  - accessKeyId (`str`): Optional.
    Name of the [environment variable][env_var]
    that stores the value of the [AWS][aws] Access Key Id.
    Defaults to `"AWS_ACCESS_KEY_ID"`.

  - defaultRegion (`str`): Optional.
    Name of the [environment variable][env_var]
    that stores the value of the [AWS][aws] Default Region.
    Defaults to `"AWS_DEFAULT_REGION"` (Which defaults to `"us-east-1"`).

  - secretAccessKey (`str`): Optional.
    Name of the [environment variable][env_var]
    that stores the value of the [AWS][aws] Secret Access Key.
    Defaults to `"AWS_SECRET_ACCESS_KEY"`.

  - sessionToken (`str`): Optional.
    Name of the [environment variable][env_var]
    that stores the value of the [AWS][aws] Session Token.
    Defaults to `"AWS_SESSION_TOKEN"` (Which defaults to `""`).

Always available outputs:

- `/secretsForAwsFromEnv/__default__`:
  - accessKeyId: "AWS_ACCESS_KEY_ID";
  - defaultRegion: "AWS_DEFAULT_REGION";
  - secretAccessKey: "AWS_SECRET_ACCESS_KEY";
  - sessionToken: "AWS_SESSION_TOKEN";

Example `makes.nix`:

```nix
{ outputs
, lintTerraform
, secretsForAwsFromEnv
, ...
}:
{
  secretsForAwsFromEnv = {
    makesDev = {
      accessKeyId = "ENV_VAR_FOR_MAKES_DEV_AWS_ACCESS_KEY_ID";
      secretAccessKey = "ENV_VAR_FOR_MAKES_DEV_AWS_SECRET_ACCESS_KEY";
    };
    makesProd = {
      accessKeyId = "ENV_VAR_FOR_MAKES_PROD_AWS_ACCESS_KEY_ID";
      secretAccessKey = "ENV_VAR_FOR_MAKES_PROD_AWS_SECRET_ACCESS_KEY";
    };
  };
  lintTerraform = {
    modules = {
      moduleDev = {
        setup = [
          outputs."/secretsForAwsFromEnv/makesDev"
        ];
        src = "/my/module1";
        version = "0.14";
      };
      moduleProd = {
        setup = [
          outputs."/secretsForAwsFromEnv/makesProd"
        ];
        src = "/my/module2";
        version = "0.14";
      };
    };
  };
}
```

### secretsForAwsFromGitlab

Aquire an [Amazon Web Services (AWS)][aws] session
using [Gitlab CI OIDC][gitlab_ci_oidc].

Types:

- secretsForAwsFromGitlab (`attrsOf awsFromGitlabType`): Optional.
  Defaults to `{ }`.
- awsFromGitlabType (`submodule`):

  - roleArn (`str`):
    ARN of [AWS][aws] role to be assumed.

  - duration (`ints.positive`): Optional.
    Duration in seconds of the session.
    Defaults to `3600`.

  - retries (`ints.positive`): Optional.
    Number of login retries before failing.
    One retry per second.
    Defaults to `15`.

Example `makes.nix`:

```nix
{ outputs
, lintTerraform
, secretsForAwsFromGitlab
, ...
}:
{
  secretsForAwsFromGitlab = {
    makesDev = {
      roleArn = "arn:aws:iam::123456789012:role/dev";
      duration = 3600;
      retries = 30;
    };
    makesProd = {
      roleArn = "arn:aws:iam::123456789012:role/prod";
      duration = 7200;
      retries = 30;
    };
  };
  lintTerraform = {
    modules = {
      moduleDev = {
        setup = [
          outputs."/secretsForAwsFromGitlab/makesDev"
        ];
        src = "/my/module1";
        version = "0.14";
      };
      moduleProd = {
        setup = [
          outputs."/secretsForAwsFromGitlab/makesProd"
        ];
        src = "/my/module2";
        version = "0.14";
      };
    };
  };
}
```

### secretsForEnvFromSops

Export secrets from a [Sops][sops] encrypted manifest
to [Environment Variables][env_var].

Types:

- secretsForEnvFromSops (`attrsOf secretForEnvFromSopsType`): Optional.
  Defaults to `{ }`.
- secretForEnvFromSopsType (`submodule`):
  - manifest (`str`):
    Relative path to the encrypted [Sops][sops] file.
  - vars (`listOf str`):
    Names of the values to export out of the manifest.

Example `makes.nix`:

```nix
{ outputs
, ...
}:
{
  secretsForEnvFromSops = {
    cloudflare = {
      # Manifest contains inside:
      #   CLOUDFLARE_ACCOUNT_ID: ... ciphertext ...
      #   CLOUDFLARE_API_TOKEN: ... ciphertext ...
      manifest = "/infra/secrets/prod.yaml";
      vars = [ "CLOUDFLARE_ACCOUNT_ID" "CLOUDFLARE_API_TOKEN" ];
    };
  };
  lintTerraform = {
    modules = {
      moduleProd = {
        setup = [
          outputs."/secretsForEnvFromSops/cloudflare"
        ];
        src = "/my/module1";
        version = "0.14";
      };
    };
  };
}
```

### secretsForGpgFromEnv

Load [GPG][gnu_gpg] public or private keys
from [Environment Variables][env_var]
into an ephemeral key-ring.

Each key content must be stored
in a environment variable
in [ASCII Armor][ascii_armor] format.

Types:

- secretsForGpgFromEnv (`attrsOf (listOf str)`): Optional.
  Mapping of name
  to a list of environment variable names
  where the GPG key contents are stored.
  Defaults to `{ }`.

Example:

```nix
# /path/to/my/project/makes.nix
{ outputs
, ...
}:
{
  # Load keys into an ephemeral GPG keyring
  secretsForGpgFromEnv = {
    example = [
      "ENV_VAR_FOR_PRIVATE_KEY_CONTENT"
      "ENV_VAR_FOR_PUB_KEY_CONTENT"
    ];
  };
  # Use sops to decrypt an encrypted file
  secretsForEnvFromSops = {
    example = {
      manifest = "/secrets.yaml";
      vars = [ "password" ];
    };
  };
}
```

```nix
# /path/to/my/project/makes/example/main.nix
{ makeScript
, outputs
, ...
}:
makeScript {
  name = "example";
  searchPaths.source = [
    # First setup an ephemeral GPG keyring
    outputs."/secretsForGpgFromEnv/example"
    # Now sops will decrypt secrets using the GPG keys in the ring
    outputs."/secretsForEnvFromSops/example"
  ];
  entrypoint = ''
    echo Decrypted password: $password
  '';
}
```

```yaml
# /path/to/my/project/secrets.yaml
password: ENC[AES256_GCM,data:cLbgzNHgBN5drfsDAS+RTV5fL6I=,iv:2YHhHxKg+lbGqdB5nhhG2YemeKB6XWvthGfNNkVgytQ=,tag:cj/el3taq1w7UOp/JQSNwA==,type:str]
# ...
```

```bash
$ m . /example

  Decrypted password: 123
```

### secretsForKubernetesConfigFromAws

Create a [Kubernetes][kubernetes]
config file out of an [AWS][aws] EKS cluster
and set it up in the [KUBECONFIG Environment Variable][kubeconfig].

We internally use the [AWS CLI][aws_cli]
so make sure you setup [AWS] secrets first.

Types:

- secretsForKubernetesConfigFromAws
  (`attrsOf secretForKubernetesConfigFromAwsType`): Optional.
  Defaults to `{ }`.
- secretForKubernetesConfigFromAwsType (`submodule`):
  - cluster (`str`):
    [AWS][aws] EKS Cluster name.
  - region (`str`):
    [AWS][aws] Region the EKS cluster is located in.

Example `makes.nix`:

```nix
{ outputs
, ...
}:
{
  secretsForKubernetesConfigFromAws = {
    myCluster = {
      cluster = "makes-k8s";
      region = "us-east-1";
    };
  };
  deployTerraform = {
    modules = {
      moduleProd = {
        setup = [
          outputs."/secretsForKubernetesConfigFromAws/myCluster"
        ];
        src = "/my/module1";
        version = "0.14";
      };
    };
  };
}
```

### secretsForTerraformFromEnv

Export secrets in a format suitable for [Terraform][terraform]
from the given [Environment Variables][env_var].

Types:

- secretsForTerraformFromEnv (`attrsOf (attrsOf str)`): Optional.
  Mapping of secrets group name
  to a mapping of [Terraform][terraform] variable names
  to environment variable names.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ outputs
, ...
}:
{
  secretsForTerraformFromEnv = {
    example = {
      # Equivalent in Bash to:
      #   export TF_VAR_cloudflareAccountId=$ENV_VAR_FOR_CLOUDFLARE_ACCOUNT_ID
      #   export TF_VAR_cloudflareApiToken=$ENV_VAR_FOR_CLOUDFLARE_API_TOKEN
      cloudflareAccountId = "ENV_VAR_FOR_CLOUDFLARE_ACCOUNT_ID";
      cloudflareApiToken = "ENV_VAR_FOR_CLOUDFLARE_API_TOKEN";
    };
  };
}
```

Example `main.tf`:

```tf
variable "cloudflareAccountId" {}
```

## Utilities

Utilities provide an easy mechanism
for calling functions from makes
without having to specify them on any file.

### makeNodeJsLock

You can generate a `package-lock.json`
for [makeNodeJsEnvironment](#makenodejsenvironment)
like this:

```bash
m github:fluidattacks/makes@22.11 /utils/makeNodeJsLock \
  "${node_js_version}" \
  "${package_json}" \
  "${package_lock}"
```

- Supported `node_js_version`s are: `14`, `16` and `18`.
- `package_json` is the **absolute path** to the `package.json` file in your
  project.
- `package_lock` is the **absolute path**
  to the `package-lock.json` file in your project, this file can be an empty
  file.

### makePythonLock

You can generate a `sourcesYaml`
for [makePythonPypiEnvironment](#makepythonpypienvironment)
like this:

```bash
m github:fluidattacks/makes@22.11 /utils/makePythonLock \
  "${python_version}" \
  "${dependencies_yaml}" \
  "${sources_yaml}"
```

- Supported `python_version`s are: `3.8`, `3.9`, `3.10` and `3.11`.
- `dependencies_yaml` is the **absolute path** to a [YAML][yaml] file
  mapping [PyPI][python_pypi] packages to version constraints.

Example:

```yaml
Django: "3.2.*"
psycopg2: "2.9.1"
```

- `sources_yaml` is the **absolute path**
  to a file were the script will output results.

### makeRubyLock

You can generate a `sourcesYaml`
for [makeRubyGemsEnvironment](#makerubygemsenvironment)
like this:

```bash
m github:fluidattacks/makes@22.11 /utils/makeRubyLock \
  "${ruby_version}" \
  "${dependencies_yaml}" \
  "${sources_yaml}"
```

- Supported `ruby_version`s are: `2.7`, `3.0` and `3.1`.
- `dependencies_yaml` is the **absolute path** to a [YAML][yaml] file
  mapping [RubyGems][rubygems] gems to version constraints.

Example:

```yaml
rubocop: "1.43.0"
slim: "~> 4.1"
```

- `sources_yaml` is the **absolute path**
  to a file were the script will output results.

### makeSopsEncryptedFile

You can generate an encrypted [Sops][sops] file like this:

```bash
m github:fluidattacks/makes@22.11 /utils/makeSopsEncryptedFile \
  "${kms_key_arn}" \
  "${output}"
```

- `kms_key_arn` is the arn of the key you will use for encrypting the file.
- `output` is the path for your resulting encrypted file.

### workspaceForTerraformFromEnv

Sets a [Terraform Workspace][terraform_workspaces]
specified via environment variable.

Types:

- workspaceForTerraformFromEnv:
  - modules (`attrsOf moduleType`): Optional.
    [Terraform][terraform] modules to switch workspace.
    Defaults to `{ }`.
- moduleType (`submodule`):
  - setup (`listOf package`): Optional.
    [Makes Environment][makes_environment]
    or [Makes Secrets][makes_secrets]
    to `source` (as in Bash's `source`)
    before anything else.
    Defaults to `[ ]`.
  - src (`str`):
    Path to the [Terraform][terraform] module.
  - variable (`str`): Optional.
    Name of the environment variable that contains
    the name of the workspace you want to use.
    Defaults to `""`.
    When `""` provided, workspace is `default`.
  - version (`enum [ "0.14" "0.15" "1.0" ]`):
    [Terraform][terraform] version your module is built with.

Example `makes.nix`:

```nix
{
  testTerraform = {
    modules = {
      module1 = {
        setup = [
          outputs."/workspaceForTerraformFromEnv/module1"
        ];
        src = "/my/module1";
        version = "0.14";
      };
    };
  };
  workspaceForTerraformFromEnv = {
    modules = {
      module1 = {
        src = "/my/module1";
        variable = "CI_COMMIT_REF_NAME";
        version = "0.14";
      };
    };
  };
}
```

## Framework Configuration

### extendingMakesDirs

Paths to magic directories where Makes extensions will be loaded from.

Types:

- extendingMakesDirs (`listOf str`): Optional.
  Defaults to `["/makes"]`.

### inputs

Explicitly declare the inputs and sources for your project.
Inputs can be anything.

Types:

- inputs (`attrOf anything`): Optional.
  Defaults to `{ }`.

Example `makes.nix`:

```nix
{ fetchNixpkgs
, fetchUrl
, ...
}:
{
  inputs = {
    license = fetchUrl {
      rev = "https://raw.githubusercontent.com/fluidattacks/makes/1a595d8642ba98252cff7de3909fb879c54f8e59/LICENSE";
      sha256 = "11311l1apb1xvx2j033zlvbyb3gsqblyxq415qwdsd0db1hlwd52";
    };
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };
}
```

## Database

### dynamoDb

Create a local dynamo database

Types:

- dynamoDb (`attrsOf targetType`): Optional.
  Mapping of names to multiple databases.
  Defaults to `{ }`.
- targetType (`submodule`):
  - name (`str`),
  - host (`str`): Optional, defaults to `127.0.0.1`.
  - port (`str`): Optional, defaults to `8022`.
  - infra (`str`): Optional. Absolute path to the directory containing the
    terraform infraestructure.
  - daemonMode (`boolean`): Optional, defaults to `false`.
  - data (`listOf str`): Optional, defaults to []. Absolute paths with json documents,
    with the format defined for
    [BatchWriteItem](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html#API_BatchWriteItem_RequestSyntax).
  - dataDerivation (`listOf package`): Optional, defaults to `[]`.
    Derivations where the output ($ out), are json documents,
    with the format defined for
    [BatchWriteItem](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html#API_BatchWriteItem_RequestSyntax).
    This is useful if you want to perform transformations on your data.

Example `makes.nix`:

```nix
{ projectPath
, ...
}:
{
  dynamoDb = {
    usersdb = {
      host = "localhost";
      infra = projectPath "/test/database/infra";
      data = [
        projectPath "/test/database/data"
      ];
      daemonMode = true;
    };
  };
}
```

Example invocation: `$ m . /dyanmoDb/usersdb`

You can also overwrite the parameters with environment variables.

Example: `$ DAEMON=false m . /dyanmoDb/usersdb`

The following variables are available:

- HOST
- PORT
- DAEMON
- POPULATE

## Examples

### helloWorld

Small command for demo purposes, it greets the specified user:

Types:

- helloWorld:
  - enable (`boolean`): Optional.
    Defaults to `false`.
  - name (`string`):
    Name of the user we should greet.

Example `makes.nix`:

```nix
{
  helloWorld = {
    enable = true;
    name = "Jane Doe";
  };
}
```

Example invocation: `$ m . /helloWorld 1 2 3`

## Monitoring

### calculateScorecard

Calculate your remote repository [Scorecard][scorecard]. This module is only
available for [GitHub][github] projects at the moment.

Pre-requisites:

1. To run this module you need to set up a valid `GITHUB_AUTH_TOKEN` on your
   target repository. You can set this up in your CI or locally to run this
   check on your machine.

Types:

- checks (`listOf str`): Optional, defaults to all the checks available for
  [Scorecard][scorecard]:

  ```nix
  [
    "Branch-Protection"
    "Fuzzing"
    "License"
    "SAST"
    "Binary-Artifacts"
    "Dependency-Update-Tool"
    "Pinned-Dependencies"
    "CI-Tests"
    "Code-Review"
    "Contributors"
    "Maintained"
    "Token-Permissions"
    "Security-Policy"
    "CII-Best-Practices"
    "Dangerous-Workflow"
    "Packaging"
    "Signed-Releases"
    "Vulnerabilities"
  ]
  ```

- format (`str`): Optional, defaults to [JSON][json]. This is the format which
  the scorecard will be printed. Accepted values are: `"default"` which is an
  `ASCII Table` and [JSON][json].
- target (`str`): Mandatory, this is the repository url where you want to run
  scorecard.

Example usage:

```nix
{
  calculateScorecard = {
    checks = [ "SAST" ];
    enable = true;
    format = "json"
    target = "github.com/fluidattacks/makes";
  };
}
```

Example output:

```bash
  [INFO] Calculating Scorecard
  {
    "date": "2022-02-28",
    "repo": {
      "name": "github.com/fluidattacks/makes",
      "commit": "739dcdc0513c29de67406e543e1392ea194b3452"
    },
    "scorecard": {
      "version": "4.0.1",
      "commit": "c60b66bbc8b85286416d6ab9ae9324a095e66c94"
    },
    "score": 5,
    "checks": [
      {
        "details": [
          "Warn: 16 commits out of 30 are checked with a SAST tool",
          "Warn: CodeQL tool not detected"
        ],
        "score": 5,
        "reason": "SAST tool is not run on all commits -- score normalized to 5",
        "name": "SAST",
        "documentation": {
          "url": "https://github.com/ossf/scorecard/blob/c60b66bbc8b85286416d6ab9ae9324a095e66c94/docs/checks.md#sast",
          "short": "Determines if the project uses static code analysis."
        }
      }
    ],
    "metadata": null
  }
  [INFO] Aggregate score: 5
```

# Extending Makes

You can create custom workflows
not covered by the builtin `makes.nix` configuration options.

In order to do this:

1. Locate in the root of your project:

   `$ cd /path/to/my/project`

1. Create a directory structure. In this case: `makes/example`.

   `$ mkdir -p makes/example`

   We will place in this directory
   all the source code
   for the custom workflow called `example`.

1. Create a `main.nix` file inside `makes/example`.

   Our goal is to create a bash script that prints `Hello from makes!`,
   so we are going to write the following function:

   ```nix
   # /path/to/my/project/makes/example/main.nix
   { makeScript
   , ...
   }:
   makeScript {
     entrypoint = "echo Hello from Makes!";
     name = "hello-world";
   }
   ```

1. Now run makes!

   - List all available outputs: `$ m .`

     ```
     Outputs list for project: /path/to/my/project
       /example
     ```

   - Build and run the output: `$ m . /example`

     ```
     Hello from Makes!
     ```

Makes will automatically recognize as outputs all `main.nix` files
under the `makes/` directory in the root of the project.
This "magic" `makes/` directory can be configured via the
`extendingMakesDirs` option.

You can create any directory structure you want.
Output names will me mapped in an intuitive way:

| `main.nix` position                                | Output name                | Invocation command     |
| -------------------------------------------------- | -------------------------- | ---------------------- |
| `/path/to/my/project/makes/main.nix`               | `outputs."/"`              | `$ m . /`              |
| `/path/to/my/project/makes/example/main.nix`       | `outputs."/example"`       | `$ m . /example`       |
| `/path/to/my/project/makes/other/example/main.nix` | `outputs."/other/example"` | `$ m . /other/example` |

## Main.nix format

Each `main.nix` file under the `makes/` directory
should be a function that receives one or more arguments
and returns a derivation:

```nix
{ argA
, argB
, ...
}:
doSomethingAndReturnADerivation
```

### Derivations

On [Nix][nix]
a [derivation][nix_derivation]
is the process of:

- taking zero or more inputs

- transforming them as we see fit

- placing the results in the output path

Derivation outputs live in the `/nix/store`.
Their locations in the filesystem are always in the form:
`/nix/store/hash123-name` where
`hash123` is computed by [hashing][hash] the derivation's inputs.

Derivation outputs are:

- A regular file
- A regular directory that contains arbitrary contents

For instance the derivation output for [Bash][bash] is:
`/nix/store/kxj6cblcsd1qcbbxlmbswwrn89zcmgd6-bash-4.4-p23`
which contains, among other files:

```tree
/nix/store/kxj6cblcsd1qcbbxlmbswwrn89zcmgd6-bash-4.4-p23
├── bin
│   ├── bash
│   └── sh
```

## Main.nix reference

Makes offers you a few building blocks
for you to reuse.

Let's start from the basics.

### Fundamentals

#### makeSearchPaths

On [Linux][linux]
software dependencies
can be located anywhere in the file system.

We can control where
programs find other programs,
dependencies, libraries, etc,
through special environment variables.

Below we describe shortly the purpose
of the environment variables we currently support.

- [CLASSPATH][classpath]:
  Location of user-defined classes and packages.

- [CRYSTAL_LIBRARY_PATH][crystal_library_path]:
  Location of [Crystal][crystal] libraries.

- [GEM_PATH][gem_path]:
  Location of libraries for [Ruby][ruby].

- [LD_LIBRARY_PATH][rpath]:
  Location of libraries for Dynamic Linking Loaders.

- [MYPYPATH][mypypath]:
  Location of library stubs and static types for [MyPy][mypy].

- [NODE_PATH][node_path]:
  Location of [Node.js][node_js] modules.

- [OCAMLPATH][ocamlpath]:
  Location of [OCaml][ocaml] libraries.

- [CAML_LD_LIBRARY_PATH][caml_ld_library_path]:
  Location of [OCaml][ocaml] stublibs.

- [PATH][path]:
  Location of directories where executable programs are located.

- [PKG_CONFIG_PATH][pkg_config_path]:
  Location of [pkg-config][pkg_config] packages.

- [PYTHONPATH][pythonpath]:
  Location of [Python][python] modules and site-packages.

`makeSearchPaths` helps you write code like this:

```nix
makeSearchPaths {
  bin = [ inputs.nixpkgs.git ];
}
```

Instead of this:

```bash
export PATH="/nix/store/m5kp2jhiga25ynk3iq61f4psaqixg7ib-git-2.32.0/bin${PATH:+:}${PATH:-}"
```

Types:

- makeSearchPaths (`function { ... } -> package`):

  - `bin` (`listOf coercibleToStr`): Optional.
    Append `/bin`
    of each element in the list
    to [PATH][path].
    Defaults to `[ ]`.

  - `rpath` (`listOf coercibleToStr`): Optional.
    Append `/lib` and `/lib64`
    of each element in the list
    to [LD_LIBRARY_PATH][rpath].
    Defaults to `[ ]`.

  - `source` (`listOf coercibleToStr`): Optional.
    Source (as in [Bash][bash]'s `source` command)
    each element in the list.
    Defaults to `[ ]`.

Types specific to [Crystal][crystal]:

- makeSearchPaths (`function { ... } -> package`):

  - `crystalLib` (`listOf coercibleToStr`): Optional.
    Append `/lib`
    of each element in the list
    to [CRYSTAL_LIBRARY_PATH][crystal_library_path].
    Defaults to `[ ]`.

Types specific to Java:

- makeSearchPaths (`function { ... } -> package`):

  - `javaClass` (`listOf coercibleToStr`): Optional.
    Append each element in the list
    to [CLASSPATH][classpath].
    Defaults to `[ ]`.

Types specific to [Kubernetes][kubernetes]:

- makeSearchPaths (`function { ... } -> package`):

  - `kubeConfig` (`listOf coercibleToStr`): Optional.
    Append each element in the list
    to [KUBECONFIG][kubeconfig].
    Defaults to `[ ]`.

Types specific to [pkg-config][pkg_config]:

- makeSearchPaths (`function { ... } -> package`):

  - `pkgConfig` (`listOf coercibleToStr`): Optional.
    Append `/lib/pkgconfig`
    of each element in the list
    to [PKG_CONFIG_PATH][pkg_config_path].
    Defaults to `[ ]`.

Types specific to [OCaml][ocaml]:

- makeSearchPaths (`function { ... } -> package`):

  - `ocamlBin` (`listOf coercibleToStr`): Optional.
    Append `/bin`
    of each element in the list
    to [PATH][path].
    Defaults to `[ ]`.

  - `ocamlLib` (`listOf coercibleToStr`): Optional.
    Append `/`
    of each element in the list
    to [OCAMLPATH][ocamlpath].
    Defaults to `[ ]`.

  - `ocamlStublib` (`listOf coercibleToStr`): Optional.
    Append `/stublib`
    of each element in the list
    to [CAML_LD_LIBRARY_PATH][caml_ld_library_path].
    Defaults to `[ ]`

Types specific to [Python][python]:

- makeSearchPaths (`function { ... } -> package`):

  - `pythonMypy` (`listOf coercibleToStr`): Optional.
    Append `/`
    of each element in the list
    to [MYPYPATH][mypypath].
    Defaults to `[ ]`.

  - `pythonMypy38` (`listOf coercibleToStr`): Optional.
    Append `/lib/python3.8/site-packages`
    of each element in the list
    to [MYPYPATH][mypypath].
    Defaults to `[ ]`.

  - `pythonMypy39` (`listOf coercibleToStr`): Optional.
    Append `/lib/python3.9/site-packages`
    of each element in the list
    to [MYPYPATH][mypypath].
    Defaults to `[ ]`.

  - `pythonMypy310` (`listOf coercibleToStr`): Optional.
    Append `/lib/python3.10/site-packages`
    of each element in the list
    to [MYPYPATH][mypypath].
    Defaults to `[ ]`.

  - `pythonMypy311` (`listOf coercibleToStr`): Optional.
    Append `/lib/python3.11/site-packages`
    of each element in the list
    to [MYPYPATH][mypypath].
    Defaults to `[ ]`.

  - `pythonPackage` (`listOf coercibleToStr`): Optional.
    Append `/`
    of each element in the list
    to [PYTHONPATH][pythonpath].
    Defaults to `[ ]`.

  - `pythonPackage38` (`listOf coercibleToStr`): Optional.
    Append `/lib/python3.8/site-packages`
    of each element in the list
    to [PYTHONPATH][pythonpath].
    Defaults to `[ ]`.

  - `pythonPackage39` (`listOf coercibleToStr`): Optional.
    Append `/lib/python3.9/site-packages`
    of each element in the list
    to [PYTHONPATH][pythonpath].
    Defaults to `[ ]`.

  - `pythonPackage310` (`listOf coercibleToStr`): Optional.
    Append `/lib/python3.10/site-packages`
    of each element in the list
    to [PYTHONPATH][pythonpath].
    Defaults to `[ ]`.

  - `pythonPackage311` (`listOf coercibleToStr`): Optional.
    Append `/lib/python3.11/site-packages`
    of each element in the list
    to [PYTHONPATH][pythonpath].
    Defaults to `[ ]`.

Types specific to [Node.js][node_js]:

- makeSearchPaths (`function { ... } -> package`):

  - `nodeBin` (`listOf coercibleToStr`): Optional.
    Append `/.bin`
    of each element in the list
    to [PATH][path].
    Defaults to `[ ]`.

  - `nodeModule` (`listOf coercibleToStr`): Optional.
    Append `/`
    of each element in the list
    to [NODE_PATH][node_path].
    Defaults to `[ ]`.

Types specific to [Ruby][ruby]:

- makeSearchPaths (`function { ... } -> package`):

  - `rubyBin` (`listOf coercibleToStr`): Optional.
    Append `/bin`
    of each element in the list
    to [PATH][path].
    Defaults to `[ ]`.

  - `rubyGemPath` (`listOf coercibleToStr`): Optional.
    Append `/`
    of each element in the list
    to [GEM_PATH][gem_path].
    Defaults to `[ ]`.

Types for non covered cases:

- makeSearchPaths (`function { ... } -> package`):

  - `export` (`listOf (tuple [ str coercibleToStr str ])`): Optional.
    Export (as in [Bash][bash]'s `export` command)
    each tuple in the list.
    Defaults to `[ ]`.

    Tuples elements are:

    - Name of the environment variable to export.
    - Base package to export from.
    - Relative path with respect to the package that should be appended.

    Example:

    ```bash
    # /path/to/my/project/makes/example/template
    echo "${@}"
    ```

    ```nix
    # /path/to/my/project/makes/example/main.nix
    makeSearchPaths {
      source = [
        [ ./template "a" "b" "c" ]
        # add more as you need ...
      ];
      export = [
        [ "PATH" inputs.nixpkgs.bash "/bin"]
        [ "CPATH" inputs.nixpkgs.glib.dev "/include/glib-2.0"]
        # add more as you need ...
      ];
    }
    ```

    Is equivalent to:

    ```bash
    export PATH="/nix/store/...-bash/bin${PATH:+:}${PATH:-}"
    export CPATH="/nix/store/...-glib-dev/include/glib-2.0${CPATH:+:}${CPATH:-}"

    if test -e "/nix/store/...-template/template"
    then source "/nix/store/...-template/template" '1' '2' '3'
    else source "/nix/store/...-template" '1' '2' '3'
    fi
    ```

Example:

```nix
{ makeSearchPaths
, ...
}:
makeSearchPaths {
  bin = [ inputs.nixpkgs.git ];
}
```

#### makeDerivation

Perform a build step in an **isolated** environment:

- External environment variables are not visible by the builder script.
  This means you **can't** use secrets here.
- Search Paths as in `makeSearchPaths` are completely empty.
- The `HOME` environment variable is set to `/homeless-shelter`.
- Only [GNU coreutils][gnu_coreutils] commands (cat, echo, ls, ...)
  are present by default.
- An environment variable called `out` is present
  and represents the derivation's output.
  The derivation **must** produce an output,
  may be a file, or a directory.
- Convenience bash functions are exported:

  - `echo_stderr`: Like `echo` but to standard error.
  - `debug`: Like `echo_stderr` but with a `[DEBUG]` prefix.
  - `info`: Like `echo_stderr` but with a `[INFO]` prefix.
  - `warn`: Like `echo_stderr` but with a `[WARNING]` prefix.
  - `error`: Like `echo_stderr` but with a `[ERROR]` prefix.
    Returns exit code 1 to signal failure.
  - `critical`: Like `echo_stderr` but with a `[CRITICAL]` prefix.
    Exits immediately with exit code 1, aborting the entire execution.
  - `copy`: Like `cp` but making paths writeable after copying them.
  - `require_env_var`: `error`s when the specified env var is not set,
    or set to an empty value.

    ```bash
    require_env_var USERNAME
    ```

- After the build, for all paths in `$out`:
  - User and group ownership are removed
  - Last-modified timestamps are reset to `1970-01-01T00:00:00+00:00`.

Types:

- makeDerivation (`function { ... } -> package`):
  - builder (`either str package`):
    A [Bash][bash] script that performs the build step.
  - env (`attrsOf str`): Optional.
    Environment variables that will be propagated to the `builder`.
    Variable names must start with `env`.
    Defaults to `{ }`.
  - local (`bool`): Optional.
    Should we always build locally this step?
    Thus effectively ignoring any configured binary caches.
    Defaults to `false`.
  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ inputs
, makeDerivation
, ...
}:
makeDerivation {
  env = {
    envVersion = "1.0";
  };
  builder = ''
    debug Version is $envVersion
    info Running tree command on $PWD
    mkdir dir
    touch dir/file
    tree dir > $out
  '';
  name = "example";
  searchPaths = {
    bin = [ inputs.nixpkgs.tree ];
  };
}
```

```bash
$ m . /example

    [DEBUG] Version is 1.0
    [INFO] Running tree command on /tmp/nix-build-example.drv-0
    /nix/store/30hg7hzn6d3zmfva1bl4zispqilbh3nm-example

$ cat /nix/store/30hg7hzn6d3zmfva1bl4zispqilbh3nm-example
    dir
    `-- file

    0 directories, 1 file
```

#### makeTemplate

Replace placeholders with the specified values
in a file of any format.

Types:

- makeTemplate (`function { ... } -> package`):
  - local (`bool`): Optional.
    Should we always build locally this step?
    Thus effectively ignoring any configured binary caches.
    Defaults to `true`.
  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - replace (`attrsOf strLike`): Optional.
    Placeholders will be replaced in the script with their respective value.
    Variable names must start with `__arg`, end with `__`
    and have at least 6 characters long.
    Defaults to `{ }`.
  - template (`either str package`):
    A string, file, output or package
    in which placeholders will be replaced.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ inputs
, makeTemplate
, ...
}:
makeTemplate {
  name = "example";
  replace = {
    __argBash__ = inputs.nixpkgs.bash;
    __argVersion__ = "1.0";
  };
  template = ''
    Bash is: __argBash__
    Version is: __argVersion__
  '';
}
```

```bash
$ m . /example

    Bash is: /nix/store/kxj6cblcsd1qcbbxlmbswwrn89zcmgd6-bash-4.4-p23
    Version is: 1.0
```

#### makeScript

Wrap a [Bash][bash] script
that runs in a **almost-isolated** environment.

- The file system is **not** isolated, the script runs in user-space.
- External environment variables are visible by the script.
  You can use this to propagate secrets.
- Search Paths as in `makeSearchPaths` are completely empty.
- The `HOME_IMPURE` environment variable is set to the user's home directory.
- The `HOME` environment variable is set to a temporary directory.
- Only [GNU coreutils][gnu_coreutils] commands (cat, echo, ls, ...)
  are present by default.
- An environment variable called `STATE` points to a directory
  that can be used to store the script's state (if any).
  That state can be optionally persisted.
  That state can be optionally shared across repositories.
- Convenience bash functions are exported:

  - `running_in_ci_cd_provider`:
    Detects if we are running on the CI/CD provider (gitlab/github/etc).

    ```bash
    if running_in_ci_cd_provider; then
      # ci/cd logic
    else
      # non ci/cd logic
    fi
    ```

  - `prompt_user_for_confirmation`:
    Warns the user about a possibly destructive action
    that will be executed soon
    and aborts if the user does not confirm aproppriately.

    This function assumes a positive answer
    when running on the CI/CD provider
    because there is no human interaction.

  - `prompt_user_for_input`:
    Ask the user to type information
    or optionally use a default value by pressing ENTER.

    This function assumes the default value
    when running on the CI/CD provider
    because there is no human interaction.

    ```bash
    user_supplied_input="$(prompt_user_for_input "default123123")"

    info Supplied input: "${user_supplied_input}"
    ```

- After the build, the script is executed.

Types:

- makeScript (`function { ... } -> package`):
  - entrypoint (`either str package`):
    A [Bash][bash] script that performs the build step.
  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - replace (`attrsOf strLike`): Optional.
    Placeholders will be replaced in the script with their respective value.
    Variable names must start with `__arg`, end with `__`
    and have at least 6 characters long.
    Defaults to `{ }`.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.
  - persistState (`bool`): Optional.
    If true, state will _not_ be cleared before each script run.
    Defaults to `false`.
  - globalState (`bool`): Optional.
    If true, script state will be written to `globalStateDir` and
    to `projectStateDir` otherwise.
    Defaults to `false`, if `projectStateDir` is specified or derived.
    Note:
    - It is implicitly `true`, if `projectStateDir == globalStateDir`.
    - `projectStateDir == globalStateDir` is the default if
      `projectIdentifier` is not configured.
    - Hence, generally enable project local state by
      - either setting `projectIdentifier`
      - or `projectStateDir` different from `globalStateDir`.

Example:

```nix

# /path/to/my/project/makes/example/main.nix
{ inputs
, makeScript
, ...
}:
makeScript {
  replace = {
    __argVersion__ = "1.0";
  };
  entrypoint = ''
    debug Version is __argVersion__
    info pwd is $PWD
    info Running tree command on $STATE
    mkdir $STATE/dir
    touch $STATE/dir/file
    tree $STATE
  '';
  name = "example";
  searchPaths = {
    bin = [ inputs.nixpkgs.tree ];
  };
}
```

```bash
$ m . /example

    [DEBUG] Version is 1.0
    [INFO] pwd is /data/github/fluidattacks/makes
    [INFO] Running tree command on /home/user/.makes/state/example
    /home/user/.makes/state/example
    └── dir
        └── file

    1 directory, 1 file
```

#### projectPath

Copy a path from the current [Makes][makes] project
being evaluated to the [Nix][nix] store
in the **most** pure and reproducible way possible.

Types:

- projectPath (`function str -> package`):

  - (`str`):
    Absolute path, assumming the repository is located at `"/"`.

Example:

```nix
# Consider the following path within the repository: /src/nix

# /path/to/my/project/makes/example/main.nix
{ makeScript
, projectPath
, ...
}:
makeScript {
  replace = {
    __argPath__ = projectPath "/src/nix";
  };
  entrypoint = ''
    info Path is: __argPath__
    info Path contents are:
    ls __argPath__
  '';
  name = "example";
}
```

```bash
$ m . /example

    [INFO] Path is: <nix-store-path>
    [INFO] Path contents are:
    packages.nix  sources.json  sources.nix
```

### Fetchers

#### fetchUrl

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

```nix
# /path/to/my/project/makes/example/main.nix
{ fetchUrl
, ...
}:
fetchUrl {
  url = "https://github.com/fluidattacks/makes/blob/16aafa1e3ed4cc99eb354842341fbf6f478a211c/README.md";
  sha256 = "18scrymrar0bv7s92hfqfb01bv5pibyjw6dxp3i8nylmnh6gjv15";
}

```

#### fetchArchive

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

```nix
# /path/to/my/project/makes/example/main.nix
{ fetchArchive
, ...
}:
fetchArchive {
  url = "https://github.com/fluidattacks/makes/archive/16aafa1e3ed4cc99eb354842341fbf6f478a211c.zip";
  sha256 = "16zx89lzv5n048h5l9f8dgpvdj0l38hx7aapc7h1d1mjc1ca2i6a";
}

```

#### fetchGithub

Fetch a commit from the specified Git repository at [GitHub][github].

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

```nix
# /path/to/my/project/makes/example/main.nix
{ fetchGithub
, ...
}:
fetchGithub {
  owner = "kamadorueda";
  repo = "mailmap-linter";
  rev = "e0799aa47ac5ce6776ca8581ba50ace362e5d0ce";
  sha256 = "02nr39rn4hicfam1rccbqhn6w6pl25xq7fl2kw0s0ahxzvfk24mh";
}
```

#### fetchGitlab

Fetch a commit from the specified Git repository at [Gitlab][gitlab].

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

```nix
# /path/to/my/project/makes/example/main.nix
{ fetchGitlab
, ...
}:
fetchGitlab {
  owner = "fluidattacks";
  repo = "product";
  rev = "ff231a9bf8aa3f0807f3431b402e7af08d136341";
  sha256 = "1sfbif0bchdpw4rlfpv9gs4l4bmg8l24fqh2hg6m39msrvh1w6h3";
}
```

#### fetchNixpkgs

Fetch a commit from the [Nixpkgs][nixpkgs] repository.

:warning: By default all licenses in the Nixpkgs repository are accepted.
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
    Overlays to apply to the [Nixpkgs][nixpkgs] set.
    Defaults to `[ ]`.
  - sha256 (`str`):
    SHA256 of the expected output,
    In order to get the SHA256
    you can omit this parameter and execute Makes,
    Makes will tell you the correct SHA256 on failure.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ fetchNixpkgs
, ...
}:
let nixpkgs = fetchNixpkgs {
  rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
  sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
};
in
nixpkgs.awscli
```

#### fetchRubyGem

Fetch a [Ruby][ruby] gem from [Ruby community’s gem hosting service][rubygems].

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

```nix
# /path/to/my/project/makes/example/main.nix
{ fetchRubyGem
, ...
}:
fetchRubyGem {
  sha256 = "04nc8x27hlzlrr5c2gn7mar4vdr0apw5xg22wp6m8dx3wqr04a0y";
  url = "https://rubygems.org/downloads/ast-2.4.2.gem";
}
```

### Git

#### libGit

A small template for doing git kung-fu.

Types:

- libGit (`package`):
  A package that can be sourced to setup functions in the current scope.
  The list of available functions is documented below:

  - `is_git_repository`:
    Return 0 if the provided path is a git repository.

    ```bash
    if is_git_repository /path/to/anywhere; then
      # custom logic
    fi
    ```

  - `require_git_repository`:
    Stops the execution
    if the provided path is not a git repository.

    ```bash
    require_git_repository /path/to/anywhere
    ```

  - `get_abbrev_rev`:
    If available, returns an abbreviated name for the provided revision.
    Otherwise returns the revision unchanged.

    ```bash
    # Would return main, trunk, develop, etc
    get_abbrev_rev /path/to/anywhere HEAD
    ```

  - `get_commit_from_rev`:
    If available, returns the full commit of the provided revision.
    Otherwise returns an error.

    ```bash
    # Would return the full commit (e026a413...)
    get_commit_from_rev /path/to/anywhere HEAD
    ```

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ libGit
, makeScript
, ...
}:
makeScript {
  entrypoint = ''
    require_git_repository /some-path-that-do-not-exists

    echo other business logic goes here ...
  '';
  name = "example";
  searchPaths = {
    source = [ libGit ];
  };
}
```

```bash
$ m . /example

    [CRITICAL] We require a git repository, but this one is not: /some-path-that-do-not-exists
```

### Node.js

#### makeNodeJsVersion

Get a specific [Node.js][node_js] version interpreter.

Types:

- makeNodeJsVersion (`function str -> package`):

  - (`enum [ "14" "16" "18" ]`):
    [Node.js][node_js] version to use.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ makeNodeJsVersion
, makeScript
, ...
}:
makeScript {
  entrypoint = ''
    node --version
  '';
  name = "example";
  searchPaths = {
    bin = [ (makeNodeJsVersion "16") ];
  };
}
```

```bash
$ m . /example

    v16.2.0
```

#### makeNodeJsModules

:warning: This function is only available on Linux at the moment.

Cook the `node_modules` directory
for the given [NPM][npm] project.

Types:

- makeNodeJsModules (`function { ... } -> package`):

  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - nodeJsVersion (`enum [ "14" "16" "18" ]`):
    [Node.js][node_js] version to use.
  - packageJson (`package`):
    Path to the `package.json` of your project.
  - packageLockJson (`package`):
    Path to the `package-lock.json` of your project.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.
  - shouldIgnoreScripts (`bool`): Optional.
    Enable to propagate the `--ignore-scripts true` flag to npm.
    Defaults to `false`.

Example:

```json
# /path/to/my/project/makes/example/package.json
{
  "dependencies": {
    "hello-world-npm": "*"
  }
}
```

```json
# /path/to/my/project/makes/example/package-lock.json
{
  "requires": true,
  "lockfileVersion": 1,
  "dependencies": {
    "hello-world-npm": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/hello-world-npm/-/hello-world-npm-1.1.1.tgz",
      "integrity": "sha1-JQgw7wAItDftk+a+WZk0ua0Lkwg="
    }
  }
}
```

```nix
# /path/to/my/project/makes/example/main.nix
{ makeNodeJsModules
, makeScript
, projectPath
, ...
}:
let
  hello = makeNodeJsModules {
    name = "hello-world-npm";
    nodeJsVersion = "16";
    packageJson =
      projectPath "/path/to/my/project/makes/example/package.json";
    packageLockJson =
      projectPath "/path/to/my/project/makes/example/package-lock.json";
  };
in
makeScript {
  replace = {
    __argHello__ = hello;
  };
  entrypoint = ''
    ls __argHello__
  '';
  name = "example";
}
```

```bash
$ m . /example

    hello-world-npm
```

#### makeNodeJsEnvironment

:warning: This function is only available on Linux at the moment.

Setup a `makeNodeJsModules` in the environment
using `makeSearchPaths`.
It appends:

- `node` to `PATH`.
- `node_modules/.bin` to `PATH`.
- `node_modules` to [NODE_PATH][node_path].

Pre-requisites: [Generating a package-lock.json](#makenodejslock)

Types:

- makeNodeJsEnvironment (`function { ... } -> package`):

  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - nodeJsVersion (`enum [ "14" "16" "18" ]`):
    [Node.js][node_js] version to use.
  - packageJson (`package`):
    Path to the `package.json` of your project.
  - packageLockJson (`package`):
    Path to the `package-lock.json` of your project.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.
  - shouldIgnoreScripts (`bool`): Optional.
    Enable to propagate the `--ignore-scripts true` flag to npm.
    Defaults to `false`.

Example:

```json
# /path/to/my/project/makes/example/package.json
{
  "dependencies": {
    "hello-world-npm": "*"
  }
}
```

```json
# /path/to/my/project/makes/example/package-lock.json
{
  "requires": true,
  "lockfileVersion": 1,
  "dependencies": {
    "hello-world-npm": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/hello-world-npm/-/hello-world-npm-1.1.1.tgz",
      "integrity": "sha1-JQgw7wAItDftk+a+WZk0ua0Lkwg="
    }
  }
}
```

```nix
# /path/to/my/project/makes/example/main.nix
{ makeNodeJsEnvironment
, makeScript
, ...
}:
let
  hello = makeNodeJsEnvironment {
    name = "hello-world-npm";
    nodeJsVersion = "16";
    packageJson =
      projectPath "/path/to/my/project/makes/example/package.json";
    packageLockJson =
      projectPath "/path/to/my/project/makes/example/package-lock.json";
  };
in
makeScript {
  entrypoint = ''
    hello-world-npm
  '';
  name = "example";
  searchPaths = {
    source = [ hello ];
  };
}
```

```bash
$ m . /example

    Hello World NPM
```

### Python

#### makePythonVersion

Get a specific [Python][python] interpreter.

Types:

- makePythonVersion (`function str -> package`):

  - (`enum ["3.8" "3.9" "3.10" "3.11"]`):
    [Python][python] version of the interpreter to return.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ makePythonVersion
, makeScript
, ...
}:
makeScript {
  entrypoint = ''
    python --version
  '';
  name = "example";
  searchPaths = {
    bin = [ (makePythonVersion "3.8") ];
  };
}
```

```bash
$ m . /example

    Python 3.8.9
```

#### makePythonPypiEnvironment

Create a virtual environment
where the provided set of [Python][python] packages
from the [Python Packaging Index (PyPI)][python_pypi]
are installed.

Pre-requisites: [Generating a sourcesYaml](#makepythonlock)

Types:

- makePythonPypiEnvironment (`function { ... } -> package`):

  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - searchPathsBuild (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`
    and used while installing the Python dependencies.
    Defaults to `makeSearchPaths`'s defaults.
  - searchPathsRuntime (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`
    and propagated to the runtime environment.
    Defaults to `makeSearchPaths`'s defaults.
  - sourcesYaml (`package`):
    `sources.yaml` file
    computed as explained in the pre-requisites section.

  For building a few special packages you may need to boostrap
  dependencies in the build environment.
  The following flags are available for convenience:

  - withCython_0_29_24 (`bool`): Optional.
    Bootstrap cython 0.29.24 to the environment
    Defaults to `false`.
  - withNumpy_1_24_0 (`bool`): Optional.
    Bootstrap numpy 1.24.0 to the environment
    Defaults to `false`.
  - withSetuptools_57_4_0 (`bool`): Optional.
    Bootstrap setuptools 57.4.0 to the environment
    Defaults to `false`.
  - withSetuptoolsScm_5_0_2 (`bool`) Optional.
    Bootstrap setuptools-scm 5.0.2 to the environment
    Defaults to `false`.
  - withSetuptoolsScm_6_0_1 (`bool`) Optional.
    Bootstrap setuptools-scm 6.0.1 to the environment
    Defaults to `false`.
  - withWheel_0_37_0 (`bool`): Optional.
    Bootstrap wheel 0.37.0 to the environment
    Defaults to `false`.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ inputs
, makePythonPypiEnvironment
, projectPath
, ...
}:
makePythonPypiEnvironment {
  name = "example";
  # If some packages require compilers to be built,
  # you can provide them like this:
  searchPathsBuild = {
    bin = [ inputs.nixpkgs.gcc ];
  };
  # You can propagate packages to the runtime environment if needed, too
  searchPathsRuntime = {
    bin = [ inputs.nixpkgs.htop ];
  };
  sourcesYaml = projectPath "/makes/example/sources.yaml";
  # Other packages require a few bootstrapped dependencies,
  # enable them like this:
  withCython_0_29_24 = true;
  withSetuptools_57_4_0 = true;
  withSetuptoolsScm_6_0_1 = true;
  withWheel_0_37_0 = true;
}
```

`sourcesYaml` is generated like this:

```bash
$ cat /path/to/my/project/makes/example/dependencies.yaml

  Django: "3.2.6"

$ m github:fluidattacks/makes@22.11 /utils/makePythonLock \
    3.8 \
    /path/to/my/project/makes/example/dependencies.yaml \
    /path/to/my/project/makes/example/sources.yaml

  # ...

$ cat /path/to/my/project/makes/example/sources.yaml

  closure:
    asgiref: 3.4.1
    django: 3.2.6
    pytz: "2021.1"
    sqlparse: 0.4.1
  links:
    - name: Django-3.2.6-py3-none-any.whl
      sha256: 04qzllkmyl0g2fgdab55r7hv3vqswfdv32p77cgjj3ma54sl34kz
      url: https://pypi.org/packages/py3/D/Django/Django-3.2.6-py3-none-any.whl
    - name: Django-3.2.6.tar.gz
      sha256: 08p0gf1n548fjba76wspcj1jb3li6lr7xi87w2xq7hylr528azzj
      url: https://pypi.org/packages/source/D/Django/Django-3.2.6.tar.gz
    - name: pytz-2021.1-py2.py3-none-any.whl
      sha256: 1607gl2x9290ks5sa6dvqw9dgg1kwdf9fj9xcb9jw19nfwzcw47b
      url: https://pypi.org/packages/py2.py3/p/pytz/pytz-2021.1-py2.py3-none-any.whl
    - name: pytz-2021.1.tar.gz
      sha256: 1nn459q7zg20n75akxl3ljkykgw1ydc8nb05rx1y4f5zjh4ak943
      url: https://pypi.org/packages/source/p/pytz/pytz-2021.1.tar.gz
    - name: sqlparse-0.4.1-py3-none-any.whl
      sha256: 1l2f616scnhbx7nkzvwmiqvpjh97x11kz1v1bbqs3mnvk8vxwz01
      url: https://pypi.org/packages/py3/s/sqlparse/sqlparse-0.4.1-py3-none-any.whl
    - name: sqlparse-0.4.1.tar.gz
      sha256: 1s2l0jgi1v7rk7smzb99iamasaz22apfkczsphn3ci4wh8pgv48g
      url: https://pypi.org/packages/source/s/sqlparse/sqlparse-0.4.1.tar.gz
    - name: asgiref-3.4.1-py3-none-any.whl
      sha256: 052j8715bw39iywciicgfg5hxnsgmyvv7cg7fdb1fvwfj2m43hgz
      url: https://pypi.org/packages/py3/a/asgiref/asgiref-3.4.1-py3-none-any.whl
    - name: asgiref-3.4.1.tar.gz
      sha256: 1saqgpgbdvb8awzm0f0640j0im55hkrfzvcw683cgqw4ni3apwaf
      url: https://pypi.org/packages/source/a/asgiref/asgiref-3.4.1.tar.gz
  python: "3.8"
```

### Ruby

#### makeRubyVersion

Get a specific [Ruby][ruby] interpreter.

Types:

- makeRubyVersion (`function str -> package`):

  - (`enum [ "2.7" "3.0" "3.1" ]`):
    Version of the [Ruby][ruby] interpreter.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ makeRubyVersion
, makeScript
, ...
}:
makeScript {
  entrypoint = ''
    ruby --version
  '';
  name = "example";
  searchPaths = {
    bin = [ (makeRubyVersion "2.7") ];
  };
}
```

```bash
$ m . /example

    ruby 2.6.8p205 (2021-07-07) [x86_64-linux]
```

#### makeRubyGemsInstall

Fetch and install the specified [Ruby][ruby] gems
from the [Ruby community’s gem hosting service][rubygems].

Pre-requisites: [Generating a sourcesYaml](#makerubylock)

Types:

- makeRubyGemsInstall (`function { ... } -> package`):

  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - ruby (`enum [ "2.7" "3.0" ]`):
    Version of the [Ruby][ruby] interpreter.
  - searchPaths (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`.
    Defaults to `makeSearchPaths`'s defaults.
  - sourcesYaml (`package`):
    `sources.yaml` file
    computed as explained in the pre-requisites section.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ makeRubyGemsInstall
, ...
}:
makeRubyGemsInstall {
  name = "example";
  ruby = "3.0";
  sourcesYaml = projectPath "/makes/example/sources.yaml";
}
```

#### makeRubyGemsEnvironment

Create an environment where the specified [Ruby][ruby] gems
from the [Ruby community’s gem hosting service][rubygems]
are available.

Pre-requisites: [Generating a sourcesYaml](#makerubylock)

Types:

- makeRubyGemsEnvironment (`function { ... } -> package`):

  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - ruby (`enum [ "2.7" "3.0" ]`):
    Version of the [Ruby][ruby] interpreter.
  - searchPathsBuild (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`
    and used while installing gems.
    Defaults to `makeSearchPaths`'s defaults.
  - searchPathsRuntime (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`
    and propagated to the runtime environment.
    Defaults to `makeSearchPaths`'s defaults.
  - sourcesYaml (`package`):
    `sources.yaml` file
    computed as explained in the pre-requisites section.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ inputs
, makeRubyGemsEnvironment
, makeScript
, ...
}:
let
  env = makeRubyGemsEnvironment {
    name = "example";
    ruby = "3.0";
    searchPathsBuild.bin = [ inputs.nixpkgs.gcc ];
    searchPathsRuntime.rpath = [ inputs.nixpkgs.gcc.cc.lib ];
    sourcesYaml = projectPath "/makes/example/sources.yaml";
  };
in
makeScript {
  entrypoint = ''
    slimrb --version
  '';
  name = "example";
  searchPaths.source = [ env ];
}
```

```bash
$ m . /example

    Slim 4.1.0
```

### Containers

#### makeContainerImage

Build a container image in [OCI Format][oci_format].

A container image is composed of:

- 0 or more layers (binary blobs).
  - Each layer contains a snapshot of the root file system (`/`),
    they represent portions of it.
  - When the container is executed
    all layers are squashed together
    to compose the root
    of the file system (`/`).
- A JSON manifest (metadata)
  that describes important aspects of the container,
  for instance its layers, environment variables, entrypoint, etc.

Resources:

- https://grahamc.com/blog/nix-and-layered-docker-images

Types:

- makeContainerImage (`function { ... } -> package`):
  - layers (`listOf package`): Optional.
    Layers of the container.
    Defaults to `[ ]`.
  - maxLayers (`ints.positive`): Optional.
    Maximum number of layers the container can have.
    Defaults to `65`.
  - config (`attrsOf anything`): Optional.
    Configuration manifest as described in
    [OCI Runtime Configuration Manifest][oci_runtime_config]
    Defaults to `{ }`.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ inputs
, makeContainerImage
, makeDerivation
, ...
}:
makeContainerImage {
  config = {
    Env = [
      # Do not use this for sensitive values, it's not safe.
      "EXAMPLE_ENV_VAR=example-value"
    ];
    WorkingDir = "/working-dir";
  };
  layers = [
    inputs.nixpkgs.coreutils # ls, cat, etc
    (makeDerivation {
      name = "custom-layer";
      builder = ''
        # $out represents the final container root file system: /
        #
        # The following commands are equivalent in Docker to:
        #   RUN mkdir /working-dir
        #   RUN echo my-file-contents > /working-dir/my-file
        #
        mkdir -p $out/working-dir
        echo my-file-contents > $out/working-dir/my-file
      '';
    })
  ];
}
```

```bash
$ m . /example

    Creating layer 1 from paths: ['/nix/store/zqaqyidzsqc7z03g4ajgizy2lz1m19xz-libunistring-0.9.10']
    Creating layer 2 from paths: ['/nix/store/xjjdyb66g3cxd5880zspazsp5f16lbxz-libidn2-2.3.1']
    Creating layer 3 from paths: ['/nix/store/wvgyhnd3rn6dhxzbr5r71gx2q9mhgshj-glibc-2.32-48']
    Creating layer 4 from paths: ['/nix/store/ip0pxdd49l1v3cmxsvw8ziwmqhyzg5pf-attr-2.4.48']
    Creating layer 5 from paths: ['/nix/store/26vpasbj38nhj462kqclwp2i6s3hhdba-acl-2.3.1']
    Creating layer 6 from paths: ['/nix/store/937f5738d2frws07ixcpg5ip176pfss1-coreutils-8.32']
    Creating layer 7 from paths: ['/nix/store/fc24830z8lqa657grb3snvjjv9vxs7ql-custom-layer']
    Creating layer 8 with customisation...
    Adding manifests...
    Done.

    /nix/store/dvif4xy1l0qsjblxvzzcr6map1hg22w5-container-image.tar.gz

$ docker load < /nix/store/dvif4xy1l0qsjblxvzzcr6map1hg22w5-container-image.tar.gz

    b5507f5bda26: Loading layer  133.1kB/133.1kB
    da2b3a66ea19: Loading layer  1.894MB/1.894MB
    eb4c566a2922: Loading layer  10.24kB/10.24kB
    19b7be559bbc: Loading layer  61.44kB/61.44kB
    Loaded image: container-image:latest

$ docker run container-image:latest pwd

    /working-dir

$ docker run container-image:latest ls .

    my-file

$ docker run container-image:latest cat my-file

    my-file-contents

$ docker run container-image:latest ls /

    bin
    dev
    etc
    libexec
    nix
    proc
    sys
    working-dir
```

### Format conversion

#### fromJson

Convert a [JSON][json] formatted string
to a [Nix][nix] expression.

Types:

- fromJson (`function str -> anything`):

  - (`str`):
    [JSON][json] formatted string to convert.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ fromJson
, makeDerivation
, ...
}:
let
  data = fromJson ''
    {
      "name": "John",
      "lastName": "Doe",
      "tickets": 3
    }
  '';
in
makeDerivation {
  env = {
    envName = data.name;
    envLastName = data.lastName;
    envTickets = data.tickets;
  };
  builder = ''
    info "Name is: $envName"
    info "Last name is: $envLastName"
    info "Tickets is: $envTickets"
  '';
  name = "example";
}
```

```bash
$ m . /example

    [INFO] Name is: John
    [INFO] Last name is: Doe
    [INFO] Tickets is: 3
```

#### fromToml

Convert a [TOML][toml] formatted string
to a [Nix][nix] expression.

Types:

- fromToml (`function str -> anything`):

  - (`str`):
    [TOML][toml] formatted string to convert.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ fromToml
, makeDerivation
, ...
}:
let
  data = fromToml ''
    [example]
    name = "John"
    lastName = "Doe"
    tickets = 3
  '';
in
makeDerivation {
  env = {
    envName = data.example.name;
    envLastName = data.example.lastName;
    envTickets = data.example.tickets;
  };
  builder = ''
    info "Name is: $envName"
    info "Last name is: $envLastName"
    info "Tickets is: $envTickets"
  '';
  name = "example";
}
```

```bash
$ m . /example

    [INFO] Name is: John
    [INFO] Last name is: Doe
    [INFO] Tickets is: 3
```

#### fromYaml

Convert a [YAML][yaml] formatted string
to a [Nix][nix] expression.

Types:

- fromYaml (`function str -> anything`):

  - (`str`):
    [YAML][yaml] formatted string to convert.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ fromYaml
, makeDerivation
, ...
}:
let
  data = fromYaml ''
    name: "John"
    lastName: "Doe"
    tickets: 3
  '';
in
makeDerivation {
  env = {
    envName = data.name;
    envLastName = data.lastName;
    envTickets = data.tickets;
  };
  builder = ''
    info "Name is: $envName"
    info "Last name is: $envLastName"
    info "Tickets is: $envTickets"
  '';
  name = "example";
}
```

```bash
$ m . /example

    [INFO] Name is: John
    [INFO] Last name is: Doe
    [INFO] Tickets is: 3
```

#### toBashArray

Transform a list of arguments
into a [Bash][bash] array.
It can be used for passing
several arguments from [Nix][nix]
to [Bash][bash].

Types:

- toBashArray (`function (listOf strLike) -> package`):

  - (`listOf strLike`):
    list of arguments
    to transform.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ toBashArray
, makeDerivation
, ...
}:
makeDerivation {
  env = {
    envTargets = toBashArray [ "first" "second" "third" ];
  };
  builder = ''
    source "$envTargets/template" export targets
    for target in "''${targets[@]}"; do
      info "$target"
      info ---
    done
  '';
  name = "example";
}
```

```bash
$ m . /example

    [INFO] first
    [INFO] ---
    [INFO] second
    [INFO] ---
    [INFO] third
    [INFO] ----
```

#### toBashMap

Transform a [Nix][nix] `attrsOf strLike` expression
into a [Bash][bash] associative array (map).
It can be used for passing
several arguments from [Nix][nix]
to [Bash][bash].
You can combine with toBashArray for more complex structures.

Types:

- toBashMap (`function (attrsOf strLike) -> package`):

  - (`attrsOf strLike`):
    expression to transform.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ toBashMap
, makeDerivation
, ...
}:
makeDerivation {
  env = {
    envData = toBashMap {
      name = "Makes";
      tags = "ci/cd, framework, nix";
    };
  };
  builder = ''
    source "$envData/template" data

    for target in "''${!targets[@]}"; do
      info "$target"
      info ---
    done
  '';
  name = "example";
}
```

```bash
$ m . /example

  [INFO] key: tags
  [INFO] value: ci/cd, framework, nix
  [INFO] ---
  [INFO] key: name
  [INFO] value: Makes
  [INFO] ---
```

#### toFileJson

Convert a [Nix][nix] expression
into a [JSON][json] file.

Types:

- toFileJson (`function str anything -> package`):

  - (`str`):
    Name of the created file.
  - (`anything`):
    Nix expression to convert.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ toFileJson
, makeDerivation
, ...
}:
makeDerivation {
  env = {
    envFile = toFileJson "example.json" { name = "value"; };
  };
  builder = ''
    cat $envFile
  '';
  name = "example";
}
```

```bash
$ m . /example

    {"name": "value"}
```

#### toFileJsonFromFileYaml

Use [yq][yq] to
transform a [YAML][yaml] file
into its [JSON][json]
equivalent.

Types:

- toFileJsonFromFileYaml (`function package -> package`):

  - (`package`):
    [YAML][yaml] file to transform.

Examples:

```yaml
# /path/to/my/project/makes/example/test.yaml

name: "John"
lastName: "Doe"
tickets: 3
```

```nix
# /path/to/my/project/makes/example/main.nix
{ makeDerivation
, projectPath
, toFileJsonFromFileYaml
, ...
}:
makeDerivation {
  env = {
    envJson =
      toFileJsonFromFileYaml
        (projectPath "/makes/example/test.yaml");
  };
  builder = ''
    cat "$envJson"
  '';
  name = "example";
}
```

```bash
$ m . /example

{
  "name": "John",
  "lastName": "Doe",
  "tickets": 3
}
```

#### toFileYaml

Convert a [Nix][nix] expression
into a [YAML][yaml] file.

Types:

- toFileYaml (`function str anything -> package`):

  - (`str`):
    Name of the created file.
  - (`anything`):
    Nix expression to convert.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ toFileYaml
, makeDerivation
, ...
}:
makeDerivation {
  env = {
    envFile = toFileYaml "example.yaml" { name = "value"; };
  };
  builder = ''
    cat $envFile
  '';
  name = "example";
}
```

```bash
$ m . /example

    name: value
```

### Patchers

#### pathShebangs

Replace common [shebangs][shebang] for its [Nix][nix] equivalent.

For example:

- `#! /bin/env xxx` -> `/nix/store/..-name/bin/xxx`
- `#! /usr/bin/env xxx` -> `/nix/store/..-name/bin/xxx`
- `#! /path/to/my/xxx` -> `/nix/store/..-name/bin/xxx`

Types:

- pathShebangs (`package`):
  When sourced,
  it exports a [Bash][bash] function called `patch_shebangs`
  into the evaluation context.
  This function receives one or more files or directories as arguments
  and replace shebangs of the executable files in-place.
  Note that only shebangs that resolve to executables in the `"${PATH}"`
  (a.k.a. `searchPaths.bin`) will be taken into account.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ __nixpkgs__
, makeDerivation
, patchShebangs
, ...
}:
makeDerivation {
  env = {
    envFile = builtins.toFile "my_file.sh" ''
      #! /usr/bin/env bash

      echo Hello!
    '';
  };
  builder = ''
    copy $envFile $out

    chmod +x $out
    patch_shebangs $out

    cat $out
  '';
  name = "example";
  searchPaths = {
    bin = [ __nixpkgs__.bash ]; # Propagate bash so `patch_shebangs` "sees" it
    source = [ patchShebangs ];
  };
}
```

```bash
$ m . /example

    #! /nix/store/dpjnjrqbgbm8a5wvi1hya01vd8wyvsq4-bash-4.4-p23/bin/bash

    echo Hello!
```

### Others

#### chunks

Split a given list into N chunks
for workload distributed parallelization.

Types:

- chunks (`function list, ints.positive -> listOf (listOf Any)`):

  - (`list`):
    List to split into chunks.
  - (`ints.positive`):
    Number of chunks to create from list.

Example:

```nix
{
  chunks,
  inputs,
  makeDerivation,
  makeDerivationParallel,
}: let
numbers = [0 1 2 3 4 5 6 7 8 9];
myChunks =  chunks numbers 3; # [[0 1 2 3] [4 5 6] [7 8 9]]

buildNumber = n: makeDerivation {
  name = "build-number-${n}";
  env.envNumber = n;
  builder = ''
    echo "$envNumber"
    touch "$out"
  '';
};
in
  makeDerivationParallel {
    dependencies = builtins.map buildNumber (inputs.nixpkgs.lib.lists.elemAt myChunks 0);
    name = "build-numbers-0";
  }
```

#### calculateCvss3

Calculate [CVSS3][cvss3]
score and severity
for a [CVSS3 Vector String][cvss3_vector_string].

Types:

- calculateCvss3 (`function str -> package`):

  - (`str`):
    [CVSS3 Vector String][cvss3_vector_string]
    to calculate.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ makeScript
, calculateCvss3
, ...
}:
makeScript {
  replace = {
    __argCalculate__ = calculateCvss3
      "CVSS:3.0/S:C/C:H/I:H/A:N/AV:P/AC:H/PR:H/UI:R/E:H/RL:O/RC:R/CR:H/IR:X/AR:X/MAC:H/MPR:X/MUI:X/MC:L/MA:X";
  };
  entrypoint = ''
    cat "__argCalculate__"
  '';
  name = "example";
}
```

```bash
$ m . /example

    {"score": {"base": 6.5, "temporal": 6.0, "environmental": 5.3}, "severity": {"base": "Medium", "temporal": "Medium", "environmental": "Medium"}}
```

#### makeSslCertificate

Self sign certificates by using [OpenSSL][openssl]
`openssl req` command, then using `openssl x509` to
print out the certificate in text form.

Types:

- makeSslCertificate (`function { ... } -> package`):

  - days (`ints.positive`): Optional.
    Ammount of days to certify the certificate for.
    Defaults to `30`.
  - keyType (`str`): Optional.
    Defines the key type for the certificate
    (option used for the `-newkey` option on the `req` command).
    It uses the form `rsa:nbits`, where `nbits` is the number of bits.
    Defaults to `rsa:4096`.
  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - options (`listOf (listOf str)`):
    Contains a list of options to create the certificate with your own needs.
    Here you can use the same options used with `openssl req`.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ makeScript
, makeSslCertificate
, ...
}:
let
  sslCertificate = makeSslCertificate {
    name = "name-example";
    options = [
      [ "-subj" "/CN=localhost" ]
    ];
  };
in
makeScript {
  replace = {
    __argSslCertificate__ = sslCertificate;
  };
  entrypoint = ''
    cat "__argSslCertificate__"
  '';
  name = "example";
}

```

```bash
$ m . /example

    -----BEGIN PRIVATE KEY-----
    MIIJQwIBADANBgkqhkiG9w0BAQEFAASCCS0wggkpAgEAAoICAQDQ/tFdIW3kL1IJ
    hjD11ZTTDvMXlO+Zm3Oc3Z67Kb9llNpdgyDXBXyFriAfDsDAw/Hrp7zSqzNMT5Qh
    fc1OFhM2ICuPaFCQONKsOulo3LhdjXfSDuvu1k0XMF0cDOVwhQkxYdsE9/jZQUSi
    CB4I2A8LLnkMvZ+ANJIFzjkxey2A+v3KMeE5aw2PLqj8H+jAuxM56fCgFrXhhmPh
    U6HNlhf+dvaV/PHjpr66HJf8gF/DwhzQ+ppYbVsBnuvzmiTz/dix9wu7m3/RxVIM
    OwEPcZU2VCXT2MCtXKd6H+h8vEdx1xrLYRTWUhrOnNgNrblXhlpo0frI6XloujR3
    o5x18/GjCht6gx3D/ze+g6bhgGVUxMIMuM5uCLyOxCG/M23WaAZVOgseqnggCVP7
    MA/c7sd+cIWfS5Yi04G0vXkiQDUMOhRIZM2CFKr6Lyi6hdU2bUkx9gWSQWPMcwko
    kFRkv1UpzWMfD8nMphuWwMJZckNDrmUb4kK8bfum/Q+9/EYNREEpDxz6OUNezjbq
    g5r8lFNcfmAySZXFGSZdANS+u1CpcyWzMtgUIvjtANeqjJw+zOMqQBBeSROpgusY
    z9N8G3ZPkArIKTpKRpPdwfIPCALd5ZLrdZAJMuPTHBFGRn/oxWg/zHNYBkLTiPAJ
    R9V8mz4Q59WFoF92vNmPVp1bcBtqjQIDAQABAoICAETZjXNWzfL8O9RzZrG1+N9G
    74J3SC+cbIvi3qXd7PW0AfQIfMsZPZp0cJSKsalPY+U0Txo/2BhtpukZnob48r9D
    /dWykcfRUGX4ymgHPp1jO3PyAnueEatv/Vx+Sx+0VAD2scaDQnGf9NJERlC3jM0s
    NCikV2VO7EQJWgIZCDaTeQQhRoc54y+mOXlFsdG8T2smzGSQ1r5DHahfetBVf/YO
    jtF+kNlkVzTMsq02RVYiHogh5rL246I3Dpgj0cSnfbmzHyRg58zdalgpIAJMctGB
    Cy0tHNx/x5SN6nMdO5QfPu59PvYT+kzSksJ+1q4kzqf1dN63O43qudooBiU9hf6N
    RrocVXwr/vXyo78gOKN706guxf5VP3+4ldeV5AP2tCSEsI0D2H/Mbt3PlLce6zxc
    BMb6lpM6XddMXkqU993ewhMqRMvvSuqNXuHp6dYmt76v0yL3GwaB3rqt1BtwPwOx
    TNmoP4wcoAjKL1Q66cIFW9oZT+XuxZFn57Ch6hrxNLKzEOgtbGtuCNuCQoDVBWX5
    CLj2Oh+rK9v0Zmz4NNNDsmY3m3ViMQz4i52PuChtm3E/2dR1GsoQsy8Js3IWC9g+
    Kr7cGyL3KcOVc7snx6d6CRqKaZTsiDOX5GlQbHb3KKUAVJlGB37rXITy/yFnPffz
    Rv91dVb/RFucmagBDUABAoIBAQD5A3+sHjQYgQI10ceiqEDqzqyjAog4Jg91Qt8M
    qII8fUZC2yUF2kyHYeokEr4LXiYSS5GvNJ0Fm8BF4/ShuRECkU+tG73Y8JMChjfD
    CU89d0G4X2I6AZShOAaWd4ypW5CsoVC7fa5Jzbd/C8RucXDJlZQlpl0Dr4VEs53Y
    +a6uSmw4EPMTTrCLH2bqWXLuW3reaZM38QrbLhk5kZRTYvo2YOdmfscFop4TbEJF
    qpOA0E2N5iWUnU4K6fVcBKIycsz2Ao9D1Jk1NzZGxvcvc0YxjoBSyqLZOZ9Z3Wh7
    YkfyUs4TuaEHP6/JxGBWTs7jmKdigeFfsNYRS8BFdSs3jsgBAoIBAQDW2+TkJBm2
    oXbTIuNSoYxdJocdScktLAfVH+YzrSQ78dbSs5hcVwS0WugD30Fr1n0cZ7EttbZE
    FF5ZxzqHVV0mrMH64OiuhVTW6bXzlJ+V6bs4Sq/fL/iiEIoNm5D2GNrWbcYEIJ8h
    Fj6QOyp8VnkAfLmYTb5ohlNQVZLr8IMpeTF4vQUCkP9umtn0S+lp8ZXNy6yTNSay
    mqxbZ0pju79nk+W99TapM4FNXLoHjtkqBVu4XYlS4qX8gd1plMzZdSvUW8fWjUhR
    BvbW+dqxCuryBjbHkB7rl3dSFFvl8I3JPy4fiIkHln3OEe0Cpas/IrTY+xshA3kt
    kMNE+3SO50KNAoIBAQDF0Wi4dBoQqVP3K1r7tcw0fNEagmVyrZG0JtaI+MjVgvOx
    IuSLfLs1Baz60UTWRQnbmNr4I8Tl8rBRFWF+pEWGE6gHLjWoRJ2U8MkVkKy5eKbl
    8ChZSm4nkRlyqTA+TjZlXZWEDLjLerheHhwDXO0rxz80la/owKQPSt2Hw/poDUlh
    VN21pdqL+vtICp1KC7RVQeupEjz8l+eEG0mI4OVDE8JgYzB6IpCPf346V+Lr/w7N
    Plr2b+zSsL+xRSERELAQc0IasaawZtcgbOlrcZj+v2Tj4IR0KtmTi1d4RUBAmlWJ
    x/rLhmWA1RdvGRY0Kk427FT9Lr8waEwrIYSekzgBAoIBACEDjLoZafIMAUwT8kYC
    GKU/hEdVzRmpyFJRIngSRJ0JXe7mNaUKoehsh3YA2faN8I9qx2i0oRr43j6BRFcD
    INsOdIfuAxK93flf09tnnNXWIjRWFYv/vP55+Bx7KN0HmKiWGXUM5iaZWmejD7Yn
    O1R91a63U2iQK0EOxRKH1D+NJbLdqGVqjjUaih7lgyoKOvByOUQtSJLs/UrWJjII
    6TIrIYP8p7d7+IRAmT0MEAZK6Hr9tFoOBV81PSY5/Pf07xUkPSKUduYsYcVKgvXt
    LYiet9AWLwoYLfdotW4xdjfUA2xI+HU4BICjdH2RoyyCUrN8cgCyne4IblitIo3K
    rwkCggEBAN0xdTlbZEI/r1O3iDNJXcXJg3HUMj78pz7c32ROMS2iwsQTyj+IHui8
    0J2FOdZ8TUlgoBfi3C1Y2NyNdyAJ3jiHnCrQz/sqTRYGds+aALfw1YZZuonUXAwc
    OxCZcMowzTvx5iCcaCY9jsdrr4TYGWSf2wmzSD87EYqNKLTd4asOCILatTWMw0AR
    xBHKugWHSokf9SNzirqxSNeqjjepMTA95LRiijKQAu9yhj0Zs35EUIu88KA5PZ4q
    0+URRTIuCtyjKBFC5qBhvbWzKe46hSy6OPyJFPgyo4OCC0NkesLQKcJwfTckK8Ne
    mSjLja2l8YqKkXqV6P3R6wVLMvCoCao=
    -----END PRIVATE KEY-----

```

#### sublist

Return a sublist of a given list using a starting and an ending index.

Types:

- sublist (`function list, ints.positive, ints.positive -> listOf Any`):

  - (`list`):
    List to get sublist from.
  - (`ints.positive`):
    Starting list index.
  - (`ints.positive`):
    Ending list index.

Example:

```nix
{
  sublist,
}: let
  list = [0 1 2 3 4 5 6 7 8 9];
  sublist = sublist list 3 5; # [3 4]
in {
  inherit sublist;
}
```

# Migrating to Makes

## From a Nix project

If your project currently uses [Nix][nix]
and you want to start using [Makes][makes] features
you can do the following:

```nix
let
  # Import the framework
  makes = import "${builtins.fetchGit {
    url = "https://github.com/fluidattacks/makes";
    ref = "refs/tags/22.11";
    rev = ""; # Add a commit here
  }}/src/args/agnostic.nix" { };
in
# Use the framework
makes.makePythonPypiEnvironment {
  name = "example";
  sourcesYaml = ./sources.yaml;
}
```

Most functions documented in the [Extending Makes][makes_extending] section
are available.
For a defailed list checkout:
[/src/args/agnostic.nix](./src/args/agnostic.nix).

# Contact an expert

- [Makes][makes] support: help@fluidattacks.com
- Cyber**security**: [Fluid Attacks][fluid_attacks]

# Contributors

<!-- Feel free to add/edit here your contact information -->

Thank you for your contribution!

We, at Makes, appreciate your effort,
and the improvements you've made to the project.
Your support helps to further our mission of making
CI/CD and Nix more accessible to the community :heart:

Individuals:

- Daniel Salazar (
  [Email](mailto:podany270895@gmail.com)
  )
- David Arnold (
  [Email](mailto:david.arnold@iohk.io)
  )
- Diego Restrepo (
  [Email](mailto:drestrepo@fluidattacks.com)
  )
- Luis Saavedra (
  [Email](mailto:lsaavedra@fluidattacks.com)
  )
- Timothy DeHerrera (
  [Email](mailto:tim.deherrera@iohk.io)
  )

Companies:

- Fluid Attacks (
  [Home](https://fluidattacks.com)
  )
- Input Output (
  [Home](https://iohk.io)
  )

Project leaders:

- 2021-10 to present: John Perez (
  [Email](mailto:jperez@fluidattacks.com) |
  [GitHub](https://github.com/jpverde)
  )
- [2020-12](https://gitlab.com/fluidattacks/product/-/commit/b5305a8ddb5d7b11f22434618fa079bf70d4a45c)
  to 2021-10: Kevin Amado (
  [Email](mailto:kamadorueda@gmail.com) |
  [GitHub](https://github.com/kamadorueda) |
  [LinkedIn](https://www.linkedin.com/in/kamadorueda/)
  )

# References

- [ajv_cli]: https://github.com/ajv-validator/ajv-cli
  [ajv-cli][ajv_cli]
- [alejandra]: https://github.com/kamadorueda/alejandra
  [Alejandra][alejandra]
- [ansible]: https://www.ansible.com/
  [Ansible][ansible]
- [apache_ant]: https://ant.apache.org/
  [Apache Ant][apache_ant]
- [apache_maven]: https://maven.apache.org/
  [Apache Maven][apache_maven]
- [apt]: https://en.wikipedia.org/wiki/APT_(software)
  [Advanced Package Tool][apt]
- [ascii_armor]: https://www.techopedia.com/definition/23150/ascii-armor
  [ASCII Armor][ascii_armor]
- [aws]: https://aws.amazon.com/
  [Amazon Web Services (AWS)][aws]
- [aws_batch]: https://aws.amazon.com/batch/
  [AWS Batch][aws_batch]
- [aws_cli]: https://aws.amazon.com/cli/
  [AWS CLI][aws_cli]
- [bandit]: https://github.com/PyCQA/bandit
  [Bandit][bandit]
- [bash]: https://www.gnu.org/software/bash/
  [Bash][bash]
- [bash_tutorial_shell_scripting]: https://www.tutorialspoint.com/unix/shell_scripting.htm
  [Shell Scripting Tutorial][bash_tutorial_shell_scripting]
- [black]: https://github.com/psf/black
  [Black][black]
- [buck]: https://buck.build/
  [Buck][buck]
- [cachix]: https://cachix.org/
  [Cachix][cachix]
- [calver]: https://calver.org/
  [Calendar Versioning][calver]
- [chef]: https://www.chef.io/
  [Chef][chef]
- [ci_cd]: https://en.wikipedia.org/wiki/CI/CD
  [CI/CD][ci_cd]
- [circle_ci]: https://circleci.com/
  [Circle CI][circle_ci]
- [classpath]: https://en.wikipedia.org/wiki/Classpath
  [CLASSPATH Environment Variable][classpath]
- [clj-kondo]: https://github.com/clj-kondo/clj-kondo
  [clj-kondo][clj-kondo]
- [cli_completion]: https://en.wikipedia.org/wiki/Command-line_completion
  [Command-line Completion][cli_completion]
- [commitlint]: https://commitlint.js.org/#/
  [commitlint][commitlint]
- [crystal]: https://crystal-lang.org/
  [Crystal Programming Language][crystal]
- [crystal_library_path]: https://crystal-lang.org/reference/guides/static_linking.html
  [CRYSTAL_LIBRARY_PATH Environment Variable][crystal_library_path]
- [cvss3]: https://www.first.org/cvss/v3.0/specification-document
  [CVSS3][cvss3]
- [cvss3_vector_string]: https://www.first.org/cvss/v3.0/specification-document#Vector-String
  [CVSS3 Vector String][cvss3_vector_string]
- [direnv]: https://direnv.net/
  [direnv][direnv]
- [docker]: https://www.docker.com/
  [Docker][docker]
- [doctoc]: https://github.com/thlorenz/doctoc
  [DocToc][doctoc]
- [env_var]: https://en.wikipedia.org/wiki/Environment_variable
  [Environment Variable][env_var]
- [fluid_attacks]: https://fluidattacks.com
  [Fluid Attacks][fluid_attacks]
- [gem_path]: https://guides.rubygems.org/command-reference
  [GEM_PATH Environment Variable][gem_path]
- [git]: https://git-scm.com/
  [Git][git]
- [git_mailmap]: https://git-scm.com/docs/gitmailmap
  [Git Mailmap][git_mailmap]
- [github]: https://github.com
  [GitHub][github]
- [github_actions]: https://github.com/features/actions
  [GitHub Actions][github_actions]
- [github_workflows]: https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions
  [GitHub Workflows][github_workflows]
- [gitlab_ci]: https://docs.gitlab.com/ee/ci/
  [GitLab CI][gitlab_ci]
- [gitlab_ci_ref]: https://docs.gitlab.com/ee/ci/yaml/
  [GitLab CI configuration syntax][gitlab_ci_ref]
- [gitlab_ci_oidc]: https://docs.gitlab.com/ee/ci/cloud_services/aws/index.html
  [GitLab CI OIDC][gitlab_ci_oidc]
- [gitlab_vars]: https://docs.gitlab.com/ee/ci/variables/
  [GitLab Variables][gitlab_vars]
- [gnu_make]: https://www.gnu.org/software/make/
  [GNU Make][gnu_make]
- [gnu_coreutils]: https://www.gnu.org/software/coreutils/
  [GNU Coreutils][gnu_coreutils]
- [gnu_gpg]: https://gnupg.org/
  [Gnu Privacy Guard][gnu_gpg]
- [gradle]: https://gradle.org/
  [Gradle][gradle]
- [grunt]: https://gruntjs.com/
  [Grunt][grunt]
- [gulp]: https://gulpjs.com/
  [Gulp][gulp]
- [hash]: https://en.wikipedia.org/wiki/Hash_function
  [Hash Function][hash]
- [import_linter]: https://import-linter.readthedocs.io/en/stable/
  [import-linter][import_linter]
- [isort]: https://github.com/PyCQA/isort
  [isort][isort]
- [json]: https://www.json.org/json-en.html
  [JSON][json]
- [json_schema]: https://json-schema.org/
  [JSON Schema][json_schema]
- [kubeconfig]: https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#the-kubeconfig-environment-variable
  [KUBECONFIG Environment Variable][kubeconfig]
- [kubernetes]: https://kubernetes.io/
  [Kubernetes][kubernetes]
- [leiningen]: https://leiningen.org/
  [Leiningen][leiningen]
- [linux]: https://en.wikipedia.org/wiki/Linux
  [Linux][linux]
- [lizard]: https://github.com/terryyin/lizard
  [Lizard][lizard]
- [mailmap_linter]: https://github.com/kamadorueda/mailmap-linter
  [Mailmap Linter][mailmap_linter]
- [makes]: https://github.com/fluidattacks/makes
  [Makes][makes]
- [makes_commits]: https://github.com/fluidattacks/makes/commits/main
  [Makes Commits][makes_commits]
- [makes_environment]: #environment
  [Makes Environment][makes_environment]
- [makes_extending]: #extending-makes
  [Makes - Extending][makes_extending]
- [makes_issues]: https://github.com/fluidattacks/makes/issues
  [Makes issues][makes_issues]
- [makes_releases]: https://github.com/fluidattacks/makes/releases
  [Makes Releases][makes_releases]
- [makes_secrets]: #secrets
  [Makes Secrets][makes_secrets]
- [markdown_lint]: https://github.com/markdownlint/markdownlint
  [Markdown lint tool][markdown_lint]
- [mypy]: https://mypy.readthedocs.io/en/stable/
  [MyPy][mypy]
- [mypypath]: https://mypy.readthedocs.io/en/stable/running_mypy.html
  [MYPYPATH Environment Variable][mypypath]
- [nix]: https://nixos.org
  [Nix][nix]
- [nix_derivation]: https://nixos.org/manual/nix/unstable/expressions/derivations.html
  [Nix Derivation][nix_derivation]
- [nix_download]: https://nixos.org/download
  [Nix Download Page][nix_download]
- [nix_flakes]: https://www.tweag.io/blog/2020-05-25-flakes/
  [Nix Flakes][nix_flakes]
- [nix_platforms]: https://nixos.org/manual/nix/unstable/installation/supported-platforms.html
  [Nix Supported Platforms][nix_platforms]
- [nix_linter]: https://github.com/Synthetica9/nix-linter'
  [nix-linter][nix_linter]
- [nix_pills]: https://nixos.org/guides/nix-pills/
  [Nix Pills][nix_pills]
- [node_js]: https://nodejs.org/en/
  [NODE_JS][node_js]
- [node_path]: https://nodejs.org/api/modules.html
  [NODE_PATH][node_path]
- [nomad]: https://www.nomad.io/
  [nomad][nomad]
- [npm]: https://www.npmjs.com/
  [Node Package Manager (NPM)][npm]
- [ocaml]: https://ocaml.org/
  [OCaml][ocaml]
- [ocamlpath]: https://github.com/ocaml/ocaml/issues/8898
  [OCAMLPATH Environment Variable][ocamlpath]
- [caml_ld_library_path]: https://ocaml.org/manual/runtime.html
  [CAML_LD_LIBRARY_PATH Environment Variable][caml_ld_library_path]
- [oci_format]: https://github.com/opencontainers/image-spec
  [Open Container Image specification][oci_format]
- [oci_runtime_config]: https://github.com/moby/moby/blob/master/image/spec/v1.2.md#container-runconfig-field-descriptions
  [OCI Runtime Configuration Manifest][oci_runtime_config]
- [openssl]: https://www.openssl.org/docs/
  [OpenSSL][openssl]
- [packer]: https://www.packer.io/
  [Packer][packer]
- [path]: https://en.wikipedia.org/wiki/PATH_(variable)
  [PATH Environment Variable][path]
- [pip]: https://pypi.org/project/pip/
  [Package Installer for Python (pip)][pip]
- [pkg_config]: https://www.freedesktop.org/wiki/Software/pkg-config/
  [pkg-config][pkg_config]
- [pkg_config_path]: https://linux.die.net/man/1/pkg-config
  [PKG_CONFIG_PATH Environment Variable][pkg_config_path]
- [prospector]: http://prospector.landscape.io/en/master/
  [Prospector][prospector]
- [pytest]: https://docs.pytest.org/
  [pytest][pytest]
- [python]: https://www.python.org/
  [Python][python]
- [pythonpath]: https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH
  [PYTHONPATH Environment Variable][pythonpath]
- [python_pypi]: https://pypi.org/
  [Python Packaging Index (PyPI)][python_pypi]
- [rake]: https://github.com/ruby/rake
  [Rake][rake]
- [rbac-police]: https://github.com/PaloAltoNetworks/rbac-police
  [rbac-police][rbac-police]
- [reproducible_builds]: https://reproducible-builds.org/
  [Reproducible Builds][reproducible_builds]
- [rpath]: https://en.wikipedia.org/wiki/Rpath
  [RPath][rpath]
- [rpm]: https://rpm.org/
  [RPM Package Manager][rpm]
- [ruby]: https://www.ruby-lang.org/en/
  [Ruby Language][ruby]
- [rubygems]: https://rubygems.org/gems/slim
  [Ruby community’s gem hosting service][rubygems]
- [sbt]: https://www.scala-sbt.org/
  [sbt][sbt]
- [scons]: https://scons.org/
  [SCons][scons]
- [scorecard]: https://github.com/ossf/scorecard
  [Scorecard][scorecard]
- [shebang]: https://en.wikipedia.org/wiki/Shebang_(Unix)
  [Shebang][shebang]
- [shellcheck]: https://github.com/koalaman/shellcheck
  [ShellCheck][shellcheck]
- [shfmt]: https://github.com/mvdan/sh
  [SHFMT][shfmt]
- [sops]: https://github.com/mozilla/sops
  [Mozilla's Sops][sops]
- [terraform]: https://www.terraform.io/
  [Terraform][terraform]
- [terraform_fmt]: https://www.terraform.io/docs/cli/commands/fmt.html
  [Terraform FMT][terraform_fmt]
- [terraform_workspaces]: https://developer.hashicorp.com/terraform/language/state/workspaces
  [Terraform Workspaces][terraform_workspaces]
- [tflint]: https://github.com/terraform-linters/tflint
  [TFLint][tflint]
- [toml]: https://github.com/toml-lang/toml
  [TOML][toml]
- [travis_ci]: https://travis-ci.org/
  [Travis CI][travis_ci]
- [travis_ci_ref]: https://config.travis-ci.com/
  [Travis CI reference][travis_ci_ref]
- [travis_env_vars]: https://docs.travis-ci.com/user/environment-variables
  [Travis Environment Variables][travis_env_vars]
- [vulnix]: https://github.com/flyingcircusio/vulnix
  [Vulnix][vulnix]
- [x86_64]: https://en.wikipedia.org/wiki/X86-64
  [x86-64][x86_64]
- [yaml]: https://yaml.org/
  [YAML][yaml]
- [yamlfix]: https://github.com/lyz-code/yamlfix
  [yamlfix][yamlfix]
- [yq]: https://github.com/mikefarah/yq
  [yq][yq]
- [yum]: http://yum.baseurl.org/
  [Yellowdog Updated Modified (yum)][yum]
