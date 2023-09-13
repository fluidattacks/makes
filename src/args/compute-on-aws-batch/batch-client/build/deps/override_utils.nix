let
  recursive_python_pkg_override = is_pkg: override: let
    # is_pkg: Derivation -> Bool
    # override: Derivation -> Derivation
    self = recursive_python_pkg_override is_pkg override;
  in
    pkg:
      if is_pkg pkg
      then override pkg
      else if pkg ? overridePythonAttrs && pkg ? pname
      then
        pkg.overridePythonAttrs (
          builtins.mapAttrs (_: value:
            if builtins.isList value
            then map self value
            else self value)
        )
      else pkg;

  # no_check_override: Derivation -> Derivation
  no_check_override = recursive_python_pkg_override (pkg: pkg ? overridePythonAttrs && pkg ? pname) (
    pkg:
      pkg.overridePythonAttrs (
        old:
          (
            builtins.mapAttrs (_: value:
              if builtins.isList value
              then map no_check_override value
              else no_check_override value)
            old
          )
          // {
            doCheck = false;
          }
      )
  );

  # replace_pkg: List[str] -> Derivation -> Derivation
  replace_pkg = names: new_pkg:
    recursive_python_pkg_override (
      x: x ? overridePythonAttrs && x ? pname && builtins.elem x.pname names
    ) (_: new_pkg);
in {
  inherit recursive_python_pkg_override no_check_override replace_pkg;
  compose = functions: val: builtins.foldl' (x: f: f x) val functions;
}
