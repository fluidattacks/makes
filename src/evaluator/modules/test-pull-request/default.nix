{ __nixpkgs__, __toModuleOutputs__, testPullRequest, ... }:
{ config, lib, ... }:
let
  makeOutput = name:
    { dangerfile, extraArgs, setup, }: {
      name = "/testPullRequest/${name}";
      value = testPullRequest {
        inherit dangerfile;
        inherit extraArgs;
        inherit name;
        inherit setup;
      };
    };
in {
  options = {
    testPullRequest = {
      modules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            dangerfile = lib.mkOption { type = lib.types.path; };
            extraArgs = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.str;
            };
            setup = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.package;
            };
          };
        }));
      };
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.testPullRequest.modules;
  };
}
