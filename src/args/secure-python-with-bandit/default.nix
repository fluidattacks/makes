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
      "3.8" = __nixpkgs__.python38Packages.bandit;
      "3.9" = __nixpkgs__.python39Packages.bandit;
      "3.10" = __nixpkgs__.python310Packages.bandit;
      "3.11" = __nixpkgs__.python311Packages.bandit;
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
