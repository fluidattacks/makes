{ __nixpkgs__
, attrsMapToList
, fromYamlFile
, listOptional
, makeDerivation
, makePythonPypiEnvironment
, makePythonVersion
, makeSearchPaths
, toFileLst
, toFileYaml
, ...
}:
{ name
, searchPaths ? { }
, sourcesYaml
, withCython_0_29_24 ? false
, withNumpy_1_21_2 ? false
, withSetuptools_57_4_0 ? false
, withSetuptoolsScm_6_0_1 ? false
, withWheel_0_37_0 ? false
}:
let
  sources = fromYamlFile sourcesYaml;

  is36 = sources.python == "3.6";
  is37 = sources.python == "3.7";
  is38 = sources.python == "3.8";
  is39 = sources.python == "3.9";
  python = makePythonVersion sources.python;

  bootstraped = builtins.concatLists [
    (listOptional withCython_0_29_24 (makePythonPypiEnvironment {
      name = "cython-0.29.24";
      sourcesYaml = toFileYaml "sources.yaml" {
        closure.cython = "0.29.24";
        links = [{
          name = "Cython-0.29.24-py2.py3-none-any.whl";
          sha256 = "11c3fwfhaby3xpd24rdlwjdp1y1ahz9arai3754awp0b2bq12r7r";
          url = "https://files.pythonhosted.org/packages/ec/30/8707699ea6e1c1cbe79c37e91f5b06a6266de24f699a5e19b8c0a63c4b65/Cython-0.29.24-py2.py3-none-any.whl";
        }];
        python = sources.python;
      };
    }))
    (listOptional withNumpy_1_21_2 (makePythonPypiEnvironment {
      name = "numpy-1.21.2";
      sourcesYaml = {
        "3.6" = abort "Numpy requires python >= 3.7";
        "3.7" = ./sources/numpy-1.21.2/sources-37.yaml;
        "3.8" = ./sources/numpy-1.21.2/sources-38.yaml;
        "3.9" = ./sources/numpy-1.21.2/sources-39.yaml;
      }.${sources.python};
      withCython_0_29_24 = true;
    }))
    (listOptional withWheel_0_37_0 (makePythonPypiEnvironment {
      name = "wheel-0.37.0";
      sourcesYaml = toFileYaml "sources.yaml" {
        closure.wheel = "0.37.0";
        links = [{
          name = "wheel-0.37.0-py2.py3-none-any.whl";
          sha256 = "1za6c4s0yjy1dzprmib3kph40hr8xgj3apdsnqs00v9wv4mln091";
          url = "https://pypi.org/packages/py2.py3/w/wheel/wheel-0.37.0-py2.py3-none-any.whl";
        }];
        python = sources.python;
      };
    }))
    [ (makeSearchPaths searchPaths) ]
  ];

  pypiEnvironment = makeDerivation {
    builder = ./builder.sh;
    env = {
      envClosure =
        toFileLst "closure.lst"
          (attrsMapToList (req: version: "${req}==${version}") sources.closure);
      envDownloads = __nixpkgs__.linkFarm name (builtins.map
        ({ name, sha256, url }: {
          inherit name;
          path = __nixpkgs__.fetchurl {
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
          (listOptional true {
            name = "pip-21.2.4-py3-none-any.whl";
            sha256 = "fa9ebb85d3fd607617c0c44aca302b1b45d87f9c2a1649b46c26167ca4296323";
            url = "https://files.pythonhosted.org/packages/ca/31/b88ef447d595963c01060998cb329251648acf4a067721b0452c45527eb8/pip-21.2.4-py3-none-any.whl";
          })
        ]));
    };
    inherit name;
    searchPaths = {
      bin = [ __nixpkgs__.pypi-mirror python ];
      source = bootstraped;
    };
  };
in
makeSearchPaths {
  bin = [ pypiEnvironment ];
  pythonPackage36 = listOptional is36 pypiEnvironment;
  pythonPackage37 = listOptional is37 pypiEnvironment;
  pythonPackage38 = listOptional is38 pypiEnvironment;
  pythonPackage39 = listOptional is39 pypiEnvironment;
  source = bootstraped;
}
