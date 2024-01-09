{
  __nixpkgs__,
  listOptional,
  makePythonVersion,
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

  is39 = pythonVersion == "3.9";
  is310 = pythonVersion == "3.10";
  is311 = pythonVersion == "3.11";
  is312 = pythonVersion == "3.12";
  python = makePythonVersion pythonVersion;

  env = poetry2nix.mkPoetryEnv {
    overrides = poetry2nix.defaultPoetryOverrides.extend overrides;
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
