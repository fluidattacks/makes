let
  packages = import ./nix/packages.nix;
in
{ head # Path to the user's project
, makesVersion # Makes version that is invoking the project
, ...
}:
packages.nixpkgs.lib.modules.evalModules {
  modules = [
    (import ./modules {
      inherit head;
      inherit makesVersion;
      inherit packages;
    })
    (head + "/makes.nix")
  ];
}
