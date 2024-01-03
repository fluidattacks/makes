{__nixpkgs__, ...}: version:
{
  "3.9" = __nixpkgs__.python39;
  "3.10" = __nixpkgs__.python310;
  "3.11" = __nixpkgs__.python311;
  "3.12" = __nixpkgs__.python312;
}
.${version}
