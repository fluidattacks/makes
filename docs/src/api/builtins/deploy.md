## computeOnAwsBatch

Submit a job to a [AWS BATCH](https://aws.amazon.com/batch/) queue.

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
        after which Batch terminates your jobs
        if they have not finished.
    - command (`listOf str`):
        The command to send to the container.
        It overrides the one specified
        in the Batch job definition.
        Additional arguments can be propagated when running this module output.
    - definition (`str`):
        Name of the Batch job definition
        that we will use as base for submitting the job.
        In general an Batch job definition is required
        in order to specify which container image
        our job is going to run on.
    - environment (`listOf str`): Optional.
        Name of the environment variables
        whose names and values should be copied from the machine running Makes
        to the machine on Batch running the job.
        Defaults to `[ ]`.
    - includePositionalArgsInName (`bool`): Optional.
        Enable to make positional arguments part of the job name.
        This is useful for identifying jobs
        in the Batch console
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
        Name of the Batch queue we should submit the job to.
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

Example:

=== "makes.nix"

    ```nix
    {
      outputs,
      ...
    }: {
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

=== "Invocation"

    ```bash
    m . /computeOnAwsBatch/helloWorld 1 2 3
    ```

Note that positional arguments (`[ "1" "2" "3" ]` in this case)
will be appended to the end of `command`
before sending the job to Batch.

## deployContainerImage

Deploy a set of container images
in [OCI Format](https://github.com/opencontainers/image-spec)
to the specified container registries.

For details on how to build container images in OCI Format
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
            Name of the environment variable
            that stores the value of the registry token.
        - user (`str`):
            Name of the environment variable
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
        Derivation that contains the container image in OCI Format.
    - tag (`str`):
        The tag under which the image will be stored in the registry.

Example:

=== "makes.nix"

    ```nix
    {
      inputs,
      outputs,
      ...
    }: {
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
    }
    ```

=== "Invocation DockerHub"

    ```bash
    DOCKER_HUB_USER=user DOCKER_HUB_PASS=123 m . /deployContainerImage/nginxDockerHub
    ```

=== "Invocation GitHub"

    ```bash
    GITHUB_ACTOR=user GITHUB_TOKEN=123 m . /deployContainerImage/makesLatest
    ```

=== "Invocation GitLab"

    ```bash
    CI_REGISTRY_USER=user CI_REGISTRY_PASSWORD=123 m . /deployContainerImage/makesGitLab
    ```

## deployTerraform

Deploy Terraform code
by performing a `terraform apply`
over the specified Terraform modules.

Types:

- deployTerraform:
    - modules (`attrsOf moduleType`): Optional.
        Path to Terraform modules to lint.
        Defaults to `{ }`.
- moduleType (`submodule`):
    - setup (`listOf package`): Optional.
        [Makes Environment][makes_environment]
        or [Makes Secrets][makes_secrets]
        to `source` (as in Bash's `source`)
        before anything else.
        Defaults to `[ ]`.
    - src (`str`):
        Path to the Terraform module.
    - version (`enum [ "0.14" "0.15" "1.0" ]`):
        Terraform version your module is built with.

Example:

=== "makes.nix"

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

=== "Invocation"

    ```bash
    m . /deployTerraform/module1
    ```

## taintTerraform

Taint Terraform code
by performing a `terraform taint $resource`
over the specified Terraform modules.

Types:

- taintTerraform:
    - modules (`attrsOf moduleType`): Optional.
        Path to Terraform modules to lint.
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
        Path to the Terraform module.
    - version (`enum [ "0.14" "0.15" "1.0" ]`):
        Terraform version your module is built with.

Example:

=== "makes.nix"

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

=== "Invocation"

    ```bash
    m . /taintTerraform/module
    ```

## deployNomad

Deploy [Nomad](https://www.nomad.io/) code
by performing a `nomad plan`
over the specified Nomad jobs / namespaces.

Types:

- deployNomad:
    - jobs (`attrsOf jobsType`): Optional.
        Path to Nomad jobs to deploy.
        Defaults to `{ }`.
    - namespaces (`attrsOf namespacesType`): Optional.
        Path to Nomad namespaces to deploy.
        Defaults to `{ }`.
- jobsType (`submodule`):
    - setup (`listOf package`): Optional.
        [Makes Environment][makes_environment]
        or [Makes Secrets][makes_secrets]
        to `source` (as in Bash's `source`)
        before anything else.
        Defaults to `[ ]`.
    - src (`path`):
        Path to the Nomad job (hcl or json).
    - version (`enum [ "1.0" "1.1" ]`):
        Nomad version your job is built with.
        Defaults to `"1.1"`.
    - namespace (`str`):
        Nomad namespace to deploy the job into.
- namespacesType (`submodule`):
    - setup (`listOf package`): Optional.
        Makes Environment
        or Makes Secrets
        to `source` (as in Bash's `source`)
        before anything else.
        Defaults to `[ ]`.
    - jobs (`attrOf path`):
        Attributes of path to the Nomad jobs (hcl or json).
    - version (`enum [ "1.0" "1.1" ]`):
        Nomad version your jobs are built with.
        Defaults to `"1.1"`.

Example:

=== "makes.nix"

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

=== "Invocation"

    ```bash
    m . /deployNomad/default/job1
    ```

[makes_environment]: ./environment.md
[makes_secrets]: ./secrets.md
