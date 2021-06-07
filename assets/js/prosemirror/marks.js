import { toggleMark } from 'prosemirror-commands';
import { marks as prosemirrorMarks } from 'prosemirror-schema-basic';
import { MenuItem } from 'prosemirror-menu';

const exProsemirrorMarks = {
  strong: prosemirrorMarks.strong,
  em: prosemirrorMarks.em,
  underline: {
    toDOM() {
      return ['span', { style: 'text-decoration: underline' }, 0];
    },
    parseDOM: [{ tag: 'span' }]
  }
};

/**
 * Returns a function that will generate Marks for Prosemirror schema.
 * @param {Object} marksSelection
 * @param {Object[]} customMarks
 */
export const generateSchemaMarks = ({ marksSelection, customMarks }) => {
  const marks = { ...exProsemirrorMarks, custom: customMarks || [] };

  const result = {};

  marksSelection.map((/** @type {Object} */ selection) => {
    if (marks[selection]) {
      result[selection] = marks[selection];
    } else if (marks.custom[selection]) {
      result['custom_mark_' + selection] = marks.custom[selection];
    }
  });

  return result;
};

/**
 * Generate a MenuItem for a schema's mark.
 *
 * @param {any} markType - Type of mark to generate
 * @param {Object} options
 */
export function markItem(markType, options) {
  let passedOptions = {
    active(state) {
      return markActive(state, markType);
    },
    enable: true
  };

  for (let prop in options) passedOptions[prop] = options[prop];
  return cmdItem(toggleMark(markType), passedOptions);
}

/**
 * Define if a mark is active or not.
 *
 * @param {EditorState} state
 * @param {any} type - Mark's type
 */
export function markActive(state, type) {
  let { from, $from, to, empty } = state.selection;
  if (empty) return type.isInSet(state.storedMarks || $from.marks());
  else return state.doc.rangeHasMark(from, to, type);
}

/**
 * Execute a ProsemirrorCommand
 *
 * @param {any} cmd - command to execute
 * @param {Object} options
 */
export function cmdItem(cmd, options) {
  let passedOptions = {
    label: options.title,
    run: cmd
  };
  for (let prop in options) passedOptions[prop] = options[prop];
  if ((!options.enable || options.enable === true) && !options.select)
    passedOptions[options.enable ? 'enable' : 'select'] = (state) => cmd(state);

  return new MenuItem(passedOptions);
}
