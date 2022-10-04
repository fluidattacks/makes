# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{calculateCvss3, ...}:
calculateCvss3
(builtins.concatStringsSep "" [
  "CVSS:3.0/S:C/C:H/I:H/A:N/AV:P/AC:H/PR:H/UI:R/E:H/RL:O/RC:R/CR:H"
  "/IR:X/AR:X/MAC:H/MPR:X/MUI:X/MC:L/MA:X"
])
