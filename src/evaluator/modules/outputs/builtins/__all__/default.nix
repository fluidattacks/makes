{ toFileJson
, ...
}:
{ config
, ...
}:
{
  config = {
    outputs = {
      "__all__" =
        toFileJson "all.json"
          (builtins.removeAttrs config.outputs [ "__all__" ]);
    };
  };
}
