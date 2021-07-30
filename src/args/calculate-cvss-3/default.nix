{ __nixpkgs__
, makeDerivation
, makePythonEnvironment
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
        python = "3.8";
      })
    ];
  };
  builder = ./builder.sh;
}
