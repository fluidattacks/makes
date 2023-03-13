## extendingMakesDirs

Paths to magic directories where Makes extensions will be loaded from.

Types:

- extendingMakesDirs (`listOf str`): Optional.
  Defaults to `["/makes"]`.

## inputs

Explicitly declare the inputs and sources for your project.
Inputs can be anything.

Types:

- inputs (`attrOf anything`): Optional.
  Defaults to `{ }`.

Example:

=== "makes.nix"

    ```nix
    {
      fetchNixpkgs,
      fetchUrl,
      ...
    }: {
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
