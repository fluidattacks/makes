{ outputs, ... }: {
  deployTerraform = {
    modules = {
      module = {
        src = "/tests/terraform/module";
        version = "1.0";
      };
    };
  };
  envVarsForTerraform.example.VAR_NAME = "test";
  lintTerraform = {
    modules = {
      module = {
        src = "/tests/terraform/module";
        version = "1.0";
      };
    };
  };
  secretsForTerraformFromEnv = { example = { test = "VAR_NAME"; }; };
  testTerraform = {
    modules = {
      module = {
        setup = [
          outputs."/envVars/example"
          outputs."/secretsForTerraformFromEnv/example"
        ];
        src = "/tests/terraform/module";
        version = "1.0";
      };
    };
  };
}
