# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  makeRubyVersion,
  makeRubyGemsInstall,
  makeSearchPaths,
  ...
}: {
  name,
  ruby,
  rubyGems,
  searchPathsBuild ? {},
  searchPathsRuntime ? {},
}: let
  installation = makeRubyGemsInstall {
    inherit name;
    inherit ruby;
    inherit rubyGems;
    searchPaths = searchPathsBuild;
  };
in
  makeSearchPaths {
    bin = [(makeRubyVersion ruby)];
    rubyBin = [installation];
    rubyGemPath = [installation];
    source = [(makeSearchPaths searchPathsRuntime)];
  }
