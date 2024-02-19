{
  makeDerivation,
  makePythonEnvironment,
  makeSearchPaths,
  ...
}: {
  config,
  name,
  searchPaths,
  src,
}:
makeDerivation {
  builder = ./builder.sh;
  env = {
    envConfig = config;
    envSrc = src;
  };
  name = "lint-python-imports-for-${name}";
  searchPaths.source = [
    (makeSearchPaths searchPaths)
    (makePythonEnvironment {
      pythonProjectDir = ./.;
      pythonVersion = "3.11";
      overrides = self: super: {
        grimp = super.grimp.overridePythonAttrs (
          old: {
            preUnpack =
              ''
                export HOME=$(mktemp -d)
                rm -rf /homeless-shelter
              ''
              + (old.preUnpack or "");
            buildInputs = [super.setuptools];
          }
        );
        import-linter = super.import-linter.overridePythonAttrs (
          old: {buildInputs = [super.setuptools];}
        );
      };
    })
  ];
}
