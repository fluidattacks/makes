# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
name: list:
builtins.toFile name
(builtins.concatStringsSep "\n" (list ++ [""]))
