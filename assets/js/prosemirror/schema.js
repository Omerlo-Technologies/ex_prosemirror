import { Schema } from 'prosemirror-model';
import marks from './marks';
import text from './text';
import paragraph from './paragraph';

export default (options) => (
  new Schema({
    nodes: {
      text,
      paragraph,
      doc: {
        content: 'block+',
      },
    },
    marks: marks(options.marks),
  })
);
