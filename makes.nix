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
      makesGitlab = {
        src = config.outputs."container-image";
        registry = "registry.gitlab.com";
        tag = "fluidattacks/product/makes:foss";
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
