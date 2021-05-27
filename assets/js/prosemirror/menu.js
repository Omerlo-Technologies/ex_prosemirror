import {toggleMark, setBlockType, wrapIn} from 'prosemirror-commands';
import { Plugin } from 'prosemirror-state';
import MenuView from './MenuView';

function menuPlugin(items) {
  return new Plugin({
    view(editorView) {
      let menuView = new MenuView(items, editorView)
      editorView.dom.parentNode.insertBefore(menuView.dom, editorView.dom)
      return menuView
    }
  })
}

// Helper function to create menu icons
function icon(text, name) {
  let span = document.createElement("span");
  span.className = "menuicon " + name;
  span.title = name;
  span.textContent = text;
  return span;
}

export default ({ schema }) => {
  return menuPlugin([
    {command: toggleMark(schema.marks.strong), dom: icon("B", "strong")},
    {command: toggleMark(schema.marks.em), dom: icon("i", "em")},
    {command: setBlockType(schema.nodes.p), dom: icon('p', 'paragraph')},
    {command: setBlockType(schema.nodes.h1), dom: icon("h1", "h1")},
    {command: setBlockType(schema.nodes.h2), dom: icon("h2", "h2")},
    {command: setBlockType(schema.nodes.h3), dom: icon("h3", "h3")},
    {command: setBlockType(schema.nodes.h4), dom: icon("h4", "h4")},
    {command: setBlockType(schema.nodes.h5), dom: icon("h5", "h5")},
    {command: setBlockType(schema.nodes.h6), dom: icon("h6", "h6")},

    {command: wrapIn(schema.nodes.blockquote), dom: icon(">", "blockquote")}
  ])
};
