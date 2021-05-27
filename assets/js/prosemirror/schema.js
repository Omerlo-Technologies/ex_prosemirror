import { Schema } from 'prosemirror-model';
import marks from './marks';
import blocks from './blocks';

export default (options) => (
  new Schema({
    nodes: blocks(options.blocks),
    marks: marks(options.marks),
  })
);
