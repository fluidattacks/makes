name: list:
builtins.toFile name (builtins.concatStringsSep "\n" (list ++ [ "" ]))
