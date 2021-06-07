import { nodes } from 'prosemirror-schema-basic';

const prosemirrorBlocks = {
  p: nodes.paragraph,
  text: nodes.text,
  heading: nodes.heading,
  doc: nodes.doc,
  image: nodes.image
};

const allowedHeading = { h1: 1, h2: 2, h3: 3, h4: 4, h5: 5, h6: 6 };

function extractHeading({ heading }) {
  return {
    attrs: { level: { default: 1 } },
    allowsLevel: heading,
    content: 'inline*',
    group: 'block',
    defining: true,
    parseDOM: heading.map((header) => ({ tag: 'h' + header, attrs: { level: header } })),
    toDOM(node) {
      return ['h' + node.attrs.level, 0];
    }
  };
}

function inlineDoc(inline) {
  return inline == 'true' ? { content: 'block?' } : blocks.doc;
}

/**
 * @param {Object} blocksSelection
 * @param {Object[]} customBlocks
 */
export default (blocksSelection, customBlocks) => {
  const blocks = { ...prosemirrorBlocks, custom: customBlocks || [] };

  const map = {
    text: blocks.text,
    doc: inlineDoc(inline)
  };

  const heading = [];

  blocksSelection.map((/** @type {Object} */ blockSelection) => {
    if (allowedHeading[blockSelection]) {
      heading.push(allowedHeading[blockSelection]);
    } else if (blocks[blockSelection]) {
      map[blockSelection] = blocks[blockSelection];
    } else if (blocks.custom[blockSelection]) {
      map['custom_block_' + blockSelection] = blocks.custom[blockSelection];
    }
  });

  map['heading'] = extractHeading({ heading });

  return map;
};
