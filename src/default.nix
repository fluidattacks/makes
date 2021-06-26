{ head
, packages
, ...
}:

{ config
, lib
, ...
}:
let
  # Load an attr set distributed across many files and directories
  attrsFromPath =
    { args ? { }
    , path
    , position ? [ ]
    }:
    builtins.foldl'
      packages.nixpkgs.lib.attrsets.recursiveUpdate
      { }
      (packages.nixpkgs.lib.lists.flatten
        (packages.nixpkgs.lib.attrsets.mapAttrsToList
          (name: type:
          if type == "directory"
          then
            attrsFromPath
              {
                inherit args;
                path = "${path}/${name}";
                position = position ++ [ name ];
              }
          else if name == "main.nix"
          then
            packages.nixpkgs.lib.attrsets.setAttrByPath
              position
              (import "${path}/main.nix" args)
          else { })
          (builtins.readDir path)));
in
{
  options = {
    outputs = lib.mkOption {
      type = lib.types.anything;
    };
    inputs = lib.mkOption {
      default = { };
      type = lib.types.attrs;
    };
    src = lib.mkOption {
      default = "/makes";
      type = lib.types.str;
    };
  };
  config = {
    outputs = attrsFromPath {
      args = {
        path = path: head + path;
        inputs = config.inputs;
        outputs = config.outputs;
      };
      path = head + config.src;
    };
  };
}
