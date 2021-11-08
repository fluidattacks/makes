{ makeScript
, __nixpkgs__
, managePorts
, fetchUrl
, toBashArray
, makeTerraformEnvironment
, ...
}:
{ name
, host ? "127.0.0.1"
, port ? "8022"
, dbData ? [ ]
, dbDataDerivation ? [ ]
, dbInfra ? ""
, daemonMode ? false
, ...
}:
let
  data = dbData ++ dbDataDerivation;
  hasInfra = (__nixpkgs__.lib.strings.stringLength dbInfra) > 0;
in
makeScript {
  name = "dynamodb-for-${name}";
  replace = {
    __argPort__ = port;
    __argHost__ = host;
    __argDynamoZip__ = fetchUrl {
      url = "https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_2021-02-08.zip";
      sha256 = "01xgqk2crrnpvzr3xkd3mwiwcs6bfxqhbbyard6y8c0jgibm31pk";
    };
    __argDbData__ = toBashArray data;
    __argShouldPopulate__ = builtins.length data > 0;
    __argDbInfra__ = dbInfra;
    __argDaemonMode__ = daemonMode;
  };
  searchPaths = {
    bin = [
      __nixpkgs__.openjdk_headless
      __nixpkgs__.unzip
      __nixpkgs__.awscli
    ] ++ (if hasInfra then [
      __nixpkgs__.awscli
    ] else [ ]);
    source = [
      managePorts
    ] ++ (if hasInfra then
      [
        (makeTerraformEnvironment {
          version = "1.0";
        })
      ] else [ ]);
  };
  entrypoint = ./entrypoint.sh;
}
