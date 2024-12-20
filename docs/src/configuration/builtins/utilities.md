Utilities provide an easy mechanism
for calling functions from makes
without having to specify them on any file.

## makePythonLock

You can generate a `poetry.lock` for
[makePythonEnvironment](/api/extensions/python/#makepythonenvironment)
like this:

```bash
m github:fluidattacks/makes@24.12 /utils/makePythonLock \
  "${python_version}" \
  "${project}"
```

- Supported `python_version`s are `3.9`, `3.10`, `3.11` and `3.12`
- `project` is the **absolute path** to a Python project
    containing a `pyproject.toml` file.
    Example:

    ```toml
    [tool.poetry]
    name = "test"
    version = "0.1.0"
    description = ""
    authors = ["Your Name <you@example.com>"]
    readme = "README.md"

    [tool.poetry.dependencies]
    python = "^3.11"
    Django = "3.2.0"
    psycopg2 = "2.9.1"


    [build-system]
    requires = ["poetry-core"]
    build-backend = "poetry.core.masonry.api"
    ```

## makeRubyLock

You can generate a `sourcesYaml` for
[makeRubyGemsEnvironment](/api/extensions/ruby/#makerubygemsenvironment)
like this:

```bash
m github:fluidattacks/makes@24.12 /utils/makeRubyLock \
  "${ruby_version}" \
  "${dependencies_yaml}" \
  "${sources_yaml}"
```

- Supported `ruby_version`s are: `3.1`, `3.2` and `3.3`.
- `dependencies_yaml` is the **absolute path** to a YAML file
    mapping [RubyGems](https://rubygems.org/) gems to version constraints.
    Example:

    ```yaml
    rubocop: "1.43.0"
    slim: "~> 4.1"
    ```

- `sources_yaml` is the **absolute path**
    to a file were the script will output results.
