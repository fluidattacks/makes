{ fetchNixpkgs
, outputs
, ...
}:
{
  projectIdentifier = "makes-repo";
  cache = {
    readAndWrite = {
      enable = true;
      name = "makes";
      pubKey = "makes.cachix.org-1:HbCQcdlYyT/mYuOx6rlgkNkonTGUjVr3D+YpuGRmO+Y=";
    };
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
        tag = "fluidattacks/makes:21.10";
      };
    };
  };
  deployTerraform = {
    modules = {
      module = {
        src = "/test/terraform/module";
        version = "0.14";
      };
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
  extendingMakesDir = "/makes";
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
      config = "/test/lint-markdown/config.rb";
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
    imports = {
      makes = {
        config = "/src/cli/imports.cfg";
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
        version = "0.14";
      };
    };
  };
  lintWithLizard = {
    all = [ "/" ];
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
          args = [ ];
        }
        {
          output = "/helloWorld";
          args = [ "1" "2" "3" ];
        }
      ];
    };
  };
  secretsForGpgFromEnv = {
    example = [ "PGP_PUBLIC" "PGP_PRIVATE" ];
  };
  secretsForEnvFromSops = {
    example = {
      manifest = "/makes/tests/secretsForGpgFromEnv/secrets.yaml";
      vars = [ "secret" ];
    };
  };
  secretsForTerraformFromEnv = {
    example = {
      test = "VAR_NAME";
    };
  };
  secureNixWithVulnix = {
    all = {
      derivations = [
        outputs."/tests/secureNixWithVulnix"
      ];
      whitelist = {
        "binutils-2.35.1" = {
          cve = [ "CVE-2021-20284" "CVE-2021-20294" "CVE-2021-3487" ];
          until = "2100-01-01";
          comment = "Need CI to pass Jeje";
        };
      };
    };
  };
  securePythonWithBandit = {
    cli = {
      python = "3.8";
      target = "/src/cli";
    };
  };
  taintTerraform = {
    modules = {
      module = {
        resources = [ "null_resource.example" ];
        src = "/test/terraform/module";
        version = "0.14";
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
        version = "0.14";
      };
    };
  };
  lintClojure = {
    test = [ "/test" ];
  };
}
