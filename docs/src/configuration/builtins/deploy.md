## computeOnAwsBatch

Submit a job to a [AWS BATCH](https://aws.amazon.com/batch/) queue.

When used as a Makes declaration (at makes.nix attrs):

- computeOnAwsBatch: `attrsOf JobType` (Optional Attr)
    Job groups to submit.
    Defaults to `{ }`.

When used as a makes input:

- computeOnAwsBatch: `JobType -> SourceAble`
    Source able batch file to send jobs to aws batch.

???+ warning

    When used as a makes input, all arguments are required
    and defaults are not available.
    However nested jobs (see `nextJob` argument)
    do have defaults enabled.

Types:

- `JobType` = `attrs`
    - allowDuplicates: `bool` (Optional Attr)
        Set to `false` in order to prevent submitting the job
        if there is already a job in the queue with the same name.
        Defaults to `false`.
    - attempts: `positiveInt` (Optional Attr)
        If the value of attempts is greater than one,
        the job is retried on failure the same number of attempts as the value.
        Defaults to `1`.
    - attemptDurationSeconds: `positiveInt`
        The time duration in seconds
        (measured from the job attempt's startedAt timestamp)
        after which Batch terminates your jobs
        if they have not finished.
    - command: `listOf str`
        The command to send to the container.
        It overrides the one specified
        in the Batch job definition.
        Additional arguments can be propagated when running this module output.
    - dryRun: `bool`  (Optional Attr) (Not supported on nextJob)
        Do not send any job. Only check the correctness of the pipeline definition.
    - definition: `str`
        Name of the Batch job definition
        that we will use as base for submitting the job.
        In general an Batch job definition is required
        in order to specify which container image
        our job is going to run on.
    - environment: `listOf str` (Optional Attr)
        Name of the environment variables
        whose names and values should be copied from the machine running Makes
        to the machine on Batch running the job.
        Defaults to `[ ]`.
    - includePositionalArgsInName: `bool` (Optional Attr).
        Enable to make positional arguments part of the job name.
        This is useful for identifying jobs
        in the Batch console
        more easily.
        Defaults to `true`.
    - nextJob: `attrs` (Optional Attr)
        The next job that will be executed after its parent finish.
        You must provide a `name` attribute and all the required
        attrs of `JobType`.
        Defaults to `{ }`.
    - memory: `positiveInt`
        Amount of memory, in MiB that is reserved for the job.
    - parallel: `positiveInt` (Optional Attr)
        Number of parallel jobs to trigger using
        [Batch Array Jobs](https://docs.aws.amazon.com/batch/latest/userguide/array_jobs.html).
        Defaults to `1`.
    - propagateTags: `bool` (Optional Attr)
        Enable tags to be propagated into the ECS tasks.
        Defaults to `true`.
    - queue: `nullOr str`
        Name of the Batch queue we should submit the job to.
        If `null` then queue is fetch from
        the `MAKES_COMPUTE_ON_AWS_BATCH_QUEUE` environment variable at runtime.
    - setup: `listOf SourceAble`
        [Makes Environment][makes_environment]
        or [Makes Secrets][makes_secrets]
        to `source` (as in Bash's `source`)
        before anything else.
        Defaults to `[ ]`.
    - tags: `attrsOf str` (Optional Attr).
        Tags to apply to the batch job.
        Defaults to `{ }`.
    - vcpus: `positiveInt`
        Amount of virtual CPUs that is reserved for the job.

Example:

=== "makes.nix"

    ```nix
    {
      computeOnAwsBatch,
      outputs,
      ...
    }: {
      computeOnAwsBatch = {
        myJob = {
          attempts = 1;
          attemptDurationSeconds = 43200;
          command = [ "m" "github:fluidattacks/makes@main" "/myJob" ];
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
          };
          vcpus = 1;
        };
      };
    }
    ```

Note that positional arguments (`[ "1" "2" "3" ]` in this case)
will be appended to the end of `command`
before sending the job to Batch.

## deployContainer

Deploy a container image
in [OCI Format](https://github.com/opencontainers/image-spec).

For details on how to build container images in OCI format,
please see [makeContainerImage](/api/extensions/containers#makecontainerimage).

Types:

- deployContainer (`attrsOf targetType`):
- targetType (`submodule`):
    - credentials:
        - token (`str`):
            Name of the environment variable
            that stores the value of the registry token.
        - user (`str`):
            Name of the environment variable
            that stores the value of the registry user.
    - image (`str`):
        Container registry path to which the image will be copied to.
    - setup (`listOf package`): Optional.
        [Makes Environment][makes_environment]
        or [Makes Secrets][makes_secrets]
        to `source` (as in Bash's `source`)
        before anything else.
        Defaults to `[ ]`.
    - sign (`bool`): Optional.
        Sign container image
        with [Cosign](https://docs.sigstore.dev/cosign/overview/)
        by using a
        [OIDC keyless approach](https://docs.sigstore.dev/signing/quickstart/#keyless-signing-of-a-container).
        Defaults to `false`.
    - src (`package`):
        Derivation that contains the container image in OCI Format.

Example:

=== "makes.nix"

    ```nix
    { outputs, ... }: {
      deployContainer = {
        makesAmd64 = {
          credentials = {
            token = "GITHUB_TOKEN";
            user = "GITHUB_ACTOR";
          };
          image = "ghcr.io/fluidattacks/makes:amd64";
          src = outputs."/container-image";
          sign = true;
        };
        makesArm64 = {
          credentials = {
            token = "GITHUB_TOKEN";
            user = "GITHUB_ACTOR";
          };
          image = "ghcr.io/fluidattacks/makes:arm64";
          src = outputs."/container-image";
          sign = true;
        };
      };
    }
    ```

=== "Invocation DockerHub"

    ```bash
    DOCKER_HUB_USER=user DOCKER_HUB_PASS=123 m . /deployContainer/makesAmd64
    ```

=== "Invocation GitHub"

    ```bash
    GITHUB_ACTOR=user GITHUB_TOKEN=123 m . /deployContainer/makesAmd64
    ```

=== "Invocation GitLab"

    ```bash
    CI_REGISTRY_USER=user CI_REGISTRY_PASSWORD=123 m . /deployContainer/makesAmd64
    ```

## deployContainerManifest

Deploy a container manifest to a container registry
using [manifest-tool](https://github.com/estesp/manifest-tool).

Combine it with [deployContainer](#deploycontainer)
for supporting multi-tag or multi-arch images.

Types:

- deployContainerManifest (`attrsOf targetType`):
- targetType (`submodule`):
    - credentials:
        - token (`str`):
            Name of the environment variable
            that stores the value of the registry token.
        - user (`str`):
            Name of the environment variable
            that stores the value of the registry user.
    - image (`str`):
        Path for the manifest that will be deployed.
    - manifests (`listOf manifestType`):
        Already-existing images to be used by the new manifest.
        Typically used for supporting multiple architectures.
    - setup (`listOf package`): Optional.
        [Makes Environment][makes_environment]
        or [Makes Secrets][makes_secrets]
        to `source` (as in Bash's `source`)
        before anything else.
        Defaults to `[ ]`.
    - sign (`bool`): Optional.
        Sign container image
        with [Cosign](https://docs.sigstore.dev/cosign/overview/)
        by using a
        [OIDC keyless approach](https://docs.sigstore.dev/signing/quickstart/#keyless-signing-of-a-container).
        Defaults to `false`.
    - tags (`listOf str`): Optional.
        List of secondary tags (aliases) for the image.
        Defaults to `[ ]`.
- manifestType (`submodule`):
    - image: Path to the already-deployed image.
    - platform:
        - architecture (`str`):
            Architecture of the image.
        - os (`str`):
            Operating system of the image.

Example:

=== "makes.nix"

    ```nix
    { outputs, ... }: {
      deployContainerManifest = {
        makes = {
          credentials = {
            token = "GITHUB_TOKEN";
            user = "GITHUB_ACTOR";
          };
          image = "ghcr.io/fluidattacks/makes:latest";
          manifests = [
            {
              image = "ghcr.io/fluidattacks/makes:amd64";
              platform = {
                architecture = "amd64";
                os = "linux";
              };
            }
            {
              image = "ghcr.io/fluidattacks/makes:arm64";
              platform = {
                architecture = "arm64";
                os = "linux";
              };
            }
          ];
          sign = true;
          tags = [ "24.12" ];
        };
      };
    }
    ```

=== "Invocation DockerHub"

    ```bash
    DOCKER_HUB_USER=user DOCKER_HUB_PASS=123 m . /deployContainerManifest/makes
    ```

=== "Invocation GitHub"

    ```bash
    GITHUB_ACTOR=user GITHUB_TOKEN=123 m . /deployContainerManifest/makes
    ```

=== "Invocation GitLab"

    ```bash
    CI_REGISTRY_USER=user CI_REGISTRY_PASSWORD=123 m . /deployContainerManifest/makes
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

[makes_environment]: ./environment.md
[makes_secrets]: ./secrets.md
