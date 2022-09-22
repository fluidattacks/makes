# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{makeScript, ...}:
makeScript {
  entrypoint = "echo Hello from Makes!";
  name = "c";
}
