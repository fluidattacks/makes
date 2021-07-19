{ __nixpkgs__
, asContent
, __shellCommands__
, __shellOptions__
, makeSearchPaths
, toDerivationName
, ...
}:

{ actions ? [ ]
, builder
, env ? { }
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

  # Validate env
  env' = builtins.mapAttrs
    (k: v: (
      if (
        (__nixpkgs__.lib.strings.hasPrefix "__" k) ||
        (__nixpkgs__.lib.strings.hasPrefix "env" k)
      )
      then v
      else
        abort ''

          Invalid argument: ${k}, must start with: env

        ''
    ))
    env;
in
builtins.derivation (env' // {
  __envShellCommands = __shellCommands__;
  __envShellOptions = __shellOptions__;
  __envSearchPaths =
    if searchPaths == { }
    then "/dev/null"
    else "${makeSearchPaths searchPaths}/makes-setup.sh";
  __envSearchPathsBase = __nixpkgs__.lib.strings.makeBinPath [
    __nixpkgs__.coreutils
  ];
  args = [
    (builtins.toFile "make-derivation" ''
      source $__envShellCommands
      source $__envShellOptions
      export PATH=$__envSearchPathsBase
      source $__envSearchPaths

      ${asContent builder}
      ${actions'}
    '')
  ];
  builder = "${__nixpkgs__.bash}/bin/bash";
  name = toDerivationName name;
  system = builtins.currentSystem;
} // __nixpkgs__.lib.optionalAttrs local {
  allowSubstitutes = false;
  preferLocalBuild = true;
} // __nixpkgs__.lib.optionalAttrs (sha256 != null) {
  outputHash = sha256;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
})
