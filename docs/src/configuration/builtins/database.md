## dynamoDb

Create local dynamo databases

Types:

- dynamoDb (`attrsOf targetType`): Optional.
    Mapping of names to multiple databases.
    Defaults to `{ }`.
- targetType (`submodule`):
    - name (`str`),
    - host (`str`): Optional, defaults to `127.0.0.1`.
    - port (`str`): Optional, defaults to `8022`.
    - infra (`str`): Optional. Absolute path to the directory containing the
        terraform infrastructure.
    - daemonMode (`boolean`): Optional, defaults to `false`.
    - data (`listOf str`): Optional, defaults to []. Absolute paths with json documents,
        with the format defined for
        [BatchWriteItem](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html#API_BatchWriteItem_RequestSyntax).
    - dataDerivation (`listOf package`): Optional, defaults to `[]`.
        Derivations where the output ($ out), are json documents,
        with the format defined for
        [BatchWriteItem](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html#API_BatchWriteItem_RequestSyntax).
        This is useful if you want to perform transformations on your data.

Example:

=== "makes.nix"

    ```nix
    {
      projectPath,
      ...
    }: {
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

The following variables are available:

- HOST
- PORT
- DAEMON
- POPULATE
