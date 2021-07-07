# shellcheck shell=bash

function get_deps_from_lock {
  jq -r '.dependencies | to_entries[] | .key + "@" + .value.version' < "${1}" \
    | sort
}

# Use npm install with --force flag for packages that would fail to install
# due to OS/arch issues (fsevents), but removing them from the dependencies
# would install them anyway due to being an inherited dependency
# from another package, thus creating an Integrity Check error
function main {
  mkdir "${out}" \
    && copy "${envPackageJsonFile}" "${out}/package.json" \
    && pushd "${out}" \
    && HOME=. npm install --force --ignore-scripts=false --verbose \
    && popd \
    && info Freezing \
    && get_deps_from_lock "${out}/package-lock.json" > "${out}/requirements" \
    && if test "$(cat "${out}/requirements")" = "$(cat "${envRequirementsFile}")"; then
      info Integrity check passed
    else
      error Integrity check failed \
        && info You need to specify all dependencies: \
        && git diff --no-index "${envRequirementsFile}" "${out}/requirements" \
        && return 1
    fi \
    || return 1
}

main "${@}"
