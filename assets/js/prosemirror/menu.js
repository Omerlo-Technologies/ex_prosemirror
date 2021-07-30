import { MenuItem, blockTypeItem, Dropdown } from 'prosemirror-menu';
import { icons } from './icons';
import { toggleMark } from 'prosemirror-commands';
import { toggleMultiMarks } from './marks/helper';

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
  if(schema.nodes.paragraph) {
    return [blockTypeItem(schema.nodes.paragraph, {
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
  const items = generateMultiMarkItem(schema, 'color');
  return [new Dropdown(items, {label: 'Color'})];
};

export const generateFontFamilyMenu = (schema) => {
  const items = generateMultiMarkItem(schema, 'font_family');
  return [new Dropdown(items, {label: 'Font'})];
};

export const generateMultiMarkItem = (schema, markType) => {
  if (!schema.marks[markType]) {
    return [];
  }

  const results = [multiMarkItem(schema.marks[markType], {title: 'default'})];
  const values = schema.marks[markType].spec.config.values;

  if (Array.isArray(values)) {
    for (const value of values) {
      const attrs = [];
      attrs[markType] = value;
      results.push(multiMarkItem(schema.marks[markType], { title: value }, attrs));
    }
  } else {
    for (const [name, value] of Object.entries(values)) {
      const attrs = [];
      attrs[markType] = value;
      results.push(multiMarkItem(schema.marks[markType], { title: name }, attrs));
    }
  }

  return results;
};

export function multiMarkItem(markType, options, attrs) {
  return cmdItem(toggleMultiMarks(markType, attrs), {enable: true, ...options});
}


export const menuHelper = { generateParagraphItem, generateHeadingItem, generateHTMLItem, generateMediaMenu };
