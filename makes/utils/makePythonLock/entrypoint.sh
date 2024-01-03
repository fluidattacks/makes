# shellcheck shell=bash

function main {
  declare -A depWithLinks
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
  local implementations39=(any cp39 py2.py3 py3 source)
  local implementations310=(any cp310 py2.py3 py3 source)
  local implementations311=(any cp311 py2.py3 py3 source)
  local implementations312=(any cp312 py2.py3 py3 source)

  true \
    && case "${python_version}" in
      3.9) python=__argPy39__ && implementations=("${implementations39[@]}") ;;
      3.10) python=__argPy310__ && implementations=("${implementations310[@]}") ;;
      3.11) python=__argPy311__ && implementations=("${implementations311[@]}") ;;
      3.12) python=__argPy312__ && implementations=("${implementations312[@]}") ;;
      *) critical Python version not supported: "${python_version}" ;;
    esac \
    && info Generating manifest: \
    && cd "$(mktemp -d)" \
    && jq -enrS \
      --argjson deps "$(yj -yj < "${deps_yaml}")" \
      --arg python_version "${python_version}.*" \
      "${pyproject_toml}" \
    | yj -jt | tee pyproject.toml \
    && poetry env use "${python}/bin/python" \
    && poetry lock -vv \
    && yj -tj \
      < poetry.lock > poetry.lock.json \
    && jq -erS '.package[] | "https://pypi.org/pypi/\(.name)/\(.version)/json"' \
      < poetry.lock.json > endpoints.lst \
    && jq -erS \
      --arg python_version "${python_version}" \
      '{
        closure: [ .package[] | {key: .name, value: .version} ] | from_entries,
        links: [],
        python: $python_version
      }' \
      < poetry.lock.json > sources.json \
    && mapfile -t endpoints < endpoints.lst \
    && for endpoint in "${endpoints[@]}"; do
      curl -L "${endpoint}" -s | jq -erS .urls[] > data.json \
        && jq -erS .filename < data.json > files.lst \
        && jq -erS .python_version < data.json > python_versions.lst \
        && jq -erS .url < data.json > urls.lst \
        && mapfile -t files < files.lst \
        && mapfile -t python_versions < python_versions.lst \
        && mapfile -t urls < urls.lst \
        && for ((index = 0; index < "${#files[@]}"; index++)); do
          file="${files[${index}]}" \
            && case "${file}" in
              *.egg) continue ;;
              *.exe) continue ;;
              *-win32.whl) continue ;;
              *-win_amd64.whl) continue ;;
              *-win_arm64.whl) continue ;;
              *) ;;
            esac \
            && if ! in_array "${python_versions[${index}]}" "${implementations[@]}"; then
              case "${file}" in
                *-abi3-*.whl) ;;
                *) continue ;;
              esac
            fi \
            && url="${urls[${index}]}" \
            && sha256="$(nix-prefetch-url --name "${file}" --type sha256 "${url}")" \
            && jq -ersS \
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
            && IFS='/' read -ra ADDR <<< "$endpoint" \
            && depWithLinks["${ADDR[-3]}"]="" \
            || critical Unable to download "${file}"
        done
    done \
    && jq -erS \
      --argjson depsWithLinks "$(echo "${!depWithLinks[@]}" | jq -Rc \
        'split(" ") | map({(.): .}) | add')" \
      '.closure |= with_entries(select(.key as $k | $depsWithLinks | has($k)))' \
      sources.json > sources_filtered.json \
    && mv sources_filtered.json sources.json \
    && yj -jy < sources.json > "${sources_yaml}" \
    && info Generated a sources file at "${sources_yaml}"
}

function in_array {
  for elem in "${@:2}"; do
    if test "${1}" = "${elem}"; then return 0; fi
  done && return 1
}

main "${@}"
