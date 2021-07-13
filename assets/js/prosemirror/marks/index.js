import { marks as prosemirrorMarks } from 'prosemirror-schema-basic';
import { generateMarkItem, generateColorsMenu, generateFontFamilyMenu } from '../menu';
import { generateExProsemirrorMarks } from './helper';

export const marks = {
  strong: { ...prosemirrorMarks.strong, generateMenuItem: generateMarkItem('strong') },
  em: { ...prosemirrorMarks.em, generateMenuItem: generateMarkItem('em') },
  link: { ...prosemirrorMarks.link },
  strikethrough: {
    toDOM() {return ['del', 0];},
    parseDOM: [{ tag: 'del' }],
    generateMenuItem: generateMarkItem('strikethrough')
  },
  underline: {
    toDOM() {
      return ['span', { style: 'text-decoration: underline' }, 0];
    },
    parseDOM: [{ tag: 'span' }],
    generateMenuItem: generateMarkItem('underline')
  },
  color: {
    title: 'Color',
    label: 'Color',
    attrs: {color: {}},
    toDOM(node) {
      return ['span', {style: 'color: ' + node.attrs.color}, 0];
    },
    parseDOM: [{ tag: 'span', getAttrs(dom) {
      return {
        color: dom.style.color,
      };
    }}],
    generateMenuItem: generateColorsMenu
  },
  font_family: {
    title: 'Font',
    label: 'Font',
    attrs: {font_family: {}},
    toDOM(node) {
      return ['span', {style: 'font-family: ' + node.attrs.font_family}, 0];
    },
    parseDOM: [{ tag: 'span', getAttrs(dom) {
      return {
        font_family: dom.style['font-family'],
      };
    }}],
    generateMenuItem: generateFontFamilyMenu
  }
};

/**
 * Returns a function that will generate Marks for Prosemirror schema.
 */
export const generateSchemaMarks = ({ marksSelection, marks }) => (
  generateExProsemirrorMarks(marksSelection, marks)
);
