{ makeScript
, __nixpkgs__
, managePorts
, fetchUrl
, ...
}:
{ name
, host ? "127.0.0.1"
, port ? "8022"
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
  };
  searchPaths = {
    bin = [
      __nixpkgs__.openjdk_headless
      __nixpkgs__.unzip
    ];
    source = [
      managePorts
    ];
  };
  entrypoint = ./entrypoint.sh;
}
