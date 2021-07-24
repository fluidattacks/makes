{ __nixpkgs__
, asContent
, hasPrefix
, optionalAttrs
, __shellCommands__
, __shellOptions__
, makeSearchPaths
, toDerivationName
, ...
}:

{ actions ? [ ]
, builder
, env ? { }
, envFiles ? { }
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
      if (hasPrefix "__" k) || (hasPrefix "env" k)
      then v
      else
        abort ''

          Invalid argument: ${k}, must start with: env

        ''
    ))
    (env // envFiles);
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
  passAsFile = builtins.attrNames envFiles;
  system = builtins.currentSystem;
} // optionalAttrs local {
  allowSubstitutes = false;
  preferLocalBuild = true;
} // optionalAttrs (sha256 != null) {
  outputHash = sha256;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
})
