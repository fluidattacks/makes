{
  __nixpkgs__,
  makeTemplate,
  ...
}:
makeTemplate {
  name = "manage-ports";
  searchPaths = {
    bin = [
      __nixpkgs__.lsof
      __nixpkgs__.netcat
    ];
  };
  template = ./template.sh;
}
