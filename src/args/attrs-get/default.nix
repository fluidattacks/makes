# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
attrset: name: default:
if builtins.hasAttr name attrset
then builtins.getAttr name attrset
else default
