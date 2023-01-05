# shellcheck shell=bash

function main {
  local cmd=(just m . /utils/makePythonLock)

  : \
    && "${cmd[@]}" 3.10 \
      "${PWD}/makes/cli/env/runtime/pypi/pypi-deps.yaml" \
      "${PWD}/makes/cli/env/runtime/pypi/pypi-sources.yaml"

  : \
    && "${cmd[@]}" 3.10 \
      "${PWD}/makes/cli/env/test/pypi-deps.yaml" \
      "${PWD}/makes/cli/env/test/pypi-sources.yaml"

  : \
    && "${cmd[@]}" 3.11 \
      "${PWD}/src/args/calculate-cvss-3/dependencies.yaml" \
      "${PWD}/src/args/calculate-cvss-3/sources.yaml"

  : \
    && "${cmd[@]}" 3.8 \
      "${PWD}/src/args/lint-python/pypi-deps.yaml" \
      "${PWD}/src/args/lint-python/pypi-sources-3.8.yaml" \
    && "${cmd[@]}" 3.9 \
      "${PWD}/src/args/lint-python/pypi-deps.yaml" \
      "${PWD}/src/args/lint-python/pypi-sources-3.9.yaml" \
    && "${cmd[@]}" 3.10 \
      "${PWD}/src/args/lint-python/pypi-deps.yaml" \
      "${PWD}/src/args/lint-python/pypi-sources-3.10.yaml" \
    && "${cmd[@]}" 3.11 \
      "${PWD}/src/args/lint-python/pypi-deps.yaml" \
      "${PWD}/src/args/lint-python/pypi-sources-3.11.yaml"

  : \
    && "${cmd[@]}" 3.11 \
      "${PWD}/src/args/lint-python-imports/pypi-deps.yaml" \
      "${PWD}/src/args/lint-python-imports/pypi-sources.yaml"

  : \
    && "${cmd[@]}" 3.11 \
      "${PWD}/src/args/lint-with-lizard/dependencies.yaml" \
      "${PWD}/src/args/lint-with-lizard/sources.yaml"

  : \
    && "${cmd[@]}" 3.8 \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/dependencies.yaml" \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/sources-38.yaml" \
    && "${cmd[@]}" 3.9 \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/dependencies.yaml" \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/sources-39.yaml" \
    && "${cmd[@]}" 3.10 \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/dependencies.yaml" \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/sources-310.yaml" \
    && "${cmd[@]}" 3.11 \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/dependencies.yaml" \
      "${PWD}/src/args/make-python-pypi-environment/sources/numpy-1.24.0/sources-311.yaml"

  : \
    && "${cmd[@]}" 3.8 \
      "${PWD}/src/args/test-python/pypi-deps.yaml" \
      "${PWD}/src/args/test-python/pypi-sources-3.8.yaml" \
    && "${cmd[@]}" 3.9 \
      "${PWD}/src/args/test-python/pypi-deps.yaml" \
      "${PWD}/src/args/test-python/pypi-sources-3.9.yaml" \
    && "${cmd[@]}" 3.10 \
      "${PWD}/src/args/test-python/pypi-deps.yaml" \
      "${PWD}/src/args/test-python/pypi-sources-3.10.yaml" \
    && "${cmd[@]}" 3.11 \
      "${PWD}/src/args/test-python/pypi-deps.yaml" \
      "${PWD}/src/args/test-python/pypi-sources-3.11.yaml"
}

main "${@}"
