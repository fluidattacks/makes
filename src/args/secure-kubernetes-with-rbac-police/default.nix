{ __nixpkgs__, fetchUrl, makeDerivation, makeScript, ... }:
{ name, setup, severity, ... }:
let
  bin = makeDerivation {
    name = "make-rbac-police-binary";
    env = {
      envGlibc = __nixpkgs__.glibc;
      envUnpatchedBin = fetchUrl {
        url =
          "https://github.com/PaloAltoNetworks/rbac-police/releases/download/v1.0.1/rbac-police_v1.0.1_linux_amd64";
        sha256 = "0k4dvc9r165q9lwidnks0vm7kqzi55l29p6iw9xy9l3982saihvi";
      };
    };
    searchPaths.bin = [ __nixpkgs__.patchelf ];
    builder = ''
      copy "$envUnpatchedBin" "$out"
      chmod +x "$out"
      patchelf --set-interpreter "$envGlibc/lib/ld-linux-x86-64.so.2" "$out"
    '';
  };
  repo = builtins.fetchTarball {
    url =
      "https://github.com/PaloAltoNetworks/rbac-police/archive/ffe47f709a747fc92cbeeb2eec688b4ea544b958.tar.gz";
    sha256 = "0hna14rwkfadqq2higzz033hkdpxpnzi5vg340xsk50ipr41g689";
  };
in makeScript {
  name = "secure-kubernetes-with-rbac-police-for-${name}";
  replace = {
    __argBin__ = bin;
    __argRepo__ = repo;
    __argSeverity__ = severity;
  };
  searchPaths = {
    bin = [ __nixpkgs__.jq ];
    source = setup;
  };
  entrypoint = ./entrypoint.sh;
}
