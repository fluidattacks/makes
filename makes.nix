{ config
, ...
}:
{
  inputs = {
    nixpkgs = import <nixpkgs> { };
  };

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
        tag = "fluidattacks/makes:$(date +%y.%m)";
      };
      makesGitLab = {
        src = config.outputs."container-image";
        registry = "registry.gitlab.com";
        tag = "fluidattacks/product/makes:main";
      };
      makesGitLabMonthly = {
        src = config.outputs."container-image";
        registry = "registry.gitlab.com";
        tag = "fluidattacks/product/makes:$(date +%y.%m)";
      };
    };
  };
  formatBash = {
    enable = true;
    targets = [
      "/"
    ];
  };
  helloWorld = {
    enable = true;
    name = "Jane Doe";
  };
}
