{ __nixpkgs__, makeDerivation, makePythonEnvironment, makeSearchPaths, ... }:
{ name, searchPaths, settingsMypy, settingsProspector, src, }:
makeDerivation {
  env = {
    envSettingsMypy = settingsMypy;
    envSettingsProspector = settingsProspector;
    envSrc = src;
  };
  name = "lint-python-module-for-${name}";
  searchPaths = {
    bin = [ __nixpkgs__.findutils ];
    source = [
      (makeSearchPaths searchPaths)
      (makePythonEnvironment {
        pythonProjectDir = ./.;
        pythonVersion = "3.11";
      })
    ];
  };
  builder = ./builder.sh;
}
