{
  fetchNixpkgs,
  fetchUrl,
  outputs,
  projectPath,
  __nixpkgs__,
  ...
}: {
  projectIdentifier = "makes-repo";
  cache = {
    readNixos = true;
    extra = {
      makes = {
        enable = true;
        pubKey = "makes.cachix.org-1:zO7UjWLTRR8Vfzkgsu1PESjmb6ymy1e4OE9YfMmCQR4=";
        token = "CACHIX_AUTH_TOKEN";
        type = "cachix";
        url = "https://makes.cachix.org";
        write = true;
      };
    };
  };
  calculateScorecard = {
    enable = true;
    target = "github.com/fluidattacks/makes";
  };
  deployContainerImage = {
    images = {
      makesLatestAmd64 = {
        attempts = 3;
        credentials = {
          token = "GITHUB_TOKEN";
          user = "GITHUB_ACTOR";
        };
        registry = "ghcr.io";
        src = outputs."/container-image";
        sign = true;
        tag = "fluidattacks/makes/amd64:latest";
      };
      makesLatestArm64 = {
        attempts = 3;
        credentials = {
          token = "GITHUB_TOKEN";
          user = "GITHUB_ACTOR";
        };
        registry = "ghcr.io";
        src = outputs."/container-image";
        sign = true;
        tag = "fluidattacks/makes/arm64:latest";
      };
      makesPinnedAmd64 = {
        attempts = 3;
        credentials = {
          token = "GITHUB_TOKEN";
          user = "GITHUB_ACTOR";
        };
        registry = "ghcr.io";
        src = outputs."/container-image";
        sign = true;
        tag = "fluidattacks/makes/amd64:23.07";
      };
      makesPinnedArm64 = {
        attempts = 3;
        credentials = {
          token = "GITHUB_TOKEN";
          user = "GITHUB_ACTOR";
        };
        registry = "ghcr.io";
        src = outputs."/container-image";
        sign = true;
        tag = "fluidattacks/makes/arm64:23.07";
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
      bin = [__nixpkgs__.hello];
    };
    makes = {
      bin = [
        __nixpkgs__.just
        __nixpkgs__.reuse
      ];
      source = [outputs."/cli/env/runtime"];
    };
    batchClient = {
      source = [outputs."/envs/compute-on-aws-batch"];
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
  formatNix = {
    enable = true;
    targets = ["/"];
  };
  formatPython = {
    default = {
      targets = ["/"];
    };
  };
  formatTerraform = {
    enable = true;
    targets = ["/"];
  };
  formatYaml = {
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
    searchPaths.source = [outputs."/cli/env/runtime"];
  in {
    dirsOfModules = {
      makes = {
        python = "3.10";
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
        python = "3.10";
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
      gitlabPath = "/test/pipelines/.gitlab-ci.yaml";
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
      python = "3.11";
      target = "/src/cli/main";
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
  testLicense = {
    enable = true;
  };
  testPython = {
    example = {
      python = "3.11";
      src = "/test/test-python";
    };
    cliMain = {
      python = "3.10";
      extraFlags = [
        "--cov=main"
        "--cov-branch"
        "--cov-report=term-missing"
        "--capture=no"
      ];
      searchPaths = {
        bin = [
          __nixpkgs__.git
        ];
        pythonPackage = [
          (projectPath "/src/cli/main")
        ];
        source = [
          outputs."/cli/env/test"
          outputs."/cli/env/runtime"
        ];
      };
      src = "/src/cli";
    };
  };
  testPullRequest = {
    modules = {
      default = {
        dangerfile = fetchUrl {
          url = "https://gitlab.com/fluidattacks/universe/-/raw/7012ee63b6ba5ffebfc82425deb4390cb1d4a1ca/common/test/mr/src/dangerfile.ts";
          sha256 = "sha256-OegMHRXwgkRItyxW5SZfcQr21VRIINKhC5mlYa/Rphw=";
        };
        extraArgs = [
          "--config"
          (builtins.toJSON {tests = ["onlyOneCommit"];})
        ];
      };
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
