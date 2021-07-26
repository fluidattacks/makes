{ hasPrefix
, projectSrc
, ...
}:
rel:
if hasPrefix "/" rel
then
  (builtins.path {
    name = if rel == "/" then "src" else builtins.baseNameOf rel;
    path = projectSrc + rel;
  })
else abort "projectPath arguments must start with: /, currently it is: ${rel}"
