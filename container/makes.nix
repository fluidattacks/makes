{ outputs, __nixpkgs__, ... }: {
  deployContainer = {
    makesAmd64 = {
      credentials = {
        token = "GITHUB_TOKEN";
        user = "GITHUB_ACTOR";
      };
      image = "ghcr.io/fluidattacks/makes:amd64";
      src = outputs."/container";
      sign = true;
    };
    makesArm64 = {
      credentials = {
        token = "GITHUB_TOKEN";
        user = "GITHUB_ACTOR";
      };
      image = "ghcr.io/fluidattacks/makes:arm64";
      src = outputs."/container";
      sign = true;
    };
  };
  deployContainerManifest = {
    makes = {
      credentials = {
        token = "GITHUB_TOKEN";
        user = "GITHUB_ACTOR";
      };
      image = "ghcr.io/fluidattacks/makes:latest";
      manifests = [
        {
          image = "ghcr.io/fluidattacks/makes:amd64";
          platform = {
            architecture = "amd64";
            os = "linux";
          };
        }
        {
          image = "ghcr.io/fluidattacks/makes:arm64";
          platform = {
            architecture = "arm64";
            os = "linux";
          };
        }
      ];
      sign = true;
      tags = [ "24.12" ];
    };
  };
  jobs."/container" = __nixpkgs__.dockerTools.buildImage {
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

        # Support non-nix binaries via nix-ld
        "NIX_LD_LIBRARY_PATH=${
          __nixpkgs__.lib.makeLibraryPath [ __nixpkgs__.stdenv.cc ]
        }"
        "NIX_LD=${
          __nixpkgs__.lib.fileContents
          "${__nixpkgs__.stdenv.cc}/nix-support/dynamic-linker"
        }"
      ];
      User = "root:root";
      WorkingDir = "/working-dir";
    };
    name = "container";
    tag = "latest";

    copyToRoot = __nixpkgs__.buildEnv {
      name = "root-file-system";
      ignoreCollisions = false;
      paths = [
        # Basic dependencies
        __nixpkgs__.bashInteractive
        __nixpkgs__.cacert
        __nixpkgs__.coreutils
        __nixpkgs__.git
        __nixpkgs__.gnugrep
        __nixpkgs__.gnutar
        __nixpkgs__.gzip
        __nixpkgs__.nixVersions.nix_2_15

        # Support non-nix binaries via nix-ld
        (__nixpkgs__.runCommand "dynamic-linker" { } ''
          mkdir -p $out/lib
          mkdir -p $out/lib64
          ln -s ${__nixpkgs__.nix-ld}/libexec/nix-ld $out/lib/$(basename $(< ${__nixpkgs__.stdenv.cc}/nix-support/dynamic-linker))
          ln -s ${__nixpkgs__.nix-ld}/libexec/nix-ld $out/lib64/$(basename $(< ${__nixpkgs__.stdenv.cc}/nix-support/dynamic-linker))
        '')

        # Add /usr/bin/env pointing to /bin/env
        (__nixpkgs__.runCommand "user-bin-env" { } ''
          mkdir -p $out/usr/bin
          ln -s $(command -v env) $out/usr/bin/env
        '')

        # Create home directories
        (__nixpkgs__.runCommand "home" { } ''
          mkdir -p $out/home/makes
          mkdir -p $out/home/root
        '')
        # Create empty temporary directories
        (__nixpkgs__.runCommand "tmp" { } ''
          mkdir -p $out/tmp
          mkdir -p $out/var/tmp
        '')
        # Create the working directory
        (__nixpkgs__.runCommand "working-directory" { } ''
          mkdir -p $out/working-dir
        '')

        # Configure Nix
        (__nixpkgs__.writeTextDir "/home/makes/.config/nix/nix.conf" ''
          build-users-group =
        '')
        (__nixpkgs__.writeTextDir "/home/root/.config/nix/nix.conf" ''
          build-users-group =
        '')
        (__nixpkgs__.writeTextDir "/etc/nix/nix.conf" ''
          build-users-group =
        '')

        # Configure SSH
        (__nixpkgs__.writeTextFile {
          name = "home-makes-ssh-config";
          destination = "/home/makes/.ssh/config";
          text = ''
            Host *
              StrictHostKeyChecking no
          '';
          checkPhase = ''
            chmod 400 $out/home/makes/.ssh/config
          '';
        })
        (__nixpkgs__.writeTextFile {
          name = "home-root-ssh-config";
          destination = "/home/root/.ssh/config";
          text = ''
            Host *
              StrictHostKeyChecking no
          '';
          checkPhase = ''
            chmod 400 $out/home/root/.ssh/config
          '';
        })

        # Add 3 groups
        (__nixpkgs__.writeTextDir "etc/group" ''
          root:x:0:
          makes:x:48:
          nobody:x:65534:
        '')
        (__nixpkgs__.writeTextDir "etc/gshadow" ''
          root:*::
          makes:*::
          nobody:*::
        '')

        # Add 3 users, mapped to groups with their own name
        (__nixpkgs__.writeTextDir "etc/passwd" ''
          root:x:0:0:root:/home/root:/bin/bash
          makes:x:48:48:makes:/home/makes:/bin/bash
          nobody:x:65534:65534:nobody:/homeless:/bin/false
        '')
        (__nixpkgs__.writeTextDir "etc/shadow" ''
          root:!x:::::::
          makes:!x:::::::
          nobody:!x:::::::
        '')

        # Miscelaneous configurations
        (__nixpkgs__.writeTextDir "etc/login.defs" "")
        (__nixpkgs__.writeTextDir "etc/nsswitch.conf" ''
          hosts: dns files
        '')
        (__nixpkgs__.writeTextDir "etc/pam.d/other" ''
          account sufficient pam_unix.so
          auth sufficient pam_rootok.so
          password requisite pam_unix.so nullok sha512
          session required pam_unix.so
        '')

        # Add Makes
        outputs."/"
      ];
    };
  };
}
