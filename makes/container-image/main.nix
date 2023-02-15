{
  inputs,
  outputs,
  ...
}:
inputs.nixpkgs.dockerTools.buildImage {
  config = {
    Env = [
      "HOME=/home/root"
      "PATH=/bin:/nix/var/nix/profiles/default/bin"
      "USER=root"

      # Certificate authorities
      "GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "SYSTEM_CERTIFICATE_PATH=/etc/ssl/certs/ca-bundle.crt"
    ];
    User = "root:root";
    WorkingDir = "/working-dir";
  };
  name = "container-image";
  tag = "latest";
  contents = [
    (inputs.nixpkgs.buildEnv {
      name = "root-file-system";
      ignoreCollisions = true;
      paths = [
        # Basic dependencies
        inputs.nixpkgs.bashInteractive
        inputs.nixpkgs.cacert
        inputs.nixpkgs.coreutils
        inputs.nixpkgs.git
        inputs.nixpkgs.gnugrep
        inputs.nixpkgs.gnutar
        inputs.nixpkgs.gzip
        inputs.nixpkgs.nix

        # Add /usr/bin/env pointing to /bin/env
        (inputs.nixpkgs.runCommand "user-bin-env" {} ''
          mkdir -p $out/usr/bin
          ln -s $(command -v env) $out/usr/bin/env
        '')

        # Create home directories
        (inputs.nixpkgs.runCommand "home" {} ''
          mkdir -p $out/home/makes
          mkdir -p $out/home/root
        '')
        # Create empty temporary directories
        (inputs.nixpkgs.runCommand "tmp" {} ''
          mkdir -p $out/tmp
          mkdir -p $out/var/tmp
        '')
        # Create the working directory
        (inputs.nixpkgs.runCommand "working-directory" {} ''
          mkdir -p $out/working-dir
        '')

        # Configure Nix
        (inputs.nixpkgs.writeTextDir "home/makes/.config/nix/nix.conf" ''
          build-users-group =
        '')
        (inputs.nixpkgs.writeTextDir "home/root/.config/nix/nix.conf" ''
          build-users-group =
        '')
        (inputs.nixpkgs.writeTextDir "etc/nix/nix.conf" ''
          build-users-group =
        '')

        # Configure SSH
        (inputs.nixpkgs.writeTextFile {
          name = "home-makes-ssh-config";
          destination = "/home/makes/.ssh/config";
          text = ''
            Host *
              StrictHostKeyChecking no
          '';
          checkPhase = ''
            chmod 400 $out$destination
          '';
        })
        (inputs.nixpkgs.writeTextFile {
          name = "home-root-ssh-config";
          destination = "/home/root/.ssh/config";
          text = ''
            Host *
              StrictHostKeyChecking no
          '';
          checkPhase = ''
            chmod 400 $out$destination
          '';
        })

        # Configure doas
        (inputs.nixpkgs.writeTextDir "etc/doas.conf" ''
          permit nopass keepenv root as makes
        '')

        # Add 3 groups
        (inputs.nixpkgs.writeTextDir "etc/group" ''
          root:x:0:
          makes:x:48:
          nobody:x:65534:
        '')
        (inputs.nixpkgs.writeTextDir "etc/gshadow" ''
          root:*::
          makes:*::
          nobody:*::
        '')

        # Add 3 users, mapped to groups with their own name
        (inputs.nixpkgs.writeTextDir "etc/passwd" ''
          root:x:0:0:root:/home/root:/bin/bash
          makes:x:48:48:makes:/home/makes:/bin/bash
          nobody:x:65534:65534:nobody:/homeless:/bin/false
        '')
        (inputs.nixpkgs.writeTextDir "etc/shadow" ''
          root:!x:::::::
          makes:!x:::::::
          nobody:!x:::::::
        '')

        # Miscelaneous configurations
        (inputs.nixpkgs.writeTextDir "etc/login.defs" "")
        (inputs.nixpkgs.writeTextDir "etc/nsswitch.conf" ''
          hosts: dns files
        '')
        (inputs.nixpkgs.writeTextDir "etc/pam.d/other" ''
          account sufficient pam_unix.so
          auth sufficient pam_rootok.so
          password requisite pam_unix.so nullok sha512
          session required pam_unix.so
        '')

        # Add Makes:
        # - By default, it runs as root (uid 0).
        # - If `MAKES_NON_ROOT` is in the environment and non-empty,
        #   makes will run as the makes user (uid > 0).
        (inputs.nixpkgs.writeShellScriptBin "m" ''
          if test -z "''${MAKES_NON_ROOT:-}"; then
            ${outputs."/"}/bin/m "$@"
          else
            echo Using feature flag: MAKES_NON_ROOT

            set -x
            mkdir -p /nix/var/nix
            chmod u+w /nix/store
            chown makes:makes --recursive /nix
            chown root:root $(realpath /etc/doas.conf)

            chmod u+w /home/makes /tmp /working-dir
            chown makes:makes /home/makes /tmp /working-dir
            chown makes:makes --recursive "$PWD"

            ${inputs.nixpkgs.doas}/bin/doas -u makes ${outputs."/"}/bin/m "$@"
          fi
        '')
      ];
    })
  ];
}
