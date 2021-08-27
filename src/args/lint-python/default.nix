{ __nixpkgs__
, makeDerivation
, makePythonPypiEnvironment
, ...
}:
{ extraSources
, name
, python
, settingsMypy
, settingsProspector
, src
}:
makeDerivation {
  env = {
    envSettingsMypy = settingsMypy;
    envSettingsProspector = settingsProspector;
    envSrc = src;
  };
  name = "lint-python-module-for-${name}";
  searchPaths = {
    bin = [ __nixpkgs__.findutils ];
    source = extraSources ++ [
      (makePythonPypiEnvironment {
        name = "lint-python";
        sourcesYaml = {
          "3.7" = ./pypi-sources-3.7.yaml;
          "3.8" = ./pypi-sources-3.8.yaml;
          "3.9" = ./pypi-sources-3.9.yaml;
        }.${python};
        withSetuptools_57_4_0 = true;
        withSetuptoolsScm_6_0_1 = true;
        withWheel_0_37_0 = true;
      })
    ];
  };
  builder = ./builder.sh;
}
