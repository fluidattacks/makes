Utilities provide an easy mechanism
for calling functions from makes
without having to specify them on any file.

## makeNodeJsLock

You can generate a `package-lock.json` for
[makeNodeJsEnvironment](/api/extensions/node.js/#makenodejsenvironment)
like this:

```bash
m github:fluidattacks/makes@23.07 /utils/makeNodeJsLock \
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

## makePythonLock

You can generate a `sourcesYaml` for
[makePythonPypiEnvironment](/api/extensions/python/#makepythonpypienvironment)
like this:

```bash
m github:fluidattacks/makes@23.07 /utils/makePythonLock \
  "${python_version}" \
  "${dependencies_yaml}" \
  "${sources_yaml}"
```

- Supported `python_version`s are: `3.8`, `3.9`, `3.10` and `3.11`.
- `dependencies_yaml` is the **absolute path** to a YAML file
    mapping [PyPI](https://pypi.org/) packages to version constraints.
    Example:

    ```yaml
    Django: "3.2.*"
    psycopg2: "2.9.1"
    ```

- `sources_yaml` is the **absolute path**
    to a file were the script will output results.

## makeRubyLock

You can generate a `sourcesYaml` for
[makeRubyGemsEnvironment](/api/extensions/ruby/#makerubygemsenvironment)
like this:

```bash
m github:fluidattacks/makes@23.07 /utils/makeRubyLock \
  "${ruby_version}" \
  "${dependencies_yaml}" \
  "${sources_yaml}"
```

- Supported `ruby_version`s are: `2.7`, `3.0` and `3.1`.
- `dependencies_yaml` is the **absolute path** to a YAML file
    mapping [RubyGems](https://rubygems.org/) gems to version constraints.
    Example:

    ```yaml
    rubocop: "1.43.0"
    slim: "~> 4.1"
    ```

- `sources_yaml` is the **absolute path**
    to a file were the script will output results.

## makeSopsEncryptedFile

You can generate an encrypted [Sops](https://github.com/mozilla/sops) file like this:

```bash
m github:fluidattacks/makes@23.07 /utils/makeSopsEncryptedFile \
  "${kms_key_arn}" \
  "${output}"
```

- `kms_key_arn` is the arn of the key you will use for encrypting the file.
- `output` is the path for your resulting encrypted file.

## workspaceForTerraformFromEnv

Sets a [Terraform Workspace](https://developer.hashicorp.com/terraform/language/state/workspaces)
specified via environment variable.

Types:

- workspaceForTerraformFromEnv:
    - modules (`attrsOf moduleType`): Optional.
        Terraform modules to switch workspace.
        Defaults to `{ }`.
- moduleType (`submodule`):
    - setup (`listOf package`): Optional.
        [Makes Environment](./environment.md)
        or [Makes Secrets](./secrets.md)
        to `source` (as in Bash's `source`)
        before anything else.
        Defaults to `[ ]`.
    - src (`str`):
        Path to the Terraform module.
    - variable (`str`): Optional.
        Name of the environment variable that contains
        the name of the workspace you want to use.
        Defaults to `""`.
        When `""` provided, workspace is `default`.
    - version (`enum [ "0.14" "0.15" "1.0" ]`):
        Terraform version your module is built with.

Example:

=== "makes.nix"

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
