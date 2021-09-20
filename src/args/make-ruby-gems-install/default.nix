{ __nixpkgs__
, fetchRubyGem
, makeDerivation
, makeRubyVersion
, toBashArray
, ...
}:
{ name
, ruby
, rubyGems
}:
let
  gems = builtins.map
    (rubyGem:
      let gem = fetchRubyGem rubyGem;
      in { name = gem.name; path = gem; }
    )
    (rubyGems);

  gemsSpec = builtins.map (gem: "${gem.name}:${gem.version}") rubyGems;
in
makeDerivation {
  builder = ./builder.sh;
  name = "make-ruby-gems-install-for-${name}";
  env = {
    envGems = __nixpkgs__.linkFarm "ruby-gems-for-${name}" gems;
    envGemsSpec = toBashArray gemsSpec;
  };
  searchPaths = {
    bin = [ (makeRubyVersion ruby) ];
  };
}
