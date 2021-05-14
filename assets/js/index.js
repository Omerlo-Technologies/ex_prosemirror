
const proseInstances = document.getElementsByClassName("ex-prosemirror")

class ExEditorView {
  constructor(editorNode, schema, pluginFunc, {EditorView, EditorState, DOMParser, Node}) {
    const marks = editorNode.dataset.marks
    this.target = editorNode.dataset.target;

    const initialValue = document.querySelector(this.target).value

    let doc;

    if(initialValue.length > 0) {
      doc = Node.fromJSON(schema, JSON.parse(initialValue))
    } else {
      doc = DOMParser.fromSchema(schema).parse('')
    }

    const state = EditorState.create({
      doc: doc,
      plugins: pluginFunc({schema: schema})
    });

    this.editorView = new EditorView(editorNode, {
      state: state,
      dispatchTransaction: (transaction) => {this.dispatchTransaction(transaction)}
    })
  }

  dispatchTransaction(transaction) {
    const newState = this.editorView.state.apply(transaction);
    const parsedState = newState.doc.toJSON();

    // TODO liveview supports

    document.querySelector(this.target).value = JSON.stringify(parsedState);
    this.editorView.updateState(newState);
  }
}

export default class ExProsemirror {
  constructor(opts) {
    this.opts = opts
  }

  init({schemaFunc, pluginFunc}) {
    if(!schemaFunc) {
      throw 'ExPromirror - schemaFunc is required in when initialized a new instance.';
    }

    if(!pluginFunc) {
      throw 'ExPromirror - pluginFunc is required in when initialized a new instance.';
    }

    Array.from(proseInstances).forEach(el => {
      const configured_schema = schemaFunc(el.dataset)

      new ExEditorView(el, configured_schema, pluginFunc, this.opts)
    });
  }
}



/* dispatchTransaction(transaction) {
 *   const newState = window.view.state.apply(transaction);

 *   const parsedState = newState.doc.toJSON();

 *   document.querySelector('#editor-export').textContent = JSON.stringify(parsedState);
 *   this.updateState(newState);
 * }, */
