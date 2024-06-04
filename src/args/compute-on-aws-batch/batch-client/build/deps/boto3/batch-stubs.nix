{ lib, python_pkgs, }:
lib.buildPythonPackage rec {
  pname = "mypy-boto3-batch";
  version = "1.28.36";
  src = lib.fetchPypi {
    inherit pname version;
    sha256 = "SEDD3Fjd4y337atj+RVUKIvpUd0oCvje8gOF1/Rg7Gs=";
  };
  nativeBuildInputs = with python_pkgs; [ boto3 ];
  propagatedBuildInputs = with python_pkgs; [ botocore typing-extensions ];
}
