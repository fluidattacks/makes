{ makeScript
, makeTerraformEnvironment
, toBashArray
, ...
}:
{ setup
, name
, version
, resources
, src
, ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argResources__ = toBashArray resources;
    __argSrc__ = src;
  };
  name = "taint-terraform-for-${name}";
  searchPaths = {
    source = [
      (makeTerraformEnvironment {
        inherit version;
      })
    ] ++ setup;
  };
}
