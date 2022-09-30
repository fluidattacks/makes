# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function configure_nix {
  : \
    && mkdir -p "${out}/home/makes/.config/nix" \
    && mkdir -p "${out}/home/root/.config/nix" \
    && mkdir -p "${out}/etc/nix" \
    && mkdir -p "${out}/nix/store/.links" \
    && mkdir -p "${out}/nix/var/nix" \
    && echo 'build-users-group =' | tee \
      "${out}/home/makes/.config/nix/nix.conf" \
      "${out}/home/root/.config/nix/nix.conf" \
      "${out}/etc/nix/nix.conf"
}

function configure_nss {
  mkdir -p "${out}/etc" \
    && echo 'hosts: dns files' > "${out}/etc/nsswitch.conf"
}

function configure_ssh {
  # Configure SSH, the host key verification is weakened on purpose because
  # many jobs that run on this image connect to thousands of unknown providers

  mkdir -p "${out}/home/makes/.ssh" \
    && echo 'Host *' > "${out}/home/makes/.ssh/config" \
    && echo '  StrictHostKeyChecking no' >> "${out}/home/makes/.ssh/config" \
    && chmod 400 "${out}/home/makes/.ssh/config"
}

function configure_tmp {
  mkdir -p "${out}/tmp" \
    && mkdir -p "${out}/var/tmp"
}

function configure_users {
  mkdir -p "${out}/etc" \
    && mkdir -p "${out}/home/makes" \
    && mkdir -p "${out}/etc/pam.d" \
    && touch "${out}/etc/login.defs" \
    && echo "${envEtcGroup}" > "${out}/etc/group" \
    && echo "${envEtcGshadow}" > "${out}/etc/gshadow" \
    && echo "${envEtcPamdOther}" > "${out}/etc/pam.d/other" \
    && echo "${envEtcPasswd}" > "${out}/etc/passwd" \
    && echo "${envEtcShadow}" > "${out}/etc/shadow"
}

function configure_usr_bin_env {
  mkdir -p "${out}/usr/bin" \
    && ln -s "$(command -v env)" "${out}/usr/bin/env"
}

function main {
  configure_nix \
    && configure_nss \
    && configure_ssh \
    && configure_tmp \
    && configure_users \
    && configure_usr_bin_env
}

main "${@}"
