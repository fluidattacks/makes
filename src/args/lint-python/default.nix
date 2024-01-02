{
  __nixpkgs__,
  isDarwin,
  listOptional,
  makeDerivation,
  makePythonPypiEnvironment,
  makeSearchPaths,
  ...
}: {
  name,
  python,
  searchPaths,
  settingsMypy,
  settingsProspector,
  src,
}:
makeDerivation {
  env = {
    envSettingsMypy = settingsMypy;
    envSettingsProspector = settingsProspector;
    envSrc = src;
  };
  name = "lint-python-module-for-${name}";
  searchPaths = {
    bin = [__nixpkgs__.findutils];
    source = [
      (makeSearchPaths searchPaths)
      (makePythonPypiEnvironment {
        name = "lint-python";
        searchPathsBuild = {
          bin = listOptional isDarwin __nixpkgs__.clang;
        };
        sourcesYaml =
          {
            "3.9" = ./pypi-sources-3.9.yaml;
            "3.10" = ./pypi-sources-3.10.yaml;
            "3.11" = ./pypi-sources-3.11.yaml;
            "3.12" = ./pypi-sources-3.12.yaml;
          }
          .${python};
        withSetuptools_67_7_2 = true;
        withSetuptoolsScm_7_1_0 = true;
        withWheel_0_40_0 = true;
      })
    ];
  };
  builder = ./builder.sh;
}
