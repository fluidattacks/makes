{ lib, ... }: {
  options = {
    inputs = lib.mkOption {
      default = { };
      type = lib.types.attrs;
    };
  };
}
