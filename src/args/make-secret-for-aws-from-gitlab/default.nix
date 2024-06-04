{ __nixpkgs__, makeTemplate, toDerivationName, ... }:
{ duration, name, retries, roleArn, }:
makeTemplate {
  replace = {
    __argDuration__ = duration;
    __argName__ = toDerivationName name;
    __argRetries__ = retries;
    __argRoleArn__ = roleArn;
  };
  name = "make-secret-for-aws-from-gitlab-for-${name}";
  searchPaths.bin = [ __nixpkgs__.awscli __nixpkgs__.jq ];
  template = ./template.sh;
}
