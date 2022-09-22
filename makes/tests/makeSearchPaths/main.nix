# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{makeDerivation, ...}:
makeDerivation {
  builder = "touch $out";
  name = "test-make-search-paths";
  searchPaths.source = [
    [./template.sh "a" "b" "c"]
  ];
}
