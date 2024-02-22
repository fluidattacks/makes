# shellcheck shell=bash

function main {
  # If you do `import XXX` in your python code and the structure is like this:
  #   /path/to/XXX
  #   /path/to/XXX/__init__.py
  #   /path/to/XXX/business_code.py
  # then package_path is /path/to/XXX
  local package_path="${envSrc}"

  local current_python_dir
  local python_dirs
  local python_dir

  package_name="$(basename "${envSrc#*-}")" \
    && info Running mypy over: "${package_path}", package "${package_name}" \
    && if ! test -e "${package_path}/py.typed"; then
      error This is not a mypy package, py.typed missing
    fi \
    && tmpdir="$(mktemp -d)" \
    && copy "${package_path}" "${tmpdir}/${package_name}" \
    && pushd "${tmpdir}" \
    && dmypy start -- --config-file "${envSettingsMypy}" \
    && dmypy check "${package_name}" \
    && dmypy stop \
    && python_dirs=() \
    && current_python_dir="" \
    && find . -name '*.py' > tmp \
    && while IFS= read -r python_file; do
      python_dir="$(dirname "${python_file}")" \
        && if [ ! "${python_dir}" == "${current_python_dir}" ] && [ ! -f "${python_dir}/__init__.py" ]; then
          python_dirs+=("${python_dir}")
        fi \
        && current_python_dir="${python_dir}" \
        || return 1
    done < tmp \
    && dmypy start -- --config-file "${envSettingsMypy}" \
    && for dir in "${python_dirs[@]}"; do
      info Running mypy over: "${package_path}", folder "${dir}" \
        && dmypy check "${dir}" \
        || return 1
    done \
    && dmypy stop \
    && popd \
    && info Running prospector over: "${package_path}", package "${package_name}" \
    && if ! test -e "${package_path}/__init__.py"; then
      error This is not a python package, a package has __init__.py
    fi \
    && pushd "${tmpdir}" \
    && prospector --profile "${envSettingsProspector}" "${package_name}" \
    && popd \
    && touch "${out}" \
    || return 1
}

main "${@}"
