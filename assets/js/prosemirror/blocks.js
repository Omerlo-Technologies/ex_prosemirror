import paragraph from './paragraph';
import text from './text';
import header from './header';

const blocks = {
  p: paragraph,
  text: text,
  h1: header(1),
  h2: header(2),
  h3: header(3),
  h4: header(4),
  h5: header(5),
  h6: header(6),
  doc: {
    content: 'block+',
  },
};

export default (options) => {
  const blocksOptions = options.split(',');

  const blocksResult =  blocksOptions.reduce((accumulator, value) => {
    if (value in blocks) {
      accumulator[value] = blocks[value];
    }

    return accumulator;
  }, {});

  if (Object.keys(blocksResult).length === 0) {
    blocksResult['p'] = blocks['p'];
  }

  blocksResult['doc'] = blocks['doc'];
  blocksResult['text'] = blocks['text'];

  return blocksResult;
};
