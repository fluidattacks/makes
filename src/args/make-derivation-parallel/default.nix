# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{toFileJson, ...}: {
  dependencies,
  name,
}:
toFileJson "make-derivation-parallel-for-${name}" dependencies
