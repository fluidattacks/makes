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
# JSON String containing complete list of main.nix files found within projectSrc
attrPaths,
# Source code of makes, can be overriden by the user.
makesSrc,
# Path to the user's project, inside a sandbox.
# The sandbox excludes files not-tracked by git.
projectSrc,
# System we should evaluate for
system ? builtins.currentSystem, ... }:
let
  makesNixPath = projectSrc + "/makes.nix";
  makesNix =
    if builtins.pathExists makesNixPath then import makesNixPath else { };

  makesLockNixPath = projectSrc + "/makes.lock.nix";
  makesLockNix = if builtins.pathExists makesLockNixPath then
    import makesLockNixPath
  else
    { };

  makesSrcOverriden =
    if makesLockNix ? "makesSrc" then makesLockNix.makesSrc else makesSrc;

  args = import "${makesSrcOverriden}/src/args/default.nix" {
    inherit (result.config) inputs;
    inherit (result.config) outputs;
    inherit (result.config) projectIdentifier;
    inherit projectSrc;
    stateDirs = {
      global = result.config.globalStateDir;
      project = result.config.projectStateDir;
    };
    inherit system;
  };
  nixpkgs = import sources.nixpkgs { inherit system; };
  sources = import "${makesSrcOverriden}/src/nix/sources.nix";
  result = nixpkgs.lib.modules.evalModules {
    modules =
      [ "${makesSrcOverriden}/src/evaluator/modules/default.nix" makesNix ];
    specialArgs = args // { inherit attrPaths; };
  };
in result
