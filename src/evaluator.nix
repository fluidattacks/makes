let
  packages = import ./nix/packages.nix;
in
{ head # Path to the user's project
, ...
}:
packages.nixpkgs.lib.modules.evalModules {
  modules = [
    (import ./modules {
      inherit head;
      inherit packages;
    })
    (head + "/makes.nix")
  ];
}
