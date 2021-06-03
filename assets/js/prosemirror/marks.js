import { toggleMark } from 'prosemirror-commands';
import { marks as prosemirrorMarks } from 'prosemirror-schema-basic';
import { MenuItem } from 'prosemirror-menu';

const marks = {
  strong: prosemirrorMarks.strong,
  em: prosemirrorMarks.em,
  underline: {
    toDOM() { return ['span', {style: 'text-decoration: underline'}, 0]; },
    parseDOM: [{tag: 'span' }]
  },
};

/**
 * Returns a function that will generate Marks for Prosemirror schema.
 */
export const generateSchemaMarks = (options) => {
  let jsonOptions = JSON.parse(options);

  const result = {};

  jsonOptions.map((mark) => {
    result[mark] = marks[mark];
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
    active(state) { return markActive(state, markType); },
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
  let {from, $from, to, empty} = state.selection;
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
    passedOptions[options.enable ? 'enable' : 'select'] = state => cmd(state);

  return new MenuItem(passedOptions);
}
