{ makeScript
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    helloWorld = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      name = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "/helloWorld" = lib.mkIf config.helloWorld.enable (makeScript {
        name = "hello-world";
        entrypoint = ''
          info Hello from Makes! ${config.helloWorld.name}.
          info You called us with CLI arguments: [ "$@" ].
        '';
      });
    };
  };
}
