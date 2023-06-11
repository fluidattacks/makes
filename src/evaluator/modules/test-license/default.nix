{testLicense, ...}: {
  config,
  lib,
  ...
}: {
  options = {
    testLicense = {};
  };
  config = {
    outputs = {
      "/testLicense" = testLicense;
    };
  };
}
