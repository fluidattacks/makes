src:
let
  _metadata =
    (builtins.fromTOML (builtins.readFile "${src}/pyproject.toml")).project;
  file_str = builtins.readFile "${src}/${_metadata.name}/__init__.py";
  match = builtins.match ''
    .*__version__ *= *"(.+)"
    .*'' file_str;
  version = builtins.elemAt match 0;
in _metadata // { inherit version; }
