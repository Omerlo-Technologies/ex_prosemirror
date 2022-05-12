import { nodes } from 'prosemirror-schema-basic';
import { generateExProsemirorBlocks } from './helpers';

import { menuHelper } from '../menu';

const paragraph = {
  ...nodes.paragraph,
  generateMenuItem: menuHelper.generateParagraphItem
};

const heading = {
  ...nodes.heading,
  generateMenuItem: menuHelper.generateHeadingItem
};

const html = {
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
  },
  generateMenuItem: menuHelper.generateHTMLItem
};

const image = {
  ...nodes.image,
  inline: false,
  group: 'block',
  generateMenuItem: menuHelper.generateMediaMenu
};

export const blocks = {
  doc: nodes.doc,
  text: nodes.text,
  hard_break: nodes.hard_break,
  paragraph,
  heading,
  image,
  html
};

/**
 * @param {{blocksSelection: Object, blocks: Object[], inline: boolean}} opts
 */
export const generateSchemablocks = ({ blocksSelection, blocks, inline }) => (
  generateExProsemirorBlocks(blocksSelection, blocks, inline)
);
