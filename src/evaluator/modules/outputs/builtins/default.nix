let src = ./.;
in
args:
{
  # Import all folders in this directory except ourselves
  imports = builtins.map
    (name:
      if name == "default.nix"
      then { }
      else import "${src}/${name}" args)
    (builtins.attrNames (builtins.readDir src));
}
