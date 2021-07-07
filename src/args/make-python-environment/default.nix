{ builtinLambdas
, inputs
, makeDerivation
, makeSearchPaths
, ...
}:
{ name
, python
, searchPaths ? { }
, dependencies
, subDependencies ? [ ]
}:
let
  # Unpack arguments and sort them
  dependenciesSorted = builtinLambdas.sortCaseless dependencies;
  subDependenciesSorted = builtinLambdas.sortCaseless subDependencies;

  # Ensure the developer wrote them sorted
  # This helps with code clarity and maintainability
  dependencies' =
    if (dependenciesSorted == dependencies)
    then dependenciesSorted
    else abort "Dependencies must be sorted in this order: ${builtins.toJSON dependenciesSorted}";
  subDependencies' =
    if (subDependenciesSorted == subDependencies)
    then subDependenciesSorted
    else abort "Sub-dependencies must be sorted in this order: ${builtins.toJSON subDependenciesSorted}";
  requirementsList = builtinLambdas.sortCaseless (
    dependencies' ++
    subDependencies'
  );

  pythonInterpreter =
    if python == "3.7"
    then inputs.makesPackages.nixpkgs.python37
    else if python == "3.8"
    then inputs.makesPackages.nixpkgs.python38
    else if python == "3.9"
    then inputs.makesPackages.nixpkgs.python39
    else abort "Supported python versions are: 3.7 and 3.8";

  pythonEnvironment = makeDerivation {
    arguments = {
      envRequirementsFile = builtinLambdas.listToFileWithTrailinNewLine requirementsList;
    };
    builder = ./builder.sh;
    name = "make-python-environment-for-${name}";
    searchPaths = searchPaths // {
      envPaths = (builtinLambdas.getAttr searchPaths "envPaths" [ ]) ++ [
        inputs.makesPackages.nixpkgs.gcc
        inputs.makesPackages.nixpkgs.git
        inputs.makesPackages.nixpkgs.gnused
        pythonInterpreter
      ];
    };
  };
in
makeSearchPaths {
  envPaths = [ pythonEnvironment ];
  envPython37Paths = if (python == "3.7") then [ pythonEnvironment ] else [ ];
  envPython38Paths = if (python == "3.8") then [ pythonEnvironment ] else [ ];
  envPython39Paths = if (python == "3.9") then [ pythonEnvironment ] else [ ];
}
