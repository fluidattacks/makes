module.exports = {
  parserOpts: {
    headerPattern: /^(\w*)\((\w*)\):\s(#[0-9]\d*)(.\d+)?\s(.*)$/,
    headerCorrespondence: ["type", "scope", "ticket", "part", "subject"],
  },
};
