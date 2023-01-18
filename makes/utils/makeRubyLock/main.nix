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
    __argRuby27__ = makeRubyVersion "2.7";
    __argRuby30__ = makeRubyVersion "3.0";
    __argRuby31__ = makeRubyVersion "3.1";
  };
  searchPaths.bin = [
    __nixpkgs__.nix
    __nixpkgs__.yj
  ];
}
