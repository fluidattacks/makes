{
  __nixpkgs__,
  makeNodeJsVersion,
  makeScript,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "make-node-js-lockfile";
  replace = {
    __argNode14__ = makeNodeJsVersion "14";
    __argNode16__ = makeNodeJsVersion "16";
    __argNode17__ = makeNodeJsVersion "17";
    __argNode18__ = makeNodeJsVersion "18";
  };
}
