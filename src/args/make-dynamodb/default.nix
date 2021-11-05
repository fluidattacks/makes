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
, dbInfra ? ""
, ...
}:
makeScript {
  name = "dynamodb-for-${name}";
  replace = {
    __argPort__ = port;
    __argHost__ = host;
    __argDynamoZip__ = fetchUrl {
      url = "https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_2021-02-08.zip";
      sha256 = "01xgqk2crrnpvzr3xkd3mwiwcs6bfxqhbbyard6y8c0jgibm31pk";
    };
    __argDbData__ = toBashArray dbData;
    __argShouldPopulate__ = builtins.length dbData > 0;
    __argDbInfra__ = dbInfra;
  };
  searchPaths = {
    bin = [
      __nixpkgs__.openjdk_headless
      __nixpkgs__.unzip
      __nixpkgs__.awscli
    ];
    source = [
      (makeTerraformEnvironment {
        version = "1.0";
      })
      managePorts
    ];
  };
  entrypoint = ./entrypoint.sh;
}
