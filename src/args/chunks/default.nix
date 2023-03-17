{
  __nixpkgs__,
  sublist,
  ...
}: list: n: let
  inherit (__nixpkgs__) lib;

  len = lib.lists.length list;
  div = len / n;
  mod = lib.trivial.mod len n;
  range = lib.lists.range 0 (n - 1);
  inherit (lib.trivial) min;
  startIndex = i: i * div + (min i mod);
  endIndex = i: (i + 1) * div + (min (i + 1) mod);
in
  builtins.map (i: sublist list (startIndex i) (endIndex i)) range
