{ __nixpkgs__, makeRubyGemsInstall, makeSearchPaths, ... }:
{ name, ruby, searchPathsBuild ? { }, searchPathsRuntime ? { }, sourcesYaml, }:
let
  installation = makeRubyGemsInstall {
    inherit name;
    inherit ruby;
    searchPaths = searchPathsBuild;
    inherit sourcesYaml;
  };
in makeSearchPaths {
  bin = [
    {
      "3.1" = __nixpkgs__.ruby_3_1;
      "3.2" = __nixpkgs__.ruby_3_2;
      "3.3" = __nixpkgs__.ruby_3_3;
    }.${ruby}
  ];
  rubyBin = [ installation ];
  rubyGemPath = [ installation ];
  source = [ (makeSearchPaths searchPathsRuntime) ];
}
