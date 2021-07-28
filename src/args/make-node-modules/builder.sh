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
  copy "${envPackageJsonFile}" package.json \
    && HOME=. npm install --force --ignore-scripts=false --verbose \
    && info Freezing \
    && get_deps_from_lock package-lock.json > requirements \
    && if test "$(cat requirements)" = "$(cat "${envRequirementsFile}")"; then
      info Integrity check passed
    else
      info Integrity check failed \
        && info You need to specify all dependencies: \
        && git --no-pager diff --no-index \
          "${envRequirementsFile}" requirements \
        && error Stopping due to failed integrity check
    fi \
    && mkdir "${out}" \
    && mv node_modules/* "${out}"
}

main "${@}"
