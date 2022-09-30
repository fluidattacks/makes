# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  makeContainerImage,
  makeDerivation,
  inputs,
  outputs,
  ...
}:
makeContainerImage {
  config = {
    Env = [
      "GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt"
      "HOME=/home/makes"
      "NIX_PATH=/nix/var/nix/profiles/per-user/makes/channels"
      "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "PATH=/bin:/nix/var/nix/profiles/default/bin"
      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "SYSTEM_CERTIFICATE_PATH=/etc/ssl/certs/ca-bundle.crt"
      "USER=makes"
    ];
    User = "root:root";
    WorkingDir = "/";
  };
  layers = [
    (makeDerivation {
      env = {
        envEtcGroup = ''
          root:x:0:
          makes:x:48:
          nobody:x:65534:
        '';
        envEtcGshadow = ''
          root:*::
          makes:*::
          nobody:*::
        '';
        envEtcPamdOther = ''
          account sufficient pam_unix.so
          auth sufficient pam_rootok.so
          password requisite pam_unix.so nullok sha512
          session required pam_unix.so
        '';
        envEtcPasswd = ''
          root:x:0:0:root:/home/root:${inputs.nixpkgs.bash}/bin/bash
          makes:x:48:48:makes:/home/makes:${inputs.nixpkgs.bash}/bin/bash
          nobody:x:65534:65534:nobody:/homeless:/bin/false
        '';
        envEtcShadow = ''
          root:!x:::::::
          makes:!x:::::::
          nobody:!x:::::::
        '';
      };
      builder = ./builder.sh;
      name = "makes-container-images-customization";
    })

    inputs.nixpkgs.bash
    inputs.nixpkgs.cacert
    inputs.nixpkgs.coreutils
    inputs.nixpkgs.git
    inputs.nixpkgs.gnutar
    inputs.nixpkgs.gzip
    inputs.nixpkgs.nix

    (inputs.nixpkgs.writeShellScriptBin "m" ''
      if test -z "''${MAKES_NON_ROOT:-}"; then
        ${outputs."/"}/bin/m "$@"
      else
        echo Using feature flag: MAKES_NON_ROOT

        chown -R makes:makes /nix

        chmod u+w /home/makes
        chmod u+w /tmp
        chown makes:makes /home/makes
        chown makes:makes /tmp

        {
          echo permit nopass keepenv makes
          echo permit nopass keepenv root
        } > /etc/doas.conf

        ${inputs.nixpkgs.doas}/bin/doas -u makes ${outputs."/"}/bin/m "$@"
      fi
    '')
  ];
  maxLayers = 20;
}
