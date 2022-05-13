{__nixpkgs__, ...}: version:
if version == "10"
then __nixpkgs__.nodejs-10_x
else if version == "14"
then __nixpkgs__.nodejs-14_x
else if version == "16"
then __nixpkgs__.nodejs-16_x
else abort "Supported node versions are: 10, 14 and 16"
