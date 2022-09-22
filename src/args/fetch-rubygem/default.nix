# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  fakeSha256,
  fetchUrl,
  ...
}: {
  name,
  sha256 ? fakeSha256,
  version,
}:
fetchUrl {
  url = "https://rubygems.org/downloads/${name}-${version}.gem";
  inherit sha256;
}
