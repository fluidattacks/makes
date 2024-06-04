{ __nixpkgs__, fetchRubyGem, fromYamlFile, makeDerivation, makeSearchPaths
, toBashArray, patchShebangs, ... }:
{ name, ruby, searchPaths ? { }, sourcesYaml, }:
let
  sources = fromYamlFile sourcesYaml;
  gems = builtins.map (rubyGem:
    let gem = fetchRubyGem rubyGem;
    in {
      inherit (gem) name;
      path = gem;
    }) sources.links;

  gemsSpec = __nixpkgs__.lib.attrsets.mapAttrsToList
    (name: version: "${name}:${version}") sources.closure;
in makeDerivation {
  builder = ./builder.sh;
  name = "make-ruby-gems-install-for-${name}";
  env = {
    envGems = __nixpkgs__.linkFarm "ruby-gems-for-${name}" gems;
    envGemsSpec = toBashArray gemsSpec;
  };
  searchPaths = {
    bin = [
      {
        "3.1" = __nixpkgs__.ruby_3_1;
        "3.2" = __nixpkgs__.ruby_3_2;
        "3.3" = __nixpkgs__.ruby_3_3;
      }.${ruby}
    ];
    source = [ patchShebangs (makeSearchPaths searchPaths) ];
  };
}
