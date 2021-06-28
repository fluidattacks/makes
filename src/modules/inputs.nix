{ packages }:
{ lib
, ...
}:
{
  options = {
    inputs = lib.mkOption {
      default = { };
      type = lib.types.attrs;
    };
  };
  config = {
    inputs = {
      makesPackages = packages;
    };
  };
}
