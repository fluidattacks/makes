module.exports = {
  parserOpts: {
    headerPattern: /^(\w*)\((\w*)\):\s(#\d+)\s(.*)$/,
    headerCorrespondence: [ 'type', 'scope', 'ticket', 'subject' ],
  },
};
