{ buildPythonPackage, metadata, pkgDeps, src, }:
let
  type_check = ./check/types.sh;
  test_check = ./check/tests.sh;
in buildPythonPackage {
  inherit src type_check test_check;
  inherit (metadata) version;
  pname = metadata.name;
  format = "pyproject";
  checkPhase = [''
    source ${type_check} \
    && source ${test_check} \
  ''];
  doCheck = true;
  pythonImportsCheck = [ metadata.name ];
  nativeBuildInputs = pkgDeps.build_deps;
  propagatedBuildInputs = pkgDeps.runtime_deps;
  nativeCheckInputs = pkgDeps.test_deps;
}
