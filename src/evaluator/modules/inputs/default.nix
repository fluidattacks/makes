# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{lib, ...}: {
  options = {
    inputs = lib.mkOption {
      default = {};
      type = lib.types.attrs;
    };
  };
}
