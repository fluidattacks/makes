{
  __nixpkgs__,
  fetchGithub,
  fetchUrl,
  isLinux,
  makeScript,
  ...
}: {
  name,
  setup,
  severity,
  ...
}: let
  bin =
    if isLinux
    then
      fetchUrl {
        url = "https://github.com/PaloAltoNetworks/rbac-police/releases/download/v1.0.1/rbac-police_v1.0.1_linux_amd64";
        sha256 = "0k4dvc9r165q9lwidnks0vm7kqzi55l29p6iw9xy9l3982saihvi";
      }
    else
      fetchUrl {
        url = "https://github.com/PaloAltoNetworks/rbac-police/releases/download/v1.0.1/rbac-police_v1.0.1_darwin_amd64";
        sha256 = "16bi40pj2gq22w3b04bsfmh2iy2ax4jh8349lvpwm9rckkhrkg91";
      };
  repo = fetchGithub {
    owner = "PaloAltoNetworks";
    repo = "rbac-police";
    rev = "ffe47f709a747fc92cbeeb2eec688b4ea544b958";
    sha256 = "0hna14rwkfadqq2higzz033hkdpxpnzi5vg340xsk50ipr41g689";
  };
in
  makeScript {
    name = "secure-kubernetes-with-rbac-police-for-${name}";
    replace = {
      __argBin__ = bin;
      __argRepo__ = repo;
      __argSeverity__ = severity;
    };
    searchPaths = {
      bin = [__nixpkgs__.jq];
      source = setup;
    };
    entrypoint = ./entrypoint.sh;
  }
