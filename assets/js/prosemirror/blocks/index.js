import { nodes } from 'prosemirror-schema-basic';
import { generateExProsemirorBlocks } from './helpers';

const baseBlocks = {
  p: nodes.paragraph,
  text: nodes.text,
  heading: nodes.heading,
  doc: nodes.doc,
  image: {...nodes.image, inline: false, group: 'block'},
  html: {
    inline: true,
    attrs: {
      html: {default: null}
    },
    group: 'inline',
    draggable: false,
    parseDOM: [{tag: 'div[html]', getAttrs(dom) {
      return {
        html: dom.getAttribute('html'),
      };
    }}],
    toDOM(node) {
      let {html} = node.attrs;
      let myDom = document.createElement('div');
      myDom.innerHTML = html;
      return myDom;
    }
  }
};

/**
 * @param {Object} blocksSelection
 * @param {Object[]} customBlocks
 * @param {Boolean} inline
 */
export const generateSchemablocks = ({ blocksSelection, customBlocks, inline }) => (
  generateExProsemirorBlocks(blocksSelection, baseBlocks, customBlocks, inline)
);
