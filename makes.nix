{ fetchNixpkgs, outputs, __nixpkgs__, ... }: {
  cache = {
    readNixos = true;
    extra = {
      makes = {
        enable = true;
        pubKey =
          "makes.cachix.org-1:zO7UjWLTRR8Vfzkgsu1PESjmb6ymy1e4OE9YfMmCQR4=";
        token = "CACHIX_AUTH_TOKEN";
        type = "cachix";
        url = "https://makes.cachix.org";
        write = true;
      };
    };
  };
  dev = {
    makes = {
      bin = [ __nixpkgs__.just __nixpkgs__.reuse ];
      source = [ outputs."/src/cli/runtime" ];
    };
  };
  formatBash = {
    enable = true;
    targets = [ "/" ];
  };
  formatNix = {
    enable = true;
    targets = [ "/" ];
  };
  formatTerraform = {
    enable = true;
    targets = [ "/" ];
  };
  formatYaml = {
    enable = true;
    targets = [ "/" ];
  };
  imports = [
    ./container/makes.nix
    ./docs/makes.nix
    ./src/makes.nix
    ./tests/makes.nix
    ./utils/makes.nix
  ];
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };
  lintBash = {
    enable = true;
    targets = [ "/" ];
  };
  lintGitMailMap.enable = true;
  lintNix = {
    enable = true;
    targets = [ "/" ];
  };
  projectIdentifier = "makes-repo";
  testLicense.enable = true;
}
