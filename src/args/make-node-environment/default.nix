{ builtinLambdas
, inputs
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
    then inputs.makesPackages.nixpkgs.nodejs-10_x
    else if node == "11"
    then inputs.makesPackages.nixpkgs.nodejs-11_x
    else if node == "12"
    then inputs.makesPackages.nixpkgs.nodejs-12_x
    else if node == "13"
    then inputs.makesPackages.nixpkgs.nodejs-13_x
    else if node == "14"
    then inputs.makesPackages.nixpkgs.nodejs-14_x
    else if node == "15"
    then inputs.makesPackages.nixpkgs.nodejs-15_x
    else abort "Supported node versions are: 10, 11, 12, 13, 14 and 15";

  nodeEnvironment = makeDerivation {
    arguments = {
      envRequirementsFile = builtinLambdas.listToFileWithTrailinNewLine requirementsList;
      envPackageJsonFile = builtins.toFile "package.json" packageJson;
    };
    builder = ./builder.sh;
    name = "make-node-environment-for-${name}";
    searchPaths = searchPaths // {
      envPaths = (builtinLambdas.getAttr searchPaths "envPaths" [ ]) ++ [
        inputs.makesPackages.nixpkgs.git
        inputs.makesPackages.nixpkgs.gnugrep
        inputs.makesPackages.nixpkgs.gnused
        inputs.makesPackages.nixpkgs.jq
        nodeInterpreter
      ];
    };
  };
in
makeSearchPaths {
  envPaths = [ nodeInterpreter ];
  envNodeBinaries = [ nodeEnvironment ];
  envNodeLibraries = [ nodeEnvironment ];
}
