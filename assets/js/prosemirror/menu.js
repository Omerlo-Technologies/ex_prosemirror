import { Dropdown, MenuItem, menuBar, blockTypeItem } from 'prosemirror-menu';
import { icons } from './icons';
import { markItem } from './marks';

function getTitle({name: name, spec: {title}}) {
  return (title || name).replace(/^custom_mark_/, '');
}

function getLabel({name: name, spec: {label}}) {
  return (label || name).replace(/^custom_mark_/, '');
}

function generateHeadingItem(schema) {
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
}

function generateParagraphItem(schema) {
  if(schema.nodes.p) {
    return [blockTypeItem(schema.nodes.p, {
      title: 'paragraph',
      label: 'paragraph'
    })];
  }

  return [];
}

function generateTextStyleMenu(schema) {
  const textStyle = [
    ...generateParagraphItem(schema),
    ...generateHeadingItem(schema)
  ];

  if (textStyle.length > 1) {
    const textStyleMenu = new Dropdown(textStyle, {label: 'Text Style'});
    return [[textStyleMenu]];
  }

  return [];
}

function generateMediaMenu(schema) {
  if (!schema.nodes.image) {
    return [];
  }

  return [[
    new MenuItem({
      title: 'Insert image',
      label: 'Image',
      enable() { return true; },
      run(_state, _transaction, view) {
        const exEditorNode = view.dom.parentNode.parentNode;
        exEditorNode.dispatchEvent(new CustomEvent('exProsemirrorInsertPlaceholder', {detail: {nodeType: 'image'}}));
      }
    })
  ]];
}

function generateMarks(schema) {
  if(schema.marks) {
    const keys = Object.keys(schema.marks);

    return keys.map((mark) => {
      const markElement = schema.marks[mark];
      const icon = markElement.spec.icon || icons[mark];
      return markItem(schema.marks[mark], {title: getTitle(markElement), icon});
    });
  }

  return [];
}

function generateCustomBlocks(schema) {
  const keys = Object.keys(schema.nodes).filter(key => key.indexOf('custom') > -1);

  return keys.map(key => {
    const block = schema.nodes[key];
    return blockTypeItem(block, {
      title: getTitle(block),
      label: getLabel(block),
      icon: block.spec.icon
    });
  });
}

export default({ schema  }) => {
  const items = [
    generateMarks(schema),
    ...generateTextStyleMenu(schema),
    ...generateMediaMenu(schema),
    generateCustomBlocks(schema)
  ];

  return menuBar({content: items});
};
