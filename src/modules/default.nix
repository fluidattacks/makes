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
      inherit packages;
    })
    (import ./required-makes-version.nix {
      inherit makesVersion;
    })
  ];
}
