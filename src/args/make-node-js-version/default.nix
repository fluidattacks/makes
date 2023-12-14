{__nixpkgs__, ...}: version:
if version == "18"
then __nixpkgs__.nodejs_18
else if version == "20"
then __nixpkgs__.nodejs_20
else if version == "21"
then __nixpkgs__.nodejs_21
else abort "Supported node versions are: 18, 20 and 21"
