{ makeDerivation, ... }: {
  jobs."/tests/makeSearchPaths" = makeDerivation {
    builder = "touch $out";
    name = "test-make-search-paths";
    searchPaths.source = [[ ./template.sh "a" "b" "c" ]];
  };
}
