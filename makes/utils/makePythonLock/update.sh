# shellcheck shell=bash

function main {
  local cmd=(just m . /utils/makePythonLock)

  : \
    && "${cmd[@]}" 3.8 \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/dependencies.yaml" \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/sources-38.yaml" \
    && "${cmd[@]}" 3.9 \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/dependencies.yaml" \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/sources-39.yaml" \
    && "${cmd[@]}" 3.10 \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/dependencies.yaml" \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/sources-310.yaml"

  : \
    && "${cmd[@]}" 3.8 \
      "${PWD}/src/args/calculate-cvss-3/dependencies.yaml" \
      "${PWD}/src/args/calculate-cvss-3/sources.yaml"

  : \
    && "${cmd[@]}" 3.8 \
      "${PWD}/src/args/lint-with-lizard/dependencies.yaml" \
      "${PWD}/src/args/lint-with-lizard/sources.yaml"

  : \
    && "${cmd[@]}" 3.8 \
      "${PWD}/src/args/lint-python/pypi-deps.yaml" \
      "${PWD}/src/args/lint-python/pypi-sources-3.8.yaml" \
    && "${cmd[@]}" 3.9 \
      "${PWD}/src/args/lint-python/pypi-deps.yaml" \
      "${PWD}/src/args/lint-python/pypi-sources-3.9.yaml" \
    && "${cmd[@]}" 3.10 \
      "${PWD}/src/args/lint-python/pypi-deps.yaml" \
      "${PWD}/src/args/lint-python/pypi-sources-3.10.yaml"

}

main "${@}"
