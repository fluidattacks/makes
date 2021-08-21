{ __nixpkgs__
, makeDerivation
, makePythonPypiEnvironment
, ...
}:
envTarget:
makeDerivation {
  env = {
    inherit envTarget;
    envScriptCvss = ./cvss.py;
  };
  name = "calculate-cvss-3";
  searchPaths = {
    source = [
      (makePythonPypiEnvironment {
        name = "cvss";
        sourcesYaml = ./sources.yaml;
      })
    ];
  };
  builder = ./builder.sh;
}
