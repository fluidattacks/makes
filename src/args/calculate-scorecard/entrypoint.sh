# shellcheck shell=bash

function main {
  local result
  local target=__argTarget__
  local format=__argFormat__
  local checks=__argChecks__
  local checks_len=("${checks}")

  info Calculating Scorecard \
    && temp="$(mktemp)" \
    && if test "${format}" == "json"; then
      if (("${#checks_len[@]}")); then
        scorecard --repo="${target}" --checks="${checks}" --format="${format}" --show-details > "${temp}" \
          && jq < "${temp}" \
          && result="$(jq '.score' < "${temp}")" \
          && info Aggregate score: "${result}"
      else
        scorecard --repo="${target}" --format="${format}" --show-details > "${temp}" \
          && result="$(jq '.score' < "${temp}")" \
          && info Aggregate score: "${result}"
      fi
    elif test "${format}" == "default"; then
      if (("${#checks_len[@]}")); then
        scorecard --repo="${target}" --checks="${checks}" --format="${format}" --show-details > "${temp}" \
          && cat "${temp}" \
          && result="$(grep -oP '(?<=Aggregate score: )[0-9]+([.][0-9]+)?' < "${temp}")" \
          && info Aggregate score: "${result}"
      else
        scorecard --repo="${target}" --format="${format}" --show-details > "${temp}" \
          && cat "${temp}" \
          && result="$(grep -oP '(?<=Aggregate score: )[0-9]+([.][0-9]+)?' < "${temp}")" \
          && info Aggregate score: "${result}"
      fi
    else
      critical invalid output format: "${format}" valid formats are: default, json
    fi \
    && if test "${result/.*/}" -lt 10; then
      error Scorecard check failed
    else
      return 0
    fi

}

main "${@}"
