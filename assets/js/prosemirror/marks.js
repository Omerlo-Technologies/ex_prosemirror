import { marks as prosemirrorMarks } from 'prosemirror-schema-basic';

export const marks = {
  strong: prosemirrorMarks.strong,
  em: prosemirrorMarks.em,
  strikethrough: {
    toDOM() {return ['del', 0];},
    parseDOM: [{ tag: 'del' }]
  },
  underline: {
    toDOM() {
      return ['span', { style: 'text-decoration: underline' }, 0];
    },
    parseDOM: [{ tag: 'span' }]
  }
};

/**
 * Returns a function that will generate Marks for Prosemirror schema.
 */
export const generateSchemaMarks = ({ marksSelection, marks }) => {
  const result = {};

  marksSelection.map((/** @type {Object} */ selection) => {
    if (marks[selection]) {
      result[selection] = marks[selection];
    }
  });

  return result;
};


