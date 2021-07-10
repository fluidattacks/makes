let
  packages = import ./nix/packages.nix;
in
{ head # Path to the user's project
, makesVersion # Makes version that is invoking the project
, ...
}:
let
  result = packages.nixpkgs.lib.modules.evalModules {
    modules = [
      (import ./modules {
        inherit head;
        inherit makesVersion;
        inherit packages;
      })
      (head + "/makes.nix")
    ];
    specialArgs = {
      outputs = result.config.outputs;
      requiredMakesVersion = result.config.requiredMakesVersion;
    };
  };
in
result
