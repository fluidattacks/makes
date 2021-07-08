module.exports = {
  parserOpts: {
    headerPattern: /^(\w*)\((\w*)\):\s(#[1-9]\d*)\s(.*)$/,
    headerCorrespondence: [ 'type', 'scope', 'ticket', 'subject' ],
  },
};
