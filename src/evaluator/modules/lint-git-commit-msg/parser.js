// SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
//
// SPDX-License-Identifier: MIT

module.exports = {
  parserOpts: {
    headerPattern: /^(\w*)\((\w*)\):\s(#\d+)\s(.*)$/,
    headerCorrespondence: ["type", "scope", "ticket", "subject"],
  },
};
