{ makePythonEnvironment, ... }:
makePythonEnvironment {
  pythonProjectDir = ./.;
  pythonVersion = "3.12";
}
