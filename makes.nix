{ config
, ...
}:
{
  deployContainerImage = {
    enable = true;
    images = {
      makesGitHub = {
        registry = "ghcr.io";
        src = config.outputs."/container-image";
        tag = "fluidattacks/makes:main";
      };
      makesGitHubMonthly = {
        registry = "ghcr.io";
        src = config.outputs."/container-image";
        tag = "fluidattacks/makes:${config.requiredMakesVersion}";
      };
      makesGitLab = {
        registry = "registry.gitlab.com";
        src = config.outputs."/container-image";
        tag = "fluidattacks/product/makes:main";
      };
      makesGitLabMonthly = {
        registry = "registry.gitlab.com";
        src = config.outputs."/container-image";
        tag = "fluidattacks/product/makes:${config.requiredMakesVersion}";
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
  lintNix = {
    enable = true;
    targets = [ "/" ];
  };
  lintPython = {
    enable = true;
    dirsOfModules = {
      makes = {
        python = "3.8";
        src = "/src";
      };
    };
    modules = {
      cli = {
        python = "3.8";
        src = "/src/cli";
      };
    };
  };
  requiredMakesVersion = "21.08";
}
