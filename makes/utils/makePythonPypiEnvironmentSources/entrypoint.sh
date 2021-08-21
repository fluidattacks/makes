# shellcheck shell=bash

function main {
  local python_version="${1}"
  local deps_yaml="${2}"
  local sources_yaml="${3:-sources.yaml}"
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
    && case "${python_version}" in
      3.7) python=__argPy37__ ;;
      3.8) python=__argPy38__ ;;
      3.9) python=__argPy39__ ;;
      *) critical Python version not supported: "${python_version}" ;;
    esac \
    && info Generating manifest: \
    && cd "$(mktemp -d)" \
    && jq -enr \
      --argjson deps "$(yj -yj < "${deps_yaml}")" \
      --arg python_version "${python_version}.*" \
      "${pyproject_toml}" \
    | yj -jt | tee pyproject.toml \
    && poetry env use "${python}/bin/python" \
    && poetry lock -vv \
    && yj -tj \
      < poetry.lock > poetry.lock.json \
    && jq -er '.package[] | "https://pypi.org/pypi/\(.name)/\(.version)/json"' \
      < poetry.lock.json > endpoints.lst \
    && jq -er \
      --arg python_version "${python_version}" \
      '{
        closure: [ .package[] | {key: .name, value: .version} ] | from_entries,
        links: [],
        python: $python_version
      }' \
      < poetry.lock.json > sources.json \
    && mapfile -t endpoints < endpoints.lst \
    && for endpoint in "${endpoints[@]}"; do
      curl -L "${endpoint}" | jq -er .urls[] > data.json \
        && jq -er .filename < data.json > files.lst \
        && jq -er .url < data.json > urls.lst \
        && mapfile -t files < files.lst \
        && mapfile -t urls < urls.lst \
        && for ((index = 0; index < "${#files[@]}"; index++)); do
          file="${files[${index}]}" \
            && url="${urls[${index}]}" \
            && sha256="$(nix-prefetch-url --name "${file}" --type sha256 "${url}")" \
            && jq -ers \
              --arg file "${file}" \
              --arg sha256 "${sha256}" \
              --arg url "${url}" \
              '.[0] | .links += [{
                name: $file,
                sha256: $sha256,
                url: $url
              }]' \
              sources.json \
              > sources2.json \
            && mv sources2.json sources.json \
            || critical Unable to download "${file}"
        done
    done \
    && yj -jy < sources.json > "${sources_yaml}" \
    && info Generated a sources file at "${sources_yaml}"
}

main "${@}"
