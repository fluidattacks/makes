{ makeTemplate, toDerivationName, ... }:
{ accessKeyId, defaultRegion, name, secretAccessKey, sessionToken, }:
makeTemplate {
  replace = {
    __argName__ = toDerivationName name;
    __argAccessKeyId__ = accessKeyId;
    __argDefaultRegion__ = defaultRegion;
    __argSecretAcessKey__ = secretAccessKey;
    __argSessionToken__ = sessionToken;
  };
  name = "make-secret-for-aws-from-env-for-${name}";
  template = ./template.sh;
}
