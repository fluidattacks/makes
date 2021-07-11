{ __nixpkgs__
, builtinLambdas
, makeDerivation
, makeSearchPaths
, ...
}:
{ name
, node
, searchPaths ? { }
, dependencies
, subDependencies
}:
let
  # Unpack arguments and sort them
  dependenciesSorted = builtinLambdas.sort dependencies;
  subDependenciesSorted = builtinLambdas.sort subDependencies;

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
  requirementsList = builtinLambdas.sort (
    dependencies' ++
    subDependencies'
  );

  parsedRequirementsList = builtins.map (builtins.match "(.+)@(.+)") requirementsList;
  parsedRequirementsSet = builtins.listToAttrs (builtins.map (x: { name = builtins.head x; value = builtins.toString (builtins.tail x); }) parsedRequirementsList);
  packageJson = builtins.toJSON { "dependencies" = parsedRequirementsSet; };

  nodeInterpreter =
    if node == "10"
    then __nixpkgs__.nodejs-10_x
    else if node == "12"
    then __nixpkgs__.nodejs-12_x
    else if node == "14"
    then __nixpkgs__.nodejs-14_x
    else if node == "16"
    then __nixpkgs__.nodejs-16_x
    else abort "Supported node versions are: 10, 12, 14 and 16";

  nodeEnvironment = makeDerivation {
    arguments = {
      envRequirementsFile = builtinLambdas.listToFileWithTrailinNewLine requirementsList;
      envPackageJsonFile = builtins.toFile "package.json" packageJson;
    };
    builder = ./builder.sh;
    name = "make-node-environment-for-${name}";
    searchPaths = searchPaths // {
      bin = (builtinLambdas.getAttr searchPaths "bin" [ ]) ++ [
        __nixpkgs__.git
        __nixpkgs__.gnugrep
        __nixpkgs__.gnused
        __nixpkgs__.jq
        nodeInterpreter
      ];
    };
  };
in
makeSearchPaths {
  bin = [ nodeInterpreter ];
  nodeBin = [ nodeEnvironment ];
  nodeModule = [ nodeEnvironment ];
}
