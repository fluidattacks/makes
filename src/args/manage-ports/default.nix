{ __nixpkgs__, makeTemplate, __shellCommands__, ... }:
makeTemplate {
  replace = { __argShellCommands__ = __shellCommands__; };
  name = "manage-ports";
  searchPaths = { bin = [ __nixpkgs__.lsof __nixpkgs__.netcat ]; };
  template = ./template.sh;
}
