{ fetchNixpkgs, fetchUrl, outputs, projectPath, __nixpkgs__, ... }: {
  projectIdentifier = "makes-repo";
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
  deployContainer = {
    makesAmd64 = {
      credentials = {
        token = "GITHUB_TOKEN";
        user = "GITHUB_ACTOR";
      };
      image = "ghcr.io/fluidattacks/makes:amd64";
      src = outputs."/container-image";
      sign = true;
    };
    makesArm64 = {
      credentials = {
        token = "GITHUB_TOKEN";
        user = "GITHUB_ACTOR";
      };
      image = "ghcr.io/fluidattacks/makes:arm64";
      src = outputs."/container-image";
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
  deployTerraform = {
    modules = {
      module = {
        src = "/test/terraform/module";
        version = "1.0";
      };
    };
  };
  dev = {
    example = { bin = [ __nixpkgs__.hello ]; };
    makes = {
      bin = [ __nixpkgs__.just __nixpkgs__.reuse ];
      source = [ outputs."/cli/env/runtime" ];
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
  envVarsForTerraform = { example = { VAR_NAME = "test"; }; };
  extendingMakesDirs = [ "/makes" ];
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
  lintGitMailMap = { enable = true; };
  lintNix = {
    enable = true;
    targets = [ "/" ];
  };
  lintTerraform = {
    modules = {
      module = {
        src = "/test/terraform/module";
        version = "1.0";
      };
    };
  };
  lintWithAjv = {
    "test" = {
      schema = "/test/lint-with-ajv/schema.json";
      targets =
        [ "/test/lint-with-ajv/data.json" "/test/lint-with-ajv/data.yaml" ];
    };
  };
  pipelines = {
    example = {
      gitlabPath = "/test/pipelines/.gitlab-ci.yaml";
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
  secretsForGpgFromEnv = { example = [ "PGP_PUBLIC" "PGP_PRIVATE" ]; };
  secretsForEnvFromSops = {
    example = {
      manifest = "/makes/tests/secretsForGpgFromEnv/secrets.yaml";
      vars = [ "secret" ];
    };
  };
  secretsForTerraformFromEnv = { example = { test = "VAR_NAME"; }; };
  testLicense = { enable = true; };
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
}
