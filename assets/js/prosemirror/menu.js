import { MenuItem, blockTypeItem } from 'prosemirror-menu';
import { icons } from './icons';
import { toggleMark } from 'prosemirror-commands';

function getTitle({name: name, spec: {title}}) {
  return (title || name);
}

export const generateHeadingItem = (schema) => {
  if(schema.nodes.heading) {
    return schema.nodes.heading.spec.allowsLevel.map((heading) => {
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

export const generateMarks = (schema) => {
  if(schema.marks) {
    const keys = Object.keys(schema.marks);

    return keys.map((mark) => {
      const markElement = schema.marks[mark];
      const icon = markElement.spec.icon || icons[mark];
      return markItem(schema.marks[mark], {title: getTitle(markElement), icon});
    });
  }

  return [];
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

export const menuHelper = { generateParagraphItem, generateHeadingItem, generateHTMLItem, generateMediaMenu };
