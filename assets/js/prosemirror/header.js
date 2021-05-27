export default (level) => ({
  group: 'block',
  content: 'inline*',
  toDOM() {
    return [`h${level}`, 0];
  },
  parseDOM: [{ tag: `h${level}` }],
});
