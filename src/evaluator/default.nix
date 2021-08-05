# This evaluator function
# should only be called by a Makes CLI.
#
# Changing any of the following three arguments
# means that a user will require to update its Makes CLI to the latest version
# AND migrate their project to be compatible with the latest framework src.
# It also means that users with a non-latest CLI won't be able to use
# Makes projects build with latest framework releases.
#
# You better avoid changing this function signature...
# Ask a maintainer first.
{
  # Source code of makes, can be overriden by the user.
  makesSrc
  # Path to the user's project, inside a sandbox.
  # The sandbox excludes files not-tracked by git.
, projectSrc
  # Path to the user's project, outside the sandbox.
  # Only available when running local Makes projects.
, projectSrcMutable ? projectSrc

  # Arguments below are used by the evaluator to recurse on itself

  # All outputs will be preceded by this prefix,
  # some outputs are only available in the top level
, outputsPrefix ? ""
, ...
}:
let
  makesNixPath = projectSrc + "/makes.nix";
  makesNix =
    if builtins.pathExists makesNixPath
    then import makesNixPath
    else { };

  makesLockNixPath = projectSrc + "/makes.lock.nix";
  makesLockNix =
    if builtins.pathExists makesLockNixPath
    then import makesLockNixPath
    else { };

  makesSrcOverriden =
    if makesLockNix ? "makesSrc"
    then makesLockNix.makesSrc
    else makesSrc;

  args = import "${makesSrcOverriden}/src/args/default.nix" {
    __nixpkgs__ = packages.nixpkgs;
    __outputsPrefix__ = outputsPrefix;
    inherit projectSrc;
    inherit projectSrcMutable;
    inputs = result.config.inputs;
    outputs = result.config.outputs;
  };
  packages = import "${makesSrcOverriden}/src/nix/packages.nix";
  result = packages.nixpkgs.lib.modules.evalModules {
    modules = [
      ("${makesSrcOverriden}/src/evaluator/modules/default.nix")
      (makesNix)
    ];
    specialArgs = args;
  };
in
result
