expr:
if builtins.isPath expr
then builtins.readFile expr
else if builtins.isString expr
then expr
else abort "Expected a store path or a string, got: ${builtins.typeOf expr}"
