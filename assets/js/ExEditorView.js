import { EditorState } from 'prosemirror-state';
import { EditorView } from 'prosemirror-view';
import { DOMParser } from 'prosemirror-model';
import schemaFunc from './prosemirror/schema';
import { insertPlaceholder } from './prosemirror/plugins/placeholder';

export default class ExEditorView {
  /**
   * @param {HTMLElement} editorNode
   * @param {{blocks: Object[], marks: Object[]}, plugins: Object[]} opts
   */
  constructor(editorNode, opts) {
    this.editorNode = editorNode;
    this.target = editorNode.dataset.target + '_plain';

    this.editorView = new EditorView(editorNode, {
      state: this.initializeEditorState(opts),
      dispatchTransaction: (transaction) => {
        this.dispatchTransaction(transaction);
      }
    });

    this.addListeners();
  }

  initializeEditorState({ blocks, marks, plugins }) {
    const opts = {
      marksSelection: JSON.parse(this.editorNode.dataset.marks),
      blocksSelection: JSON.parse(this.editorNode.dataset.blocks),
      inline: JSON.parse(this.editorNode.dataset.inline),
      blocks,
      marks
    };

    const schema = schemaFunc(opts);

    plugins = plugins(schema).map((plugin, index) => {
      if (plugin.key.startsWith('plugin$')) {
        plugin.key = 'plugin$' + index;
      }
      return plugin;
    });

    return EditorState.create({
      doc: this.getDoc(schema),
      plugins: plugins
    });
  }

  getDoc(schema) {
    const initialValue = document.querySelector(this.target).value;

    if (initialValue.length > 0) {
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
    this.editorNode.addEventListener('exProsemirrorInsertPlaceholder', ({detail}) => {
      insertPlaceholder(exEditorView, {nodeType: detail.nodeType});
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
