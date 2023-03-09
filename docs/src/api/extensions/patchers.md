## pathShebangs

Replace common [shebangs](https://bash.cyberciti.biz/guide/Shebang)
for their Nix equivalent.

For example:

- `#! /bin/env xxx` -> `/nix/store/..-name/bin/xxx`
- `#! /usr/bin/env xxx` -> `/nix/store/..-name/bin/xxx`
- `#! /path/to/my/xxx` -> `/nix/store/..-name/bin/xxx`

Types:

- pathShebangs (`package`):
  When sourced,
  it exports a Bash function called `patch_shebangs`
  into the evaluation context.
  This function receives one or more files or directories as arguments
  and replace shebangs of the executable files in-place.
  Note that only shebangs that resolve to executables in the `"${PATH}"`
  (a.k.a. `searchPaths.bin`) will be taken into account.

Examples:

```nix
# /path/to/my/project/makes/example/main.nix
{ __nixpkgs__
, makeDerivation
, patchShebangs
, ...
}:
makeDerivation {
  env = {
    envFile = builtins.toFile "my_file.sh" ''
      #! /usr/bin/env bash

      echo Hello!
    '';
  };
  builder = ''
    copy $envFile $out

    chmod +x $out
    patch_shebangs $out

    cat $out
  '';
  name = "example";
  searchPaths = {
    bin = [ __nixpkgs__.bash ]; # Propagate bash so `patch_shebangs` "sees" it
    source = [ patchShebangs ];
  };
}
```

```bash
$ m . /example

    #! /nix/store/dpjnjrqbgbm8a5wvi1hya01vd8wyvsq4-bash-4.4-p23/bin/bash

    echo Hello!
```
