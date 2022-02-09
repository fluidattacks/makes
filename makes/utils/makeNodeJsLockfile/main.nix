{ __nixpkgs__
, makeNodeJsVersion
, makeScript
, ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "make-node-js-lockfile";
  replace = {
    __argNode10__ = makeNodeJsVersion "10";
    __argNode12__ = makeNodeJsVersion "12";
    __argNode14__ = makeNodeJsVersion "14";
    __argNode16__ = makeNodeJsVersion "16";
  };
}
