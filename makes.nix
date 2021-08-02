{ fetchNixpkgs
, outputs
, ...
}:
{
  cache = {
    enable = true;
    name = "makes";
    pubKey = "makes.cachix.org-1:HbCQcdlYyT/mYuOx6rlgkNkonTGUjVr3D+YpuGRmO+Y=";
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
        tag = "fluidattacks/makes:21.09";
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
  envVars = {
    example = {
      VAR_NAME = "test";
    };
  };
  envVarsForTerraform = {
    example = {
      VAR_NAME = "test";
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
  lintGitCommitMsg = {
    enable = true;
    branch = "main";
  };
  lintGitMailMap = {
    enable = true;
  };
  lintMarkdown = {
    all = {
      config = ./config/markdown.rb;
      targets = [ "/" ];
    };
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
    all = [ "/" ];
  };
  pipelines = {
    example = {
      jobs = [
        {
          output = "/lintNix";
          args = [ ];
        }
        {
          output = "/helloWorld";
          args = [ "1" "2" "3" ];
        }
      ];
    };
  };
  secretsForTerraformFromEnv = {
    example = {
      test = "VAR_NAME";
    };
  };
  securePythonWithBandit = {
    cli = {
      python = "3.8";
      target = "/src/cli";
    };
  };
  testTerraform = {
    modules = {
      module = {
        setup = [
          outputs."/envVars/example"
          outputs."/secretsForTerraformFromEnv/example"
        ];
        src = "/test/terraform/module";
        version = "0.13";
      };
    };
  };
  lintClojure = {
    test = [ "/test" ];
  };
}
