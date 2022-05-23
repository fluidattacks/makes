{
  __nixpkgs__,
  fetchNixpkgs,
  inputs,
  outputs,
  ...
}: {
  projectIdentifier = "makes-repo";
  cache = {
    readAndWrite = {
      enable = true;
      name = "makes";
      pubKey = "makes.cachix.org-1:HbCQcdlYyT/mYuOx6rlgkNkonTGUjVr3D+YpuGRmO+Y=";
    };
  };
  calculateScorecard = {
    enable = true;
    target = "github.com/fluidattacks/makes";
  };
  deployContainerImage = {
    images = {
      makesGitHub = {
        attempts = 3;
        credentials = {
          token = "GITHUB_TOKEN";
          user = "GITHUB_ACTOR";
        };
        registry = "ghcr.io";
        src = outputs."/container-image";
        tag = "fluidattacks/makes:22.06";
      };
    };
  };
  deployTerraform = {
    modules = {
      module = {
        src = "/test/terraform/module";
        version = "1.0";
      };
    };
  };
  dev = {
    example = {
      bin = [inputs.nixpkgs.hello];
    };
    makes = {
      source = [outputs."/cli/pypi"];
    };
  };
  envVars = {
    example = {
      # Don't do this in production, it's unsafe. We do this for testing purposes.
      PGP_PRIVATE = builtins.readFile ./makes/tests/secretsForGpgFromEnv/pgp;
      PGP_PUBLIC = builtins.readFile ./makes/tests/secretsForGpgFromEnv/pgp.pub;
      VAR_NAME = "test";
    };
  };
  envVarsForTerraform = {
    example = {
      VAR_NAME = "test";
    };
  };
  extendingMakesDirs = ["/makes"];
  formatBash = {
    enable = true;
    targets = ["/"];
  };
  formatJavaScript = {
    enable = true;
    targets = ["/"];
  };
  formatMarkdown = {
    enable = true;
    doctocArgs = ["--title" "# Contents"];
    targets = ["/README.md"];
  };
  formatNix = {
    enable = true;
    targets = ["/"];
  };
  formatPython = {
    enable = true;
    targets = ["/"];
  };
  formatTerraform = {
    enable = true;
    targets = ["/"];
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
    targets = ["/"];
  };
  lintGitCommitMsg = {
    enable = true;
    branch = "main";
    parser = "/test/lint-commit-msg/lint-git-commit-msg-parser.js";
    config = "/test/lint-commit-msg/lint-git-commit-msg-config.js";
  };
  lintGitMailMap = {
    enable = true;
  };
  lintMarkdown = {
    all = {
      config = "/test/lint-markdown/config.rb";
      targets = ["/"];
    };
  };
  lintNix = {
    enable = true;
    targets = ["/"];
  };
  lintPython = let
    searchPaths = {
      source = [outputs."/cli/pypi"];
    };
  in {
    dirsOfModules = {
      makes = {
        python = "3.9";
        inherit searchPaths;
        src = "/src/cli";
      };
    };
    imports = {
      makes = {
        config = "/src/cli/imports.cfg";
        src = "/src/cli";
      };
    };
    modules = {
      cliMain = {
        python = "3.9";
        inherit searchPaths;
        src = "/src/cli/main";
      };
    };
  };
  lintTerraform = {
    modules = {
      module = {
        src = "/test/terraform/module";
        version = "1.0";
      };
    };
  };
  lintWithLizard = {
    all = ["/"];
  };
  lintWithAjv = {
    "test" = {
      schema = "/test/lint-with-ajv/schema.json";
      targets = [
        "/test/lint-with-ajv/data.json"
        "/test/lint-with-ajv/data.yaml"
      ];
    };
  };
  pipelines = {
    example = {
      gitlabPath = "/.gitlab-ci.yaml";
      jobs = [
        {
          output = "/lintNix";
          args = [];
        }
        {
          output = "/helloWorld";
          args = ["1" "2" "3"];
        }
      ];
    };
  };
  secretsForGpgFromEnv = {
    example = ["PGP_PUBLIC" "PGP_PRIVATE"];
  };
  secretsForEnvFromSops = {
    example = {
      manifest = "/makes/tests/secretsForGpgFromEnv/secrets.yaml";
      vars = ["secret"];
    };
  };
  secretsForTerraformFromEnv = {
    example = {
      test = "VAR_NAME";
    };
  };
  securePythonWithBandit = {
    cli = {
      python = "3.9";
      target = "/src/cli";
    };
  };
  taintTerraform = {
    modules = {
      module = {
        resources = ["null_resource.example"];
        src = "/test/terraform/module";
        version = "1.0";
      };
    };
  };
  testPython = {
    example = {
      python = "3.9";
      src = "/test/test-python";
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
        version = "1.0";
      };
    };
  };
  lintClojure = {
    test = ["/test"];
  };
}
