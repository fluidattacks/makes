# shellcheck shell=bash

function main {
  local args=(
    -refresh=true
  )
  local src=__argSrc__
  source __argResources__/template local resources

  pushd "${src}" \
    && info Initializing "${src}" \
    && terraform init \
    && info Refreshing state "${src}" \
    && terraform refresh \
    && for resource in "${resources[@]}"; do
      info Tainting "${src}" @ "${resource}" \
        && terraform taint -allow-missing "${resource}" \
        || return 1
    done \
    && if test -n '__argReDeploy__'; then
      info Applying "${src}" \
        && if running_in_ci_cd_provider; then
          args+=(-auto-approve)
        fi \
        && terraform apply "${args[@]}"
    fi
}

main "${@}"
