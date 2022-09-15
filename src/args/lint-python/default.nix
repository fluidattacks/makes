{
  __nixpkgs__,
  isDarwin,
  listOptional,
  makeDerivation,
  makePythonPypiEnvironment,
  makeSearchPaths,
  ...
}: {
  mypyVersion ? "0.910",
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
          ./.
          + ({
              "3.7" = "/mypy-${mypyVersion}/pypi-sources-3.7.yaml";
              "3.8" = "/mypy-${mypyVersion}/pypi-sources-3.8.yaml";
              "3.9" = "/mypy-${mypyVersion}/pypi-sources-3.9.yaml";
              "3.10" = "/mypy-${mypyVersion}/pypi-sources-3.10.yaml";
            }
            .${python});
        withSetuptools_57_4_0 = true;
        withSetuptoolsScm_5_0_2 = true;
        withWheel_0_37_0 = true;
      })
    ];
  };
  builder = ./builder.sh;
}
