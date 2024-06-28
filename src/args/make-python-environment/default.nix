{ __nixpkgs__, makePythonPoetryEnvironment, makeSearchPaths, ... }:
{ pythonProjectDir, pythonVersion, preferWheels ? true
, overrides ? (self: super: { }), }:
let
  env = makePythonPoetryEnvironment {
    inherit pythonProjectDir;
    inherit pythonVersion;
    inherit preferWheels;
    inherit overrides;
  };
in makeSearchPaths {
  bin = [ env ];
  pythonPackage39 =
    __nixpkgs__.lib.lists.optional (env.pythonVersion == "3.9") env;
  pythonPackage310 =
    __nixpkgs__.lib.lists.optional (env.pythonVersion == "3.10") env;
  pythonPackage311 =
    __nixpkgs__.lib.lists.optional (env.pythonVersion == "3.11") env;
  pythonPackage312 =
    __nixpkgs__.lib.lists.optional (env.pythonVersion == "3.12") env;
}
