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
  lintNix = {
    enable = true;
    targets = [ "/" ];
  };
  requiredMakesVersion = "21.08";
}
