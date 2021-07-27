{ __nixpkgs__
, ...
}:
node:
if node == "10"
then __nixpkgs__.nodejs-10_x
else if node == "12"
then __nixpkgs__.nodejs-12_x
else if node == "14"
then __nixpkgs__.nodejs-14_x
else if node == "16"
then __nixpkgs__.nodejs-16_x
else abort "Supported node versions are: 10, 12, 14 and 16"
