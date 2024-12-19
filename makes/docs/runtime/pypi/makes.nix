{ makePythonEnvironment, ... }: {
  jobs."/docs/runtime/pypi" = makePythonEnvironment {
    pythonProjectDir = ./.;
    pythonVersion = "3.11";
    overrides = self: super: {
      mkdocs-material = super.mkdocs-material.overridePythonAttrs
        (old: { patchPhase = "echo Skip patchPhase"; });
    };
  };
}
