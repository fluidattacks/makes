{ __nixpkgs__
, getAttr
, toFileLst
, makeDerivation
, makeSearchPaths
, sortAsciiCaseless
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
  dependenciesSorted = sortAsciiCaseless dependencies;
  subDependenciesSorted = sortAsciiCaseless subDependencies;

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
  requirementsList = sortAsciiCaseless (
    dependencies' ++
    subDependencies'
  );

  pythonEnvironment = makeDerivation {
    env = {
      envRequirementsFile = toFileLst "reqs.lst" requirementsList;
    };
    builder = ./builder.sh;
    name = "make-python-environment-for-${name}";
    searchPaths = searchPaths // {
      bin = (getAttr searchPaths "bin" [ ]) ++ [
        __nixpkgs__.gcc
        __nixpkgs__.git
        __nixpkgs__.gnused
        python
      ];
    };
  };
in
makeSearchPaths {
  bin = [ pythonEnvironment ];
  pythonPackage37 = if (python == "3.7") then [ pythonEnvironment ] else [ ];
  pythonPackage38 = if (python == "3.8") then [ pythonEnvironment ] else [ ];
  pythonPackage39 = if (python == "3.9") then [ pythonEnvironment ] else [ ];
}
