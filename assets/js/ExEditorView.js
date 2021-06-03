import menuPlugin from './prosemirror/menu';
import { keymap } from 'prosemirror-keymap';
import { baseKeymap } from 'prosemirror-commands';
import { EditorState } from 'prosemirror-state';
import { EditorView } from 'prosemirror-view';
import { DOMParser } from 'prosemirror-model';
import schemaFunc from './prosemirror/schema';
import { placeholderPlugin, insertPlaceholder } from './prosemirror/plugins/placeholder';


export default class ExEditorView {
  /**
   * @param {HTMLElement} editorNode
   * @param {{customBlocks: Object[], customMarks: Object[]}} opts
   */
  constructor(editorNode, opts) {
    this.editorNode = editorNode;
    this.target = editorNode.dataset.target + '_plain';

    this.editorView = new EditorView(editorNode, {
      state: this.initializeEditorState(opts),
      dispatchTransaction: (transaction) => {this.dispatchTransaction(transaction);},
    });

    this.addListeners();
  }

  initializeEditorState({customBlocks, customMarks}) {
    const opts = {
      marksSelection: JSON.parse(this.editorNode.dataset.marks),
      blocksSelection: JSON.parse(this.editorNode.dataset.blocks),
      customBlocks,
      customMarks
    };

    const schema = schemaFunc(opts);

    return EditorState.create({
      doc: this.getDoc(schema),
      plugins: [menuPlugin({ schema }), keymap(baseKeymap), placeholderPlugin]
    });
  }

  getDoc(schema) {
    const initialValue = document.querySelector(this.target).value;

    if(initialValue.length > 0) {
      try {
        return schema.nodeFromJSON(JSON.parse(initialValue));
      } catch {
        return DOMParser.fromSchema(schema).parse('');
      }
    } else {
      return DOMParser.fromSchema(schema).parse('');
    }
  }

  addListeners() {
    const exEditorView = this;
    this.editorNode.addEventListener('exProsemirrorInsertPlaceholder', () => {
      insertPlaceholder(exEditorView);
    });
  }

  dispatchTransaction(transaction) {
    const newState = this.editorView.state.apply(transaction);
    const parsedState = newState.doc.toJSON();

    // TODO liveview supports

    document.querySelector(this.target).value = JSON.stringify(parsedState);
    this.editorView.updateState(newState);
  }
}
