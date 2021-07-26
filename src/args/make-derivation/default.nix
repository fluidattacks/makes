{ __nixpkgs__
, __shellCommands__
, __shellOptions__
, asContent
, hasPrefix
, makeSearchPaths
, optionalAttrs
, toDerivationName
, ...
}:

{ action ? null
, builder
, env ? { }
, envFiles ? { }
, local ? false
, name
, searchPaths ? { }
, sha256 ? null
}:
let
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

  searchPathsBase = __nixpkgs__.lib.strings.makeBinPath [
    __nixpkgs__.coreutils
  ];
in
builtins.derivation (env' // {
  __envShellCommands = __shellCommands__;
  __envShellOptions = __shellOptions__;
  __envSearchPathsBase = searchPathsBase;
  args = [
    (builtins.toFile "make-derivation" ''
      source $__envShellCommands
      source $__envShellOptions
      export PATH=$__envSearchPathsBase
      if test -v __envSearchPaths; then
        source $__envSearchPaths/template
      fi

      ${asContent builder}

      if test -v __envAction; then
        copy $__envAction $out/makes-action.sh
      fi
    '')
  ];
  builder = "${__nixpkgs__.bash}/bin/bash";
  name = toDerivationName name;
  outputs = [ "out" ];
  passAsFile = builtins.attrNames envFiles;
  system = builtins.currentSystem;
} // optionalAttrs (action != null) {
  __envAction = __nixpkgs__.writeShellScript "makes-action-for-${name}" ''
    source ${__shellOptions__}
    export PATH=${searchPathsBase}

    ${action}
  '';
} // optionalAttrs (local) {
  allowSubstitutes = false;
  preferLocalBuild = true;
} // optionalAttrs (searchPaths != { }) {
  __envSearchPaths = makeSearchPaths searchPaths;
} // optionalAttrs (sha256 != null) {
  outputHash = sha256;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
})
