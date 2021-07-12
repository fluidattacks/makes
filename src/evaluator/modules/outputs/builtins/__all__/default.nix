{ makeDerivation
, ...
}:
{ config
, ...
}:
{
  config = {
    outputs = {
      "__all__" = makeDerivation {
        env = {
          envAll = builtins.toJSON
            (builtins.removeAttrs config.outputs [ "__all__" ]);
        };
        builder = ''
          echo "$envAll" > "$out"
        '';
        name = "all";
      };
    };
  };
}
