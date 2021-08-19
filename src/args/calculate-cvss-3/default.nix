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
        dependencies.cvss = "2.3";
        name = "cvss";
        python = makePythonVersion "3.8";
        sha256 = "0n5ix3pbp8s88xjjgp4d8j1had8fcgymvgfj597x6rmrynqfqkq6";
      })
    ];
  };
  builder = ./builder.sh;
}
