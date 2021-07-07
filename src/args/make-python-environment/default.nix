{ builtinLambdas
, inputs
, makeDerivation
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
in
makeDerivation {
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
      python
    ];
  };
}
