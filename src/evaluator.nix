let
  packages = import ./nix/packages.nix;
in
{ head # Path to the user's project
, makesVersion # Makes version that is invoking the project
, ...
}:
let
  args = import ./args {
    __nixpkgs__ = packages.nixpkgs;
    inherit head;
    inputs = result.config.inputs;
    inherit makesVersion;
    outputs = result.config.outputs;
    requiredMakesVersion = result.config.requiredMakesVersion;
  };
  result = packages.nixpkgs.lib.modules.evalModules {
    modules = [
      (import ./modules args)
      (head + "/makes.nix")
    ];
    specialArgs = args;
  };
in
result
