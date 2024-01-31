{
  __nixpkgs__,
  listOptional,
  makeSearchPaths,
  ...
}: {
  pythonProjectDir,
  pythonVersion,
  preferWheels ? true,
  overrides ? (self: super: {}),
}: let
  poetry2nix = let
    commit = "528d500ea826383cc126a9be1e633fc92b19ce5d";
    sha256 = "sha256:1q245v4q0bb30ncfj66gl6dl1k46am28x7kjj6d3y7r6l4fzppq8";
    src = builtins.fetchTarball {
      inherit sha256;
      url = "https://api.github.com/repos/nix-community/poetry2nix/tarball/${commit}";
    };
  in
    import src {pkgs = __nixpkgs__;};
  getPoetryPackages = let
    tomlPath = "${pythonProjectDir}/poetry.lock";
    tomlData = builtins.fromTOML (builtins.readFile tomlPath);
    tomlPackages = tomlData.package;
    packagesNames = builtins.map (pkg: pkg.name) tomlPackages;
    extraPackagesLst = builtins.concatLists (builtins.map (
        pkg:
          if builtins.hasAttr "extras" pkg
          then
            builtins.concatLists (
              builtins.attrValues pkg.extras
            )
          else []
      )
      tomlPackages);
    extraPackagesNames =
      builtins.map (
        extra:
          builtins.toString (builtins.head (builtins.split " " (__nixpkgs__.lib.toLower extra)))
      )
      extraPackagesLst;
  in
    packagesNames ++ extraPackagesNames;

  is39 = pythonVersion == "3.9";
  is310 = pythonVersion == "3.10";
  is311 = pythonVersion == "3.11";
  is312 = pythonVersion == "3.12";
  python =
    {
      "3.9" = __nixpkgs__.python39;
      "3.10" = __nixpkgs__.python310;
      "3.11" = __nixpkgs__.python311;
      "3.12" = __nixpkgs__.python312;
    }
    .${pythonVersion};

  overrideWithHome = pkg: super:
    super.${pkg}.overridePythonAttrs (
      old: {
        preUnpack =
          ''
            export HOME=$(mktemp -d)
            rm -rf /homeless-shelter
          ''
          + (old.preUnpack or "");
      }
    );
  tomlOverrides = self: super:
    builtins.listToAttrs (
      builtins.map (
        pkg: {
          name = pkg;
          value = overrideWithHome pkg super;
        }
      )
      getPoetryPackages
    );
  combinedOverrides = self: super: let
    toml = tomlOverrides self super;
    orig = overrides self super;
  in
    toml // orig;

  env = poetry2nix.mkPoetryEnv {
    overrides = poetry2nix.defaultPoetryOverrides.extend combinedOverrides;
    inherit preferWheels;
    projectDir = pythonProjectDir;
    inherit python;
  };
in
  makeSearchPaths {
    bin = [env];
    pythonPackage39 = listOptional is39 env;
    pythonPackage310 = listOptional is310 env;
    pythonPackage311 = listOptional is311 env;
    pythonPackage312 = listOptional is312 env;
  }
