{
  __nixpkgs__,
  attrsMapToList,
  fromJsonFile,
  fromYamlFile,
  listOptional,
  makeDerivation,
  makePythonPypiEnvironment,
  makePythonVersion,
  makeSearchPaths,
  toFileLst,
  toFileYaml,
  ...
}: {
  name,
  searchPathsBuild ? {},
  searchPathsRuntime ? {},
  sourcesJson ? null,
  sourcesRaw ? null,
  sourcesYaml ? null,
  withCython_0_29_24 ? false,
  withNumpy_1_24_0 ? false,
  withSetuptools_67_7_2 ? false,
  withSetuptoolsScm_7_1_0 ? false,
  withWheel_0_40_0 ? false,
}:
assert builtins.any (_: _) [
  (sourcesJson == null && sourcesRaw != null && sourcesYaml == null)
  (sourcesJson != null && sourcesRaw == null && sourcesYaml == null)
  (sourcesJson == null && sourcesRaw == null && sourcesYaml != null)
]; let
  sources =
    if sourcesJson != null
    then fromJsonFile sourcesJson
    else if sourcesRaw != null
    then sourcesRaw
    else if sourcesYaml != null
    then fromYamlFile sourcesYaml
    else abort "sourcesJson, sourcesRaw or sourcesYaml must be set";

  is38 = sources.python == "3.8";
  is39 = sources.python == "3.9";
  is310 = sources.python == "3.10";
  is311 = sources.python == "3.11";
  python = makePythonVersion sources.python;

  bootstraped = builtins.concatLists [
    (listOptional withCython_0_29_24 (makePythonPypiEnvironment {
      name = "cython-0.29.24";
      sourcesYaml = toFileYaml "sources.yaml" {
        closure.cython = "0.29.24";
        links = [
          {
            name = "Cython-0.29.24-py2.py3-none-any.whl";
            sha256 = "11c3fwfhaby3xpd24rdlwjdp1y1ahz9arai3754awp0b2bq12r7r";
            url = "https://files.pythonhosted.org/packages/ec/30/8707699ea6e1c1cbe79c37e91f5b06a6266de24f699a5e19b8c0a63c4b65/Cython-0.29.24-py2.py3-none-any.whl";
          }
        ];
        inherit (sources) python;
      };
    }))
    (listOptional withNumpy_1_24_0 (makePythonPypiEnvironment {
      name = "numpy-1.24.0";
      sourcesYaml =
        {
          "3.8" = ./sources/numpy-1.24.0/sources-38.yaml;
          "3.9" = ./sources/numpy-1.24.0/sources-39.yaml;
          "3.10" = ./sources/numpy-1.24.0/sources-310.yaml;
          "3.11" = ./sources/numpy-1.24.0/sources-311.yaml;
        }
        .${sources.python};
      withCython_0_29_24 = true;
    }))
    (listOptional withWheel_0_40_0 (makePythonPypiEnvironment {
      name = "wheel-0.40.0";
      sourcesYaml = toFileYaml "sources.yaml" {
        closure.wheel = "0.40.0";
        links = [
          {
            name = "wheel-0.40.0-py3-none-any.whl";
            sha256 = "0izjbcsxh6nawadg540g34q5q758xralra0g77rdl8mmgh7b4dnj";
            url = "https://pypi.org/packages/py3/w/wheel/wheel-0.40.0-py3-none-any.whl";
          }
        ];
        inherit (sources) python;
      };
    }))
  ];

  pypiEnvironment = makeDerivation {
    builder = ./builder.sh;
    env = {
      envClosure =
        toFileLst "closure.lst"
        (attrsMapToList (req: version: "${req}==${version}") sources.closure);
      envDownloads = __nixpkgs__.linkFarm name (builtins.map
        ({
          name,
          sha256,
          url,
        }: {
          inherit name;
          path = __nixpkgs__.fetchurl {
            inherit name;
            inherit sha256;
            inherit url;
            curlOptsList = ["--retry" "3" "--fail"];
          };
        })
        (builtins.concatLists [
          sources.links
          (listOptional withCython_0_29_24 {
            name = "Cython-0.29.24-py2.py3-none-any.whl";
            sha256 = "11c3fwfhaby3xpd24rdlwjdp1y1ahz9arai3754awp0b2bq12r7r";
            url = "https://files.pythonhosted.org/packages/ec/30/8707699ea6e1c1cbe79c37e91f5b06a6266de24f699a5e19b8c0a63c4b65/Cython-0.29.24-py2.py3-none-any.whl";
          })
          (listOptional withSetuptools_67_7_2 {
            name = "setuptools-67.7.2-py3-none-any.whl";
            sha256 = "0awmhw9a3z21qqhrd0xgaqjpnlbp5pqh69yk06wcwlnahmmziai3";
            url = "https://pypi.org/packages/py3/s/setuptools/setuptools-67.7.2-py3-none-any.whl";
          })
          (listOptional withSetuptoolsScm_7_1_0 {
            name = "setuptools_scm-7.1.0-py3-none-any.whl";
            sha256 = "13ix4l2q4w34h1kpalyaryxr55d2dsc8r91a2jpy42c7hinqp63k";
            url = "https://files.pythonhosted.org/packages/py3/s/setuptools_scm/setuptools_scm-7.1.0-py3-none-any.whl";
          })
          (listOptional withWheel_0_40_0 {
            name = "wheel-0.40.0-py3-none-any.whl";
            sha256 = "0izjbcsxh6nawadg540g34q5q758xralra0g77rdl8mmgh7b4dnj";
            url = "https://pypi.org/packages/py3/w/wheel/wheel-0.40.0-py3-none-any.whl";
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
      bin = [__nixpkgs__.pypi-mirror python];
      source = builtins.concatLists [
        bootstraped
        [(makeSearchPaths searchPathsBuild)]
      ];
    };
  };
in
  makeSearchPaths {
    bin = [pypiEnvironment];
    pythonPackage38 = listOptional is38 pypiEnvironment;
    pythonPackage39 = listOptional is39 pypiEnvironment;
    pythonPackage310 = listOptional is310 pypiEnvironment;
    pythonPackage311 = listOptional is311 pypiEnvironment;
    source = builtins.concatLists [
      bootstraped
      [(makeSearchPaths searchPathsRuntime)]
    ];
  }
