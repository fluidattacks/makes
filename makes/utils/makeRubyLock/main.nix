{
  __nixpkgs__,
  makeRubyVersion,
  makeScript,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "make-ruby-lock";
  replace = {
    __argParser__ = ./parser.rb;
    __argRuby31__ = makeRubyVersion "3.1";
    __argRuby32__ = makeRubyVersion "3.2";
    __argRuby33__ = makeRubyVersion "3.3";
  };
  searchPaths.bin = [
    __nixpkgs__.nixVersions.nix_2_15
    __nixpkgs__.yj
  ];
}
