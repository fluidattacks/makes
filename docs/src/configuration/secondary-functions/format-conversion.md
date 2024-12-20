## fromJson

Convert a JSON formatted string
to a Nix expression.

Types:

- fromJson (`function str -> anything`):
    - (`str`):
        JSON formatted string to convert.

Example:

=== "makes.nix"

    ```nix
    { fromJson, makeDerivation, ... }:
    let
      data = fromJson ''
        {
          "name": "John",
          "lastName": "Doe",
          "tickets": 3
        }
      '';
    in
    {
      jobs."myJsonData" = makeDerivation {
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
        name = "myJsonData";
      };
    }
    ```

## fromYaml

Convert a YAML formatted string
to a Nix expression.

Types:

- fromYaml (`function str -> anything`):
    - (`str`):
        YAML formatted string to convert.

Example:

=== "makes.nix"

    ```nix
    { fromYaml, makeDerivation, ... }:
    let
      data = fromYaml ''
        name: "John"
        lastName: "Doe"
        tickets: 3
      '';
    in
    {
      jobs."myYamlData" = makeDerivation {
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
        name = "myYamlData";
      };
    }
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

=== "makes.nix"

    ```nix
    { toBashArray, makeDerivation, ... }:
    {
      jobs."myBashArray" = makeDerivation {
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
        name = "myBashArray";
      };
    }
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

=== "makes.nix"

    ```nix
    { toBashMap, makeDerivation, ... }:
    {
      jobs."/myBashMap" = makeDerivation {
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
        name = "myBashMap";
      };
    }
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

=== "makes.nix"

    ```nix
    { toFileJson, makeDerivation, ... }:
    {
      jobs."myFileJson" = makeDerivation {
        env = {
          envFile = toFileJson "example.json" { name = "value"; };
        };
        builder = ''
          cat $envFile
        '';
        name = "myFileJson";
      };
    }
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

=== "makes.nix"

    ```nix
    { makeDerivation, projectPath, toFileJsonFromFileYaml, ... }:
    {
      jobs."myFileJsonFromFileYaml" = makeDerivation {
        env = {
          envJson =
            toFileJsonFromFileYaml
              (projectPath "/my-test.yaml");
        };
        builder = ''
          cat "$envJson"
        '';
        name = "myFileJsonFromFileYaml";
      };
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

=== "makes.nix"

    ```nix
    { toFileYaml, makeDerivation, ... }:
    {
      jobs."myFileYaml" = makeDerivation {
        env = {
          envFile = toFileYaml "example.yaml" { name = "value"; };
        };
        builder = ''
          cat $envFile
        '';
        name = "myFileYaml";
      };
    }
    ```
