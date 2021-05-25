const marks = {
  strong: {
    toDOM() {
      return ['strong', 0];
    },
    parseDOM: [{ tag: 'strong' }],
  },
  em: {
    toDOM() {
      return ['em', 0];
    },
    parseDOM: [{ tag: 'em' }],
  },
};

export default (options) => {
  const marksOptions = options.split(',');

  return marksOptions.reduce((accumulator, value) => {
    if (value in marks) {
      accumulator[value] = marks[value];
    }

    return accumulator;
  }, {});
};
