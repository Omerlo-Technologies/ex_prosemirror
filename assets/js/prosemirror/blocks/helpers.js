/**
 * @param {Object} blocks
 * @param {Boolean} inline

 */
function inlineDoc(blocks, inline) {
  return inline ? { content: 'block?' } : blocks.doc;
}

/**
 * @param {Object} blocksSelection
 * @param {Object} blocks
 * @param {Boolean} inline
 */
export const generateExProsemirorBlocks = (blocksSelection, blocks, inline) => {
  const map = {
    text: blocks.text,
    doc: inlineDoc(blocks, inline)
  };

  blocksSelection.map((/** @type {Object} */ element) => {
    if (blocks[element.type]) {
      map[element.type] = { ...blocks[element.type], config: element };
    }
  });

  return map;
};
