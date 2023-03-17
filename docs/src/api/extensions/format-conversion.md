## fromJson

Convert a JSON formatted string
to a Nix expression.

Types:

- fromJson (`function str -> anything`):
    - (`str`):
        JSON formatted string to convert.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      fromJson,
      makeDerivation,
      ...
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

=== "Invocation"

    ```bash
    $ m . /example

        [INFO] Name is: John
        [INFO] Last name is: Doe
        [INFO] Tickets is: 3
    ```

## fromToml

Convert a TOML formatted string
to a Nix expression.

Types:

- fromToml (`function str -> anything`):
    - (`str`):
        TOML formatted string to convert.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      fromToml,
      makeDerivation,
      ...
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

=== "Invocation"

    ```bash
    $ m . /example

        [INFO] Name is: John
        [INFO] Last name is: Doe
        [INFO] Tickets is: 3
    ```

## fromYaml

Convert a YAML formatted string
to a Nix expression.

Types:

- fromYaml (`function str -> anything`):
    - (`str`):
        YAML formatted string to convert.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      fromYaml,
      makeDerivation,
      ...
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

=== "Invocation"

    ```bash
    $ m . /example

        [INFO] Name is: John
        [INFO] Last name is: Doe
        [INFO] Tickets is: 3
    ```

## toBashArray

Transform a list of arguments
into a Bash array.
It can be used for passing
several arguments from Nix
to Bash.

Types:

- toBashArray (`function (listOf strLike) -> package`):
    - (`listOf strLike`):
        list of arguments
        to transform.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      toBashArray,
      makeDerivation,
      ...
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

=== "Invocation"

    ```bash
    $ m . /example

        [INFO] first
        [INFO] ---
        [INFO] second
        [INFO] ---
        [INFO] third
        [INFO] ----
    ```

## toBashMap

Transform a Nix `attrsOf strLike` expression
into a Bash associative array (map).
It can be used for passing
several arguments from Nix
to Bash.
You can combine with toBashArray for more complex structures.

Types:

- toBashMap (`function (attrsOf strLike) -> package`):
    - (`attrsOf strLike`):
        expression to transform.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      toBashMap,
      makeDerivation,
      ...
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

=== "Invocation"

    ```bash
    $ m . /example

      [INFO] key: tags
      [INFO] value: ci/cd, framework, nix
      [INFO] ---
      [INFO] key: name
      [INFO] value: Makes
      [INFO] ---
    ```

## toFileJson

Convert a Nix expression
into a JSON file.

Types:

- toFileJson (`function str anything -> package`):
    - (`str`):
        Name of the created file.
    - (`anything`):
        Nix expression to convert.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      toFileJson,
      makeDerivation,
      ...
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

=== "Invocation"

    ```bash
    $ m . /example

        {"name": "value"}
    ```

## toFileJsonFromFileYaml

Use [yq](https://github.com/mikefarah/yq)
to transform a YAML file
into its JSON
equivalent.

Types:

- toFileJsonFromFileYaml (`function package -> package`):
    - (`package`):
        YAML file to transform.

Example:

=== "test.yaml"

    ```yaml
    # /path/to/my/project/makes/example/test.yaml

    name: "John"
    lastName: "Doe"
    tickets: 3
    ```

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      makeDerivation,
      projectPath,
      toFileJsonFromFileYaml,
      ...
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

=== "Invocation"

    ```bash
    $ m . /example

    {
      "name": "John",
      "lastName": "Doe",
      "tickets": 3
    }
    ```

## toFileYaml

Convert a Nix expression
into a YAML file.

Types:

- toFileYaml (`function str anything -> package`):
    - (`str`):
        Name of the created file.
    - (`anything`):
        Nix expression to convert.

Example:

=== "main.nix"

    ```nix
    # /path/to/my/project/makes/example/main.nix
    {
      toFileYaml,
      makeDerivation,
      ...
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

=== "Invocation"

    ```bash
    $ m . /example

        name: value
    ```
