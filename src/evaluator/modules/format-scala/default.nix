{ __nixpkgs__, toBashArray, makeDerivation, makeScript, isDarwin, fetchUrl, ...
}:
{ config, lib, ... }:
let
  chmodX = name: envSrc:
    makeDerivation {
      env = { inherit envSrc; };
      builder = "cp $envSrc $out && chmod +x $out";
      inherit name;
    };
  scalafmt_version = "3.0.8";
  binary_name = if isDarwin then "scalafmt-macos" else "scalafmt-linux-musl";
  binary_file = fetchUrl {
    url =
      "https://github.com/scalameta/scalafmt/releases/download/v${scalafmt_version}/${binary_name}";
    sha256 = "0nxpny86qdbgsmxc9qzsv8f5qb21y25iyr8h2wg61kgiaw8988g0";
  };
in {
  options = {
    formatScala = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      targets = lib.mkOption {
        default = [ "/" ];
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "/formatScala" = lib.mkIf config.formatScala.enable (makeScript {
        replace = {
          __argTargets__ = toBashArray
            (builtins.map (rel: "." + rel) config.formatJavaScript.targets);
          __argScalaFmtBinary__ = chmodX "scalafmt" binary_file;
        };
        name = "format-scala";
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
