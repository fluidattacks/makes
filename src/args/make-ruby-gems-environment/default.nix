{ makeRubyVersion
, makeRubyGemsInstall
, makeSearchPaths
, ...
}:
{ name
, ruby
, rubyGems
}:
let
  installation = makeRubyGemsInstall {
    inherit name;
    inherit ruby;
    inherit rubyGems;
  };
in
makeSearchPaths {
  bin = [ (makeRubyVersion ruby) ];
  rubyBin = [ installation ];
  rubyGemPath = [ installation ];
}
