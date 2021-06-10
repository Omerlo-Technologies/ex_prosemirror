import {Plugin} from 'prosemirror-state';
import {Decoration, DecorationSet}  from 'prosemirror-view';

export const placeholderPlugin = new Plugin({
  state: {
    init() { return DecorationSet.empty; },
    apply(tr, set) {
      // Adjust decoration positions to changes made by the transaction
      set = set.map(tr.mapping, tr.doc);
      // See if the transaction adds or removes any placeholders
      let action = tr.getMeta(this);
      if (action && action.add) {
        let widget = document.createElement('placeholder');
        let deco = Decoration.widget(action.add.pos, widget, {id: action.add.id});
        set = set.add(tr.doc, [deco]);
      } else if (action && action.remove) {
        set = set.remove(
          set.find(
            null,
            null,
            spec => spec.id == action.remove.id
          )
        );
      }

      return set;
    }
  },
  props: {
    decorations(state) { return this.getState(state); }
  }
});


export function insertPlaceholder(exEditorView, {nodeType}) {
  // A fresh object to act as the ID for this upload
  let id = {};

  // Replace the selection with a placeholder
  let tr = exEditorView.editorView.state.tr;
  if (!tr.selection.empty) {
    tr.deleteSelection();
  }

  exEditorView.editorNode.addEventListener(
    'replacePlaceholder',
    function(e){ replacePlaceholder(exEditorView, e); }
  );

  tr.setMeta(placeholderPlugin, {add: {id, pos: tr.selection.from}});
  exEditorView.editorView.dispatch(tr);


  const msg = {detail: {nodeType: nodeType, id, tr}};
  exEditorView.editorNode.dispatchEvent(new CustomEvent('insertPlaceholder', msg));
}

export function replacePlaceholder(exEditorView, {detail: detail}) {
  const pos = findPlaceholder(exEditorView.editorView.state, detail.id);
  // If the content around the placeholder has been deleted, drop
  // the image
  if (pos == null) return;
  // Otherwise, insert it at the placeholder's position, and remove
  // the placeholder

  dispatchReplace({
    node: detail.callback(exEditorView.editorView.state.schema.nodes),
    id: detail.id,
    pos,
    exEditorView
  });
}

function dispatchReplace({exEditorView, id, pos, node}) {
  // TODO manage error
  exEditorView.editorView.dispatch(exEditorView.editorView.state.tr
    .replaceWith(pos, pos, node)
    .setMeta(placeholderPlugin, {remove: {id}}));
}

function findPlaceholder(state, id) {
  let decos = placeholderPlugin.getState(state);
  let found = decos.find(null, null, spec => spec.id == id);
  return found.length ? found[0].from : null;
}
