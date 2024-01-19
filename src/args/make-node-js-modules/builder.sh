# shellcheck shell=bash

function main {
  : && mkdir -p "${out}" \
    && pushd "${out}" \
    && copy "${envPackageJson}" package.json \
    && copy "${envPackageLockJson}" package-lock.json \
    && node2nix \
      --development \
      --input package.json \
      --lock package-lock.json \
      --pkg-name "nodejs_${envNodeJsVersion}" \
      --include-peer-dependencies \
    && sed -i -e 's/dontNpmInstall ? false/dontNpmInstall ? true/g' node-env.nix # https://github.com/svanderburg/node2nix/issues/134#issuecomment-475809875
}

main "${@}"
