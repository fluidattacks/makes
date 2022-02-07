{ __nixpkgs__
, ...
}:
version:
if version == "10"
then __nixpkgs__.nodejs-10_x
else if version == "12"
then __nixpkgs__.nodejs-12_x
else if version == "14"
then __nixpkgs__.nodejs-14_x
else if version == "16"
then __nixpkgs__.nodejs-16_x
else if version == "17"
then __nixpkgs__.nodejs-17_x
else abort "Supported node versions are: 10, 12, 14 and 16"
