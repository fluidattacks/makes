{ head
, makesVersion
, packages
}:
{
  imports = [
    (import ./assertions.nix)
    (import ./inputs.nix {
      inherit packages;
    })
    (import ./outputs {
      inherit head;
    })
    (import ./required-makes-version.nix {
      inherit makesVersion;
    })
  ];
}
