{ makeDerivation
, toBashArray
, ...
}:
makeDerivation {
  builder = ''
    set -x \
      && test "''${ARRAY[*]}" == "a b c" \
      && touch $out
  '';
  name = "test-make-search-paths";
  searchPaths.source = [
    [ (toBashArray [ "a" "b" "c" ]) "export" "ARRAY" ]
  ];
}
