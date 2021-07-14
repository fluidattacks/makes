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
    deployContainerImage = import ./deploy-container-image/default.nix args;
    fetchNixpkgs = import ./fetchers/nixpkgs.nix args;
    fetchUrl = import ./fetchers/url.nix args;
    fetchZip = import ./fetchers/zip.nix args;
    makeContainerImage = import ./make-container-image/default.nix args;
    makeDerivation = import ./make-derivation/default.nix args;
    makeNodeEnvironment = import ./make-node-environment/default.nix args;
    makeParallel = import ./make-parallel/default.nix args;
    makePythonEnvironment = import ./make-python-environment/default.nix args;
    makeScript = import ./make-script/default.nix args;
    makeSearchPaths = import ./make-search-paths/default.nix args;
    makeTemplate = import ./make-template/default.nix args;
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

    # Dumps an expression to a file in JSON format
    toJSONFile = name: expr: args.makeDerivation {
      env.envAll = builtins.toJSON expr;
      builder = ''echo "$envAll" > $out'';
      inherit name;
    };

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
