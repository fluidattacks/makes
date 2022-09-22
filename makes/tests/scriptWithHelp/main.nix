# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{makeScript, ...}:
makeScript {
  entrypoint = "echo A script with a help, call with --help or -h to see it!";
  name = "help";
  help = ./README.md;
}
