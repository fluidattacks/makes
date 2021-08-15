{ __nixpkgs__
, makeDerivation
, makePythonEnvironment
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
      (makePythonEnvironment {
        dependencies = [
          "cvss==2.3"
        ];
        name = "cvss";
        python = makePythonVersion "3.8";
      })
    ];
  };
  builder = ./builder.sh;
}
