{ __nixpkgs__
, makeDerivation
, makePythonPypiEnvironment
, makePythonVersion
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
        sourcesJson = ./sources.json;
      })
    ];
  };
  builder = ./builder.sh;
}
