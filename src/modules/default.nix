{ args
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
      inherit args;
    })
    (import ./required-makes-version.nix {
      inherit makesVersion;
    })
  ];
}
