{ __nixpkgs__, makeTemplate, ... }:
{ name, env, bins, }:
makeTemplate {
  inherit name;
  searchPaths = { bin = bins ++ [ env ]; };
  replace = {
    __argPython__ = __nixpkgs__.python310;
    __argPythonEnv__ = env;
    __argPythonEntry__ = ./vs_settings.py;
  };
  template = ./template.sh;
}
