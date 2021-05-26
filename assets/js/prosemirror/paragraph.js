export default {
  group: 'block',
  content: 'inline*',
  toDOM() {
    return ['p', 0];
  },
  parseDOM: [{ tag: 'p' }],
};
