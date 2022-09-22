// SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
//
// SPDX-License-Identifier: MIT

module.exports = {
  parserOpts: {
    headerPattern: /^(\w*)\((\w*)\):\s(#[0-9]\d*)(.\d+)?\s(.*)$/,
    headerCorrespondence: ["type", "scope", "ticket", "part", "subject"],
  },
};
