{ __nixpkgs__
, head
, headImpure
, inputs
, makesVersion
, outputs
}:
let
  derivations = {
    builtinShellCommands = ./builtin/shell-commands.sh;
    builtinShellOptions = ./builtin/shell-options.sh;
    deployContainerImage = import ./deploy-container-image args;
    fetchNixpkgs = import ./fetchers/nixpkgs.nix args;
    fetchUrl = import ./fetchers/url.nix args;
    fetchZip = import ./fetchers/zip.nix args;
    makeContainerImage = import ./make-container-image args;
    makeDerivation = import ./make-derivation args;
    makeNodeEnvironment = import ./make-node-environment args;
    makeParallel = import ./make-parallel args;
    makePythonEnvironment = import ./make-python-environment args;
    makeScript = import ./make-script args;
    makeSearchPaths = import ./make-search-paths args;
    makeTemplate = import ./make-template args;
  };
  functions = {
    # Return a bash array from a nix list
    asBashArray = args: "( ${__nixpkgs__.lib.strings.escapeShellArgs args} )";

    # Ensure the expression contents are read, paths are loaded, strings are left intact
    asContent = expr:
      if builtins.isPath expr
      then builtins.readFile expr
      else if builtins.isString expr
      then expr
      else abort "Expected a store path or a string, got: ${builtins.typeOf expr}";

    # Return name from the attribute set, or default
    getAttr = attrset: name: default:
      if builtins.hasAttr name attrset
      then builtins.getAttr name attrset
      else default;

    # Return true if string is a nix store path
    isStorePath = string:
      "/nix/store" == __nixpkgs__.lib.strings.substring 0 10 string;

    # Write each item on the list to a line in the file, return the file
    listToFileWithTrailinNewLine = list: builtins.toFile "list" (
      builtins.concatStringsSep "\n" (list ++ [ "" ])
    );

    # Return a path stored in the nix store
    path = path: head + path;

    # Return an impure path store in the nix store
    pathImpure = path: headImpure + path;

    # Sort a list based on ascii code point
    sort = builtins.sort (a: b: a < b);

    # Sort a list based on ascii code point ignoring case
    sortCaseless = builtins.sort
      (a: b: with __nixpkgs__.lib.strings; toLower a < toLower b);

    # Small snippet to pull a value from an env var if null
    valueOrEnv = value: envVar:
      if value == null
      then "\${${envVar}}"
      else value;
  };
  constants = {
    inherit __nixpkgs__;
    inherit inputs;
    inherit makesVersion;
    inherit outputs;
    fakeSha256 = __nixpkgs__.lib.fakeSha256;
  };
  args = (derivations // functions // constants);
in
args
