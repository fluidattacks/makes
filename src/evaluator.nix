{
  # Path to the user's project, inside a sandbox.
  # The sandbox excludes files not-tracked by git.
  head
  # Path to the user's project, outside the sandbox.
  # Only available when running local Makes projects.
, headImpure ? head
  # Makes version that is invoking the project
, makesVersion
, ...
}:
let
  args = import ./args {
    __nixpkgs__ = packages.nixpkgs;
    inherit head;
    inherit headImpure;
    inputs = result.config.inputs;
    inherit makesVersion;
    outputs = result.config.outputs;
  };
  packages = import ./nix/packages.nix;
  result = packages.nixpkgs.lib.modules.evalModules {
    modules = [
      (import ./modules args)
      (args.path "/makes.nix")
    ];
    specialArgs = args;
  };
in
result
