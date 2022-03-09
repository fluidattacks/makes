{
  __nixpkgs__,
  makeDerivation,
  ...
}: {
  name,
  python,
  target,
}: let
  bandit =
    {
      "3.7" = __nixpkgs__.python37Packages.bandit;
      "3.8" = __nixpkgs__.python38Packages.bandit;
      "3.9" = __nixpkgs__.python39Packages.bandit;
    }
    .${python};
in
  makeDerivation {
    builder = ./builder.sh;
    env = {
      envTarget = target;
    };
    name = "secure-python-with-bandit-for-${name}";
    searchPaths = {
      bin = [bandit];
    };
  }
