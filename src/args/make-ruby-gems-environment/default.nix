{
  makeRubyVersion,
  makeRubyGemsInstall,
  makeSearchPaths,
  ...
}: {
  name,
  ruby,
  searchPathsBuild ? {},
  searchPathsRuntime ? {},
  sourcesYaml,
}: let
  installation = makeRubyGemsInstall {
    inherit name;
    inherit ruby;
    searchPaths = searchPathsBuild;
    inherit sourcesYaml;
  };
in
  makeSearchPaths {
    bin = [(makeRubyVersion ruby)];
    rubyBin = [installation];
    rubyGemPath = [installation];
    source = [(makeSearchPaths searchPathsRuntime)];
  }
