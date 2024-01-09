{
  __nixpkgs__,
  makeDerivation,
  makePythonEnvironment,
  ...
}: envTarget:
makeDerivation {
  env = {
    inherit envTarget;
    envScriptCvss = ./cvss.py;
  };
  name = "calculate-cvss-3";
  searchPaths = {
    source = [
      (makePythonEnvironment {
        pythonProjectDir = ./.;
        pythonVersion = "3.11";
      })
    ];
  };
  builder = ./builder.sh;
}
