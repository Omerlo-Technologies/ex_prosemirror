import { Schema } from 'prosemirror-model';
import { generateSchemaMarks } from './marks';
import blocks from './blocks';

export default (options) => (
  new Schema({
    nodes: blocks(options.blocks),
    marks: generateSchemaMarks(options.marks),
  })
);
