## helloWorld

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
