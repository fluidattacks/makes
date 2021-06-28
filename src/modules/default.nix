{ head
, packages
}:

{
  imports = [
    (import ./inputs.nix {
      inherit packages;
    })
    (import ./outputs {
      inherit head;
      inherit packages;
    })
  ];
}
