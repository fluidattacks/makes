{ __nixpkgs__
, attrsGet
, toFileLst
, makeDerivation
, sortAscii
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
  dependenciesSorted = sortAscii dependencies;
  subDependenciesSorted = sortAscii subDependencies;

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
  requirementsList = sortAscii (
    dependencies' ++
    subDependencies'
  );

  parsedRequirementsList = builtins.map (builtins.match "(.+)@(.+)") requirementsList;
  parsedRequirementsSet = builtins.listToAttrs (builtins.map (x: { name = builtins.head x; value = builtins.toString (builtins.tail x); }) parsedRequirementsList);
  packageJson = builtins.toJSON { "dependencies" = parsedRequirementsSet; };
in
makeDerivation {
  env = {
    envRequirementsFile = toFileLst "reqs.lst" requirementsList;
    envPackageJsonFile = builtins.toFile "package.json" packageJson;
  };
  builder = ./builder.sh;
  name = "make-node-modules-for-${name}";
  searchPaths = searchPaths // {
    bin = (attrsGet searchPaths "bin" [ ]) ++ [
      __nixpkgs__.git
      __nixpkgs__.gnugrep
      __nixpkgs__.gnused
      __nixpkgs__.jq
      node
    ];
  };
}
