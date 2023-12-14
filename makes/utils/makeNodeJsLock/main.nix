{
  __nixpkgs__,
  makeNodeJsVersion,
  makeScript,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "make-node-js-lock";
  replace = {
    __argNode18__ = makeNodeJsVersion "18";
    __argNode20__ = makeNodeJsVersion "20";
    __argNode21__ = makeNodeJsVersion "21";
  };
}
