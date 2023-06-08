{
  __nixpkgs__,
  toBashArray,
  makeScript,
  ...
}: {
  config,
  targets,
  name,
}:
makeScript {
  name = "format-python-for-${name}";
  replace = {
    __argSettingsBlack__ = config.black;
    __argSettingsIsort__ = config.isort;
    __argTargets__ = toBashArray (builtins.map (rel: "." + rel) targets);
  };
  entrypoint = ./entrypoint.sh;
  searchPaths = {
    bin = [
      __nixpkgs__.black
      __nixpkgs__.git
      __nixpkgs__.python311Packages.isort
    ];
    pythonPackage311 = [
      __nixpkgs__.python311Packages.colorama
    ];
  };
}
