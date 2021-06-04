import { Schema } from 'prosemirror-model';
import { generateSchemaMarks } from './marks';
import blocks from './blocks';

/**
 * @param {{customBlocks: Object[], customMarks: Object[], blocksSelection: JSON, marksSelection: JSON, inline: Boolean}} options
 */
export default (options) =>
  new Schema({
    nodes: blocks(options.blocksSelection, options.customBlocks),
    marks: generateSchemaMarks(options.marksSelection, options.customMarks)
  });
