# CLI

## Usage

The Makes command has the following syntax:

```bash
m <repo> <job>
```

where:

- `<repo>` is a GitHub, GitLab or local repository.
- `<job>` is a Makes job
    that exists within the referenced repository.
    If no job is specified,
    Makes displays all available jobs.

Example:

=== "GitHub"

    ```bash
    # Allows you to run jobs from repositories without cloning them!
    m github:fluidattacks/makes@main
    ```

=== "GitLab"

    ```bash
    # Allows you to run jobs from repositories without cloning them!
    m gitlab:fluidattacks/makes-example-2@main
    ```

=== "Local"

    ```bash
    # While standing in the root of your repo
    m .
    ```

Makes is powered by [Nix](https://nixos.org).
This means that it is able to run
on any of the
[Nix's supported platforms](https://nixos.org/manual/nix/unstable/installation/supported-platforms.html).

We have **thoroughly** tested it in
`linux/arm64` and `darwin/arm64` architectures.
