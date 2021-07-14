{ toJSONFile
, ...
}:
{ config
, ...
}:
{
  config = {
    outputs = {
      "__all__" =
        toJSONFile "all.json"
          (builtins.removeAttrs config.outputs [ "__all__" ]);
    };
  };
}
