# shellcheck shell=bash

function main {
  local paths=__envTargets__
  local doctocArgs=__envDoctocArgs__

  info Formatting Markdown code \
    && for path in "${paths[@]}"; do
      info Formatting "${path}" \
        && doctoc "${doctocArgs[@]}" "${path}" \
        && sed \
          '/<!-- START doctoc generated TOC/,/<!-- END doctoc generated TOC/s/^( *)/\1\1/' \
          -ri \
          "${path}" \
        || return 1
    done
}

main "${@}"
