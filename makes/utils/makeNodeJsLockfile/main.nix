{ __nixpkgs__
, makeNodeJsVersion
, makeScript
, ...
}:
let
  nodeJs10 = makeNodeJsVersion "10";
  nodeJs12 = makeNodeJsVersion "12";
  nodeJs14 = makeNodeJsVersion "14";
  nodeJs16 = makeNodeJsVersion "16";
in
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "make-node-js-lockfile";
  replace = {
    __argNode10__ = nodeJs10;
    __argNode12__ = nodeJs12;
    __argNode14__ = nodeJs14;
    __argNode16__ = nodeJs16;
  };
  searchPaths.bin = [
    __nixpkgs__.git
    __nixpkgs__.nix
    nodeJs10
    nodeJs12
    nodeJs14
    nodeJs16
  ];
}
