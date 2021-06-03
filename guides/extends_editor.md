# Extends the editor

To create a new `mark` / `block`, you should first follow prosemirror spec.

You can find an example [here](https://prosemirror.net/examples/schema/).

## Create a custom span mark

In our example, we will have the following mark spec:

```elixir
import exProsemirror from 'ex_prosemirror';

const spanMark = {
  inline: true,
  group: "inline",
  parseDOM: [{tag: "span"}],
  toDOM() { return ['span', 0] }
}

exProsemirror.setCustomMarks({span: spanMark});

exProsemirror.initAll();
```

ExProsemirror allows you to add more options in the spec:

- `icon: Object`: icon to display in the menu
  - `width`: size of the svg
  - `path`: svg definition
- `title: String`: Title of the mark in the menu

Example

```elixir
import exProsemirror from 'ex_prosemirror';

const spanMark = {
  inline: true,
  group: "inline",
  parseDOM: [{tag: "span"}],
  title: 'My custom span',
  icon: {
    width: 896, height: 1024,
    path: "M608 192l-96 96 224 224-224 224 96 96 288-320-288-320zM288 192l-288 320 288 320 96-96-224-224 224-224-96-96z"
  },
  toDOM() { return ['span', 0] }
}

exProsemirror.setCustomMarks({span: spanMark});

exProsemirror.initAll();
```


## Create a custom blocks

In our example, we will have the following block spec:


```elixir
const spanBlock = {
  content: "inline*",
  group: "block",
  parseDOM: [{tag: "span"}],
  toDOM() { return ['span', 0] }
}
```

ExProsemirror allows you to add more options in the spec:

- `icon: Object`: icon to display in the menu
  - `width`: size of the svg
  - `path`: svg definition
- `title: String`: Title of the mark in the menu
- `label: String`: Label to display in the menu

> If an `icon` is defined, then the label will not be displayed.

Example

```elixir
import exProsemirror from 'ex_prosemirror';

const spanBlock = {
  content: "inline*",
  group: "block",
  parseDOM: [{tag: "span"}],
  title: 'my custom span block',
  label: 'custom span',
  icon: {
    width: 896, height: 1024,
    path: "M608 192l-96 96 224 224-224 224 96 96 288-320-288-320zM288 192l-288 320 288 320 96-96-224-224 224-224-96-96z"
  },
  toDOM() { return ['span', 0] }
}

exProsemirror.setCustomBlocks({span: spanBlock});

exProsemirror.initAll();
```
