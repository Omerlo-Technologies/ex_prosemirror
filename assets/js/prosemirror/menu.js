import { MenuItem, blockTypeItem, Dropdown } from 'prosemirror-menu';
import { icons } from './icons';
import { toggleMark } from 'prosemirror-commands';
import { toggleColor } from './marks/helper';

function getTitle({name: name, spec: {title}}) {
  return (title || name);
}

export const generateHeadingItem = (schema) => {
  if(schema.nodes.heading) {
    return schema.nodes.heading.spec.config.values.map((heading) => {
      return blockTypeItem(schema.nodes.heading, {
        title: 'Header ' + heading,
        label: 'Header ' + heading,
        attrs: {level: heading}
      });
    });
  } else {
    return [];
  }
};

export const generateParagraphItem = (schema) => {
  if(schema.nodes.p) {
    return [blockTypeItem(schema.nodes.p, {
      title: 'paragraph',
      label: 'paragraph'
    })];
  }

  return [];
};

export const generateHTMLItem = (schema) => {
  if(schema.nodes.html) {
    return [
      new MenuItem({
        title: 'Insert HTML code',
        label: 'HTML',
        enable() { return true; },
        run(_state, _transaction, view) {
          const exEditorNode = view.dom.parentNode.parentNode;
          exEditorNode.dispatchEvent(new CustomEvent('exProsemirrorInsertPlaceholder', {detail: {nodeType: 'html'}}));
        }
      })
    ];
  }

  return [];
};


export const generateMediaMenu = (schema) => {
  if (!schema.nodes.image) {
    return [];
  }

  return [
    new MenuItem({
      title: 'Insert image',
      label: 'Image',
      enable() { return true; },
      run(_state, _transaction, view) {
        const exEditorNode = view.dom.parentNode.parentNode;
        exEditorNode.dispatchEvent(new CustomEvent('exProsemirrorInsertPlaceholder', {detail: {nodeType: 'image'}}));
      }
    })
  ];
};

export const generateMarkItem = (type) => {
  return (schema) => {
    if (!schema.marks[type]) {
      return [];
    }

    const markElement = schema.marks[type];
    const icon = markElement.spec.icon || icons[type];
    return [markItem(schema.marks[type], { title: getTitle(markElement), icon })];
  };
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

export const generateColorsMenu = (schema) => {
  if (!schema.marks.color) {
    return [];
  }

  const items = generateColorItems(schema);

  return [new Dropdown(items, {label: 'Color'})];
};

export const generateColorItems = (schema) => {
  if (!schema.marks.color) {
    return [];
  }

  const results = [colorItem(schema.marks.color, {title: 'default'})];
  const values = schema.marks.color.spec.config.values;

  for (const [name, color] of Object.entries(values)) {
    results.push(colorItem(schema.marks.color, {title: name}, {color: color}));
  }

  return results;
};

export function colorItem(markType, options, attrs) {
  return cmdItem(toggleColor(markType, attrs), {enable: true, ...options});
}


export const menuHelper = { generateParagraphItem, generateHeadingItem, generateHTMLItem, generateMediaMenu };
