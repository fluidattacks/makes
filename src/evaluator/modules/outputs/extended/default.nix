args:
{ lib
, ...
}:
let
  # Load an attr set distributed across many files and directories
  attrsFromPath = path: position:
    builtins.foldl'
      lib.mergeAttrs
      { }
      (lib.lists.flatten
        (lib.attrsets.mapAttrsToList
          (name: type:
            if type == "directory"
            then attrsFromPath "${path}/${name}" (position ++ [ name ])
            else if name == "main.nix"
            then {
              "/${builtins.concatStringsSep "/" position}" =
                (import "${path}/main.nix" args);
            }
            else { })
          (builtins.readDir path)));

  makes = args.path "/makes";
in
{
  config = {
    outputs = lib.mkIf
      (builtins.pathExists makes)
      (attrsFromPath makes [ ]);
  };
}
