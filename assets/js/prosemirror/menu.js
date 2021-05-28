import { Dropdown, menuBar, icons, blockTypeItem } from 'prosemirror-menu';
import { markItem } from './marks';

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

function generateMarks(schema) {
  if(schema.marks) {
    const keys = Object.keys(schema.marks);

    return keys.map((mark) => {
      return markItem(schema.marks[mark], {
        title: mark,
        icon: icons[mark]
      });
    });
  }

  return [];
}


export default({ schema  }) => {
  const items = [
    generateMarks(schema),
    ...generateTextStyleMenu(schema)
  ];

  return menuBar({content: items});
};
