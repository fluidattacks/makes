{__nixpkgs__, ...}: version:
{
  "3.1" = __nixpkgs__.ruby_3_1;
  "3.2" = __nixpkgs__.ruby_3_2;
  "3.3" = __nixpkgs__.ruby_3_3;
}
.${version}
