{ __nixpkgs__
, attrsMapToList
, fromJsonFile
, getAttr
, listOptional
, makeDerivation
, makePythonVersion
, makeSearchPaths
, toFileLst
, ...
}:
{ name
, searchPaths ? { }
, sourcesJson
, withSetuptools_57_4_0 ? false
, withSetuptoolsScm_6_0_1 ? false
, withWheel_0_37_0 ? false
}:
let
  sources = fromJsonFile sourcesJson;

  is37 = sources.python == "3.7";
  is38 = sources.python == "3.8";
  is39 = sources.python == "3.9";
  python = makePythonVersion sources.python;

  pypiEnvironment = makeDerivation {
    builder = ./builder.sh;
    env = {
      envClosure =
        toFileLst "closure.lst"
          (attrsMapToList (req: version: "${req}==${version}") sources.closure);
      envDownloads = __nixpkgs__.linkFarm name (builtins.map
        ({ name, sha256, url }: {
          inherit name;
          path = builtins.fetchurl {
            inherit name;
            inherit sha256;
            inherit url;
          };
        })
        (builtins.concatLists [
          (sources.links)
          (listOptional withSetuptools_57_4_0 {
            name = "setuptools-57.4.0-py3-none-any.whl";
            sha256 = "1mhq6jw21sglccqmimydqi2rjvh3g5xjykb16gcvkkx6gabk14m4";
            url = "https://pypi.org/packages/py3/s/setuptools/setuptools-57.4.0-py3-none-any.whl";
          })
          (listOptional withSetuptoolsScm_6_0_1 {
            name = "setuptools_scm-6.0.1-py3-none-any.whl";
            sha256 = "0p4i5nypfdqzjlmlkwvy45107y7kpq3x9s5zq2jl9vwd3iq5zgf3";
            url = "https://files.pythonhosted.org/packages/py3/s/setuptools_scm/setuptools_scm-6.0.1-py3-none-any.whl";
          })
          (listOptional withWheel_0_37_0 {
            name = "wheel-0.37.0-py2.py3-none-any.whl";
            sha256 = "1za6c4s0yjy1dzprmib3kph40hr8xgj3apdsnqs00v9wv4mln091";
            url = "https://pypi.org/packages/py2.py3/w/wheel/wheel-0.37.0-py2.py3-none-any.whl";
          })
        ]));
    };
    inherit name;
    searchPaths = searchPaths // {
      bin = (getAttr searchPaths "bin" [ ]) ++ [
        __nixpkgs__.pypi-mirror
        python
      ];
    };
  };
in
makeSearchPaths {
  bin = [ pypiEnvironment ];
  pythonPackage37 = listOptional is37 pypiEnvironment;
  pythonPackage38 = listOptional is38 pypiEnvironment;
  pythonPackage39 = listOptional is39 pypiEnvironment;
}
