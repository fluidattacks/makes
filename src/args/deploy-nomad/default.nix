{ makeScript
, makeNomadEnvironment
, ...
}:
{ setup
, name
, version
, src
, namespace
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argSrc__ = src;
    __argNamespace__ = namespace;
  };
  name = "deploy-nomad-for-${name}";
  searchPaths = {
    source = [
      (makeNomadEnvironment {
        inherit version;
      })
    ] ++ setup;
  };
}
