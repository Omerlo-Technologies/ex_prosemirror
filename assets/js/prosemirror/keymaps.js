import { keymap } from 'prosemirror-keymap';
import { baseKeymap, chainCommands, exitCode } from 'prosemirror-commands';

function insertHardBreak(state, dispatch) {
  const br = state.schema.nodes.hard_break;

  dispatch(state.tr.replaceSelectionWith(br.create()).scrollIntoView());
}

const hardBreakKeymap = {
  'Shift-Enter': chainCommands(exitCode, insertHardBreak),
};

export { keymap, baseKeymap, hardBreakKeymap };
