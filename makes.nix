{ fetchNixpkgs
, outputs
, ...
}:
{
  inputs = {
    nixpkgs = fetchNixpkgs {
      rev = "f88fc7a04249cf230377dd11e04bf125d45e9abe";
      sha256 = "1dkwcsgwyi76s1dqbrxll83a232h9ljwn4cps88w9fam68rf8qv3";
    };
  };

  cache = {
    enable = true;
    name = "fluidattacks";
    pubKey = "fluidattacks.cachix.org-1:upiUCP8kWnr7NxVSJtTOM+SBqL0pZhZnUoqPG04sBv0=";
  };
  deployContainerImage = {
    images = {
      makesGitHub = {
        registry = "ghcr.io";
        src = outputs."/container-image";
        tag = "fluidattacks/makes:main";
      };
      makesGitHubMonthly = {
        registry = "ghcr.io";
        src = outputs."/container-image";
        tag = "fluidattacks/makes:21.08";
      };
    };
  };
  deployTerraform = {
    modules = {
      module = {
        src = "/test/terraform/module";
        version = "0.13";
      };
    };
  };
  formatBash = {
    enable = true;
    targets = [ "/" ];
  };
  formatMarkdown = {
    enable = true;
    doctocArgs = [ "--title" "# Contents" ];
    targets = [ "/README.md" ];
  };
  formatNix = {
    enable = true;
    targets = [ "/" ];
  };
  formatPython = {
    enable = true;
    targets = [ "/" ];
  };
  formatTerraform = {
    enable = true;
    targets = [ "/" ];
  };
  helloWorld = {
    enable = true;
    name = "Jane Doe";
  };
  lintBash = {
    enable = true;
    targets = [ "/" ];
  };
  lintCommitMsg = {
    enable = true;
    branch = "main";
  };
  lintGitMailMap = {
    enable = true;
  };
  lintMarkdown = {
    enable = true;
    targets = [ "/" ];
  };
  lintNix = {
    enable = true;
    targets = [ "/" ];
  };
  lintPython = {
    dirsOfModules = {
      makes = {
        python = "3.8";
        src = "/src/cli";
      };
    };
    modules = {
      cliMain = {
        python = "3.8";
        src = "/src/cli/main";
      };
    };
  };
  lintTerraform = {
    modules = {
      module = {
        src = "/test/terraform/module";
        version = "0.13";
      };
    };
  };
  lintWithLizard = {
    targets = {
      all = [ "/" ];
    };
  };
  requiredMakesVersion = "21.08";
  testTerraform = {
    modules = {
      module = {
        src = "/test/terraform/module";
        version = "0.13";
      };
    };
  };
}
