const proseInstances = document.getElementsByClassName("ex-prosemirror")

class ExEditorView {
  constructor(editorNode, schema, pluginFunc, {EditorView, EditorState, DOMParser, Node}) {
    this.target = editorNode.dataset.target;

    const initialValue = document.querySelector(this.target).value

    let doc;

    if(initialValue.length > 0) {
      let json = JSON.parse(initialValue);
      try {
        doc = schema.nodeFromJSON(JSON.parse(initialValue));
      } catch {
        doc = DOMParser.fromSchema(schema).parse('')
      }
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

export class ExProsemirror {
  constructor(opts) {
    this.opts = opts
  }

  initAll({schemaFunc, pluginFunc}) {
    this.validate({schemaFunc, pluginFunc});

    Array.from(proseInstances).forEach(el => {
      el.innerHTML = '';
      const configured_schema = schemaFunc(el.dataset)
      new ExEditorView(el, configured_schema, pluginFunc, this.opts)
    });
  }

  init(target, {schemaFunc, pluginFunc}) {
    target.innerHTML = '';
    this.validate({schemaFunc, pluginFunc});
    const configured_schema = schemaFunc(target.dataset)
    return new ExEditorView(target, configured_schema, pluginFunc, this.opts)
  }

  validate({schemaFunc, pluginFunc}) {
    if(!schemaFunc) {
      throw 'ExProsmirror - schemaFunc is required when initializing a new instance.';
    }

    if(!pluginFunc) {
      throw 'ExProsmirror - pluginFunc is required when initializing a new instance.';
    }
  }
}

/* dispatchTransaction(transaction) {
 *   const newState = window.view.state.apply(transaction);

 *   const parsedState = newState.doc.toJSON();

 *   document.querySelector('#editor-export').textContent = JSON.stringify(parsedState);
 *   this.updateState(newState);
 * }, */
