# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  fetchGithub,
  makeScript,
  ...
}: {
  name,
  src,
}: let
  mailmapLinter = fetchGithub {
    owner = "kamadorueda";
    repo = "mailmap-linter";
    rev = "a51ac7e44515c754938a08f81038762e7d09a827";
    sha256 = "1da49y2cw9g9i4gbd2ykqghnpqpqdac18lafmn878qdlf1v8n9lh";
  };
in
  makeScript {
    entrypoint = ./entrypoint.sh;
    replace = {
      __argSrc__ = src;
    };
    name = "lint-git-mailmap-for-${name}";
    searchPaths = {
      bin = [
        (import mailmapLinter {
          nixpkgs = __nixpkgs__;
        })
      ];
    };
  }
