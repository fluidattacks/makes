{ config
, ...
}:
{
  deployContainerImage = {
    enable = true;
    images = {
      makesGitHub = {
        src = config.outputs."container-image";
        registry = "ghcr.io";
        tag = "fluidattacks/makes:main";
      };
      makesGitHubMonthly = {
        src = config.outputs."container-image";
        registry = "ghcr.io";
        tag = "fluidattacks/makes:${config.inputs.version}";
      };
      makesGitLab = {
        src = config.outputs."container-image";
        registry = "registry.gitlab.com";
        tag = "fluidattacks/product/makes:main";
      };
      makesGitLabMonthly = {
        src = config.outputs."container-image";
        registry = "registry.gitlab.com";
        tag = "fluidattacks/product/makes:${config.inputs.version}";
      };
    };
  };
  formatBash = {
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
  inputs = {
    version = "21.08-pre1";
  };
}
