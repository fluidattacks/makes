{ __packages
, builtinLambdas
, builtinShellCommands
, builtinShellOptions
, makeSearchPaths
, path
, ...
}:

{ actions ? [ ]
, arguments ? { }
, builder
, local ? false
, name
, searchPaths ? { }
, sha256 ? null
}:
let
  actions' =
    if actions == [ ]
    then ""
    else "echo '${builtins.toJSON actions}' > $out/makes-actions.json";

  # Validate arguments
  arguments' = builtins.mapAttrs
    (k: v: (
      if (
        (__packages.nixpkgs.lib.strings.hasPrefix "__env" k) ||
        (__packages.nixpkgs.lib.strings.hasPrefix "env" k)
      )
      then v
      else abort "Invalid argument: ${k}, must start with: env or __env"
    ))
    arguments;
in
builtins.derivation (arguments' // {
  __envBuiltinShellCommands = builtinShellCommands;
  __envBuiltinShellOptions = builtinShellOptions;
  __envSearchPaths =
    if searchPaths == { }
    then "/dev/null"
    else makeSearchPaths searchPaths;
  __envSearchPathsBase = __packages.nixpkgs.lib.strings.makeBinPath [
    __packages.nixpkgs.coreutils
  ];
  args = [
    (builtins.toFile "make-derivation" ''
      source $__envBuiltinShellOptions
      source $__envBuiltinShellCommands
      export PATH=$__envSearchPathsBase
      source $__envSearchPaths

      ${builtinLambdas.asContent builder}
      ${actions'}
    '')
  ];
  builder = "${__packages.nixpkgs.bash}/bin/bash";
  inherit name;
  system = builtins.currentSystem;
} // __packages.nixpkgs.lib.optionalAttrs local {
  allowSubstitutes = false;
  preferLocalBuild = true;
} // __packages.nixpkgs.lib.optionalAttrs (sha256 != null) {
  outputHash = sha256;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
})
