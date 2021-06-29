args:
{
  imports = [
    (import ./deploy-container-image args)
    (import ./format-bash args)
    (import ./hello-world args)
  ];
}
