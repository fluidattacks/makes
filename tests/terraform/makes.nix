{ outputs, ... }: {
  deployTerraform.modules.module = {
    src = "/tests/terraform/module";
    version = "1.0";
  };
  lintTerraform.modules.module = {
    src = "/tests/terraform/module";
    version = "1.0";
  };
  testTerraform.modules.module = {
    src = "/tests/terraform/module";
    version = "1.0";
  };
}
