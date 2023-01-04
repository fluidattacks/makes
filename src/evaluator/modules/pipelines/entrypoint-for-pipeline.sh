# shellcheck shell=bash

function main {
  local job_runner
  source __argJobs__/template jobs

  info Running pipeline \
    && for job in "${!jobs[@]}"; do
      info Running job: "${job}" \
        && job_runner="${jobs[${job}]}" \
        && if test -e "${job_runner}/makes-action.sh"; then
          "${job_runner}/makes-action.sh" "${job_runner}" \
            || return 1
        fi
    done
}

main "${@}"
