{ __nixpkgs__, makeSearchPaths, ... }:
{ pythonProjectDir, pythonVersion, preferWheels ? true
, overrides ? (self: super: { }), }:
let
  # Import poetry2nix
  poetry2nix = let
    commit = "528d500ea826383cc126a9be1e633fc92b19ce5d";
    sha256 = "sha256:1q245v4q0bb30ncfj66gl6dl1k46am28x7kjj6d3y7r6l4fzppq8";
    src = builtins.fetchTarball {
      inherit sha256;
      url =
        "https://api.github.com/repos/nix-community/poetry2nix/tarball/${commit}";
    };
  in import src { pkgs = __nixpkgs__; };

  # Decide Python version
  is39 = pythonVersion == "3.9";
  is310 = pythonVersion == "3.10";
  is311 = pythonVersion == "3.11";
  is312 = pythonVersion == "3.12";
  python = {
    "3.9" = __nixpkgs__.python39;
    "3.10" = __nixpkgs__.python310;
    "3.11" = __nixpkgs__.python311;
    "3.12" = __nixpkgs__.python312;
  }.${pythonVersion};

  # Override HOME directory for each package/derivation
  # and add any custom override on top of it
  overridenPackages = self: super:
    let
      overridePackageHome = pkg: super:
        super.${pkg}.overridePythonAttrs (old: {
          preUnpack = ''
            export HOME=$(mktemp -d)
            rm -rf /homeless-shelter
          '' + (old.preUnpack or "");
        });
      packages = let
        lock = "${pythonProjectDir}/poetry.lock";
        data = builtins.fromTOML (builtins.readFile lock);
        main = builtins.map (pkg: pkg.name) data.package;
        extras = let
          list = builtins.concatLists (builtins.map (pkg:
            if builtins.hasAttr "extras" pkg then
              builtins.concatLists (builtins.attrValues pkg.extras)
            else
              [ ]) data.package);
          names = builtins.map (extra:
            builtins.toString (builtins.head
              (builtins.split " " (__nixpkgs__.lib.toLower extra)))) list;
        in names;
      in main ++ extras;
      overridenHomes = builtins.listToAttrs (builtins.map (pkg: {
        name = pkg;
        value = overridePackageHome pkg super;
      }) packages);
    in overridenHomes // (overrides self super);
in poetry2nix.mkPoetryEnv {
  overrides = poetry2nix.defaultPoetryOverrides.extend overridenPackages;
  inherit preferWheels;
  projectDir = pythonProjectDir;
  inherit python;
}
