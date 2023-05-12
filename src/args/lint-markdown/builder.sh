# shellcheck shell=bash

function main {
  source "${envTargets}/template" local targets

  info Linting Markdown code \
    && for target in "${targets[@]}"; do
      info Linting "${target}" \
        && mdl --ignore-front-matter --style "${envConfig}" --rulesets "${envRulesets}" "${target}" \
        || return 1
    done \
    && touch "${out}"
}

main "${@}"
