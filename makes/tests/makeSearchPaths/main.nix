{makeDerivation, ...}:
makeDerivation {
  builder = "touch $out";
  name = "test-make-search-paths";
  searchPaths.source = [
    [./template.sh "a" "b" "c"]
  ];
}
