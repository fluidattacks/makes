{__nixpkgs__, ...}: version:
if version == "14"
then __nixpkgs__.nodejs-14_x
else if version == "16"
then __nixpkgs__.nodejs-16_x
else if version == "17"
then __nixpkgs__.nodejs-17_x
else if version == "18"
then __nixpkgs__.nodejs-18_x
else abort "Supported node versions are: 14, 16, 17 and 18"
