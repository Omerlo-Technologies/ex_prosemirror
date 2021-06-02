import { nodes } from 'prosemirror-schema-basic';

const blocks = {
  p: nodes.paragraph,
  text: nodes.text,
  heading: nodes.heading,
  doc: nodes.doc,
  image: nodes.image
};

const allowedHeading = {h1: 1, h2: 2, h3: 3, h4: 4, h5: 5, h6: 6};

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

  const heading = [];

  jsonOptions.map((option) => {
    if (allowedHeading[option]) {
      heading.push(allowedHeading[option]);
    } else
      map[option] = blocks[option];
  });

  map['heading'] = extractHeading({ heading });

  return map;
};
