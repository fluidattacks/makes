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
    User = "makes:makes";
    WorkingDir = "/makes";
  };
  layers = [
    (makeDerivation {
      env = {
        envEtcGroup = ''
          makes:x:0:
          nobody:x:65534:
        '';
        envEtcGshadow = ''
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
          makes:x:0:0::/home/makes:${inputs.nixpkgs.bash}/bin/bash
          nobody:x:65534:65534:nobody:/homeless:/bin/false
        '';
        envEtcShadow = ''
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

    outputs."/"
  ];
}
