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
            "3.8" = ./pypi-sources-3.8.yaml;
            "3.9" = ./pypi-sources-3.9.yaml;
            "3.10" = ./pypi-sources-3.10.yaml;
            "3.11" = ./pypi-sources-3.11.yaml;
          }
          .${python};
        withSetuptools_57_4_0 = true;
        withSetuptoolsScm_5_0_2 = true;
        withWheel_0_37_0 = true;
      })
    ];
  };
  builder = ./builder.sh;
}
