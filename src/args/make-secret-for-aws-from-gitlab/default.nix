{
  __nixpkgs__,
  makeTemplate,
  toDerivationName,
  ...
}: {
  duration,
  name,
  roleArn,
}:
makeTemplate {
  replace = {
    __argDuration__ = duration;
    __argName__ = toDerivationName name;
    __argRoleArn__ = roleArn;
  };
  name = "make-secret-for-aws-from-gitlab-for-${name}";
  searchPaths.bin = [
    __nixpkgs__.awscli
    __nixpkgs__.jq
  ];
  template = ./template.sh;
}
