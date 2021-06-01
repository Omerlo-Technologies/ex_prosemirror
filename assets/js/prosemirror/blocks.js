import { nodes } from 'prosemirror-schema-basic';

const blocks = {
  p: nodes.paragraph,
  text: nodes.text,
  heading: nodes.heading,
  doc: nodes.doc,
  image: nodes.image
};

function extractHeading({ heading }) {
  return {
    attrs: {level: {default: 1}},
    allowsLevel: heading,
    content: 'inline*',
    group: 'block',
    defining: true,
    parseDOM: heading.map((header) => ({tag: 'h' + header, attrs: {level: header}})),
    toDOM(node) { return ['h' + node.attrs.level, 0]; }
  };
}

export default (options) => {
  let jsonOptions = JSON.parse(options);

  const map = {
    text: blocks.text,
    doc: blocks.doc
  };

  jsonOptions.map((option) => {
    if (typeof(option) == 'object') {
      map['heading'] = extractHeading(option);
    } else {
      map[option] = blocks[option];
    }
  });

  return map;
};
