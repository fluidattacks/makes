# shellcheck shell=bash

function main {
  source "${envGemsSpec}/template" local gems_spec

  cd "${envGems}" \
    && gem install \
      --install-dir "${out}" \
      --local \
      --no-document \
      "${gems_spec[@]}" \
    && patch_shebangs "${out}/bin"
}

main "${@}"
