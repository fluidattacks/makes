# shellcheck shell=bash

function main {
  source __argAsciiArmorBlocks__/template local ascii_armor_blocks

  info Making secret for GPG from environment variables for __argName__: \
    && export GNUPGHOME \
    && GNUPGHOME="$(mktemp -d)" \
    && info - GNUPGHOME="${GNUPGHOME}" \
    && for ascii_armor_block in "${ascii_armor_blocks[@]}"; do
      require_env_var "${ascii_armor_block}" \
        && info - "${ascii_armor_block}" \
        && echo "${!ascii_armor_block}" | gpg --import \
        || return 1
    done
}

main "${@}"
