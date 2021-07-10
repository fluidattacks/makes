{ outputs
, requiredMakesVersion
, ...
}:
{
  deployContainerImage = {
    enable = true;
    images = {
      makesGitHub = {
        registry = "ghcr.io";
        src = outputs."/container-image";
        tag = "fluidattacks/makes:main";
      };
      makesGitHubMonthly = {
        registry = "ghcr.io";
        src = outputs."/container-image";
        tag = "fluidattacks/makes:${requiredMakesVersion}";
      };
      makesGitLab = {
        registry = "registry.gitlab.com";
        src = outputs."/container-image";
        tag = "fluidattacks/product/makes:main";
      };
      makesGitLabMonthly = {
        registry = "registry.gitlab.com";
        src = outputs."/container-image";
        tag = "fluidattacks/product/makes:${requiredMakesVersion}";
      };
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
  formatPython = {
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
  lintMarkdown = {
    enable = true;
    targets = [ "/" ];
  };
  lintNix = {
    enable = true;
    targets = [ "/" ];
  };
  lintPython = {
    enable = true;
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
  requiredMakesVersion = "21.08";
}
