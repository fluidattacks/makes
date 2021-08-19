# shellcheck shell=bash

function main {
  export POETRY_VIRTUALENVS_IN_PROJECT=1

  HOME="$(mktemp -d)" \
    && copy "${envPyprojectToml}" pyproject.toml \
    && poetry env use "$(command -v python)" \
    && poetry lock \
    && yj -tj \
      < poetry.lock > poetry.lock.json \
    && jq -er '.package[]|"\(.name)==\(.version)"' \
      < poetry.lock.json > closure.lst \
    && jq -er '.metadata.files[][]|.file' \
      < poetry.lock.json > files.lst \
    && python "${envCheckCompleteness}" closure.lst "${envDeps}" "${envSubDeps}" \
    && mapfile -t files < files.lst \
    && mkdir downloads \
    && for file in "${files[@]}"; do
      url="$(get_url "${file}")" \
        && echo "GET: ${url}" \
        && curl -L "${url}" -o "downloads/${file}" -s \
        || critical Unable to download "${file}"
    done \
    && pypi-mirror create \
      --copy \
      --download-dir downloads \
      --mirror-dir "${out}/mirror" \
    && copy "${envDeps}" "${out}/deps.lst" \
    && copy "${envSubDeps}" "${out}/sub-deps.lst"
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
