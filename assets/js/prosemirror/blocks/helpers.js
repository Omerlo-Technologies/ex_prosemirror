const allowedHeading = { h1: 1, h2: 2, h3: 3, h4: 4, h5: 5, h6: 6 };

export function extractHeading({ heading }) {
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

/**
 * @param {Object} blocks
 * @param {Boolean} inline

 */
function inlineDoc(blocks, inline) {
  return inline ? { content: 'block?' } : blocks.doc;
}

/**
 * @param {Object} blocksSelection
 * @param {Object} baseBlocks
 * @param {Object[]} customBlocks
 * @param {Boolean} inline
 */
export const generateExProsemirorBlocks = (blocksSelection, baseBlocks, customBlocks, inline) => {
  const blocks = {...baseBlocks, custom: customBlocks || []};

  const map = {
    text: blocks.text,
    doc: inlineDoc(blocks, inline)
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
