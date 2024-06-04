{ __nixpkgs__, makeScript, ... }:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "make-node-js-lock";
  replace = {
    __argNode18__ = __nixpkgs__.nodejs_18;
    __argNode20__ = __nixpkgs__.nodejs_20;
    __argNode21__ = __nixpkgs__.nodejs_21;
  };
}
