{ buildEnv, buildPythonPackage, pkgDeps, src, }:
import ./generic_builder { inherit buildEnv buildPythonPackage pkgDeps src; }
