{ __nixpkgs__, makeScript, ... }: {
  jobs."/utils/makeRubyLock" = makeScript {
    entrypoint = ./entrypoint.sh;
    name = "make-ruby-lock";
    replace = {
      __argParser__ = ./parser.rb;
      __argRuby31__ = __nixpkgs__.ruby_3_1;
      __argRuby32__ = __nixpkgs__.ruby_3_2;
      __argRuby33__ = __nixpkgs__.ruby_3_3;
    };
    searchPaths.bin = [ __nixpkgs__.nixVersions.nix_2_15 __nixpkgs__.yj ];
  };
}
