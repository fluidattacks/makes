# shellcheck shell=bash

function main {
  local python_version="${1}"
  local deps_json="${2}"
  local sources_json="${3:-sources.json}"
  local pyproject_toml='{
    "build-system": {
      "build-backend": "poetry.core.masonry.api"
    },
    "build-system": {
      "requires": [ "poetry-core>=1.0.0" ]
    },
    "tool": {
      "poetry": {
        "authors": [ ],
        "dependencies": ($deps * { python: $python_version }),
        "description": "",
        "name": "pyproject-toml-for-make-python-pypi-mirror",
        "version": "1"
      }
    }
  }'

  true \
    && deps_json="$(realpath "${deps_json}")" \
    && sources_json="$(realpath "${sources_json}")" \
    && case "${python_version}" in
      3.7) python=__argPy37__ ;;
      3.8) python=__argPy38__ ;;
      3.9) python=__argPy39__ ;;
      *) critical Python version not supported: "${python_version}" ;;
    esac \
    && info Generating manifest: \
    && cd "$(mktemp -d)" \
    && jq -enr \
      --argjson deps "$(cat "${deps_json}")" \
      --arg python_version "${python_version}.*" \
      "${pyproject_toml}" \
    | yj -jt | tee pyproject.toml \
    && poetry env use "${python}/bin/python" \
    && poetry lock \
    && yj -tj \
      < poetry.lock > poetry.lock.json \
    && jq -er '.metadata.files[][]|.file' \
      < poetry.lock.json > files.lst \
    && jq -er \
      --arg python_version "${python_version}" \
      '{
        closure: [ .package[] | {key: .name, value: .version} ] | from_entries,
        links: [],
        python: $python_version
      }' \
      < poetry.lock.json > sources.json \
    && mapfile -t files < files.lst \
    && for file in "${files[@]}"; do
      url="$(get_url "${file}")" \
        && sha256="$(nix-prefetch-url --name "${file}" --type sha256 "${url}")" \
        && sources="$(cat sources.json)" \
        && jq -enr \
          --arg file "${file}" \
          --arg sha256 "${sha256}" \
          --argjson sources "${sources}" \
          --arg url "${url}" \
          '{
            closure: $sources.closure,
            links: ($sources.links + [{
              name: $file,
              sha256: $sha256,
              url: $url
            }]),
            python: $sources.python
          }' \
          > sources.json \
        || critical Unable to download "${file}"
    done \
    && cp sources.json "${sources_json}" \
    && info Generated a sources file at "${sources_json}"
}

function get_url {
  local file="${1}"

  remainder="${file}" \
    && case "${file}" in
      *.tar.gz)
        remainder="${remainder%*.tar.gz}" \
          && version="${remainder##*-}" \
          && project_name="${remainder%-*}" \
          && python_version='source'
        ;;
      *.whl)
        project_name="${file%%-*}" \
          && remainder="${remainder:1}" \
          && remainder="${remainder:${#project_name}}" \
          && version="${remainder%%-*}" \
          && remainder="${remainder:1}" \
          && remainder="${remainder:${#version}}" \
          && python_version="${remainder%%-*}"
        ;;
      *) critical Unable to parse "${file}" ;;
    esac \
    && project_l="${project_name:0:1}" \
    && echo "https://pypi.org/packages/${python_version}/${project_l}/${project_name}/${file}"
}

main "${@}"
