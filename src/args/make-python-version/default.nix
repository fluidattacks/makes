{ __nixpkgs__
, ...
}:
version:
{
  "3.7" = __nixpkgs__.python37;
  "3.8" = __nixpkgs__.python38;
  "3.9" = __nixpkgs__.python39;
}.${version}
