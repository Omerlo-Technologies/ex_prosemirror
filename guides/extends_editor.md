# Extends the editor

To create a new `mark` / `block`, you should first follow prosemirror spec.

You can find an example [here](https://prosemirror.net/examples/schema/).

> Everytime you update the config `ex_prosemirror.schema` you'll need to recompile
> the lib `ex_prosemirror`.

## Create a custom span mark

Here, we'll create a span that will act as a mark.


### JS part

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

exProsemirror.setCustomMarks({custom_span: spanMark});

exProsemirror.initAll();
```


### Elixir part

First, we'll need to create a module that manages our changeset.

```elixir
# Note the module name is not important
defmodule MyApp.MyCustomSpan do
  use Ecto.Schema

  @doc false
  embedded_schema do
  end

  @doc false
  def changeset(struct_or_changeset, _attrs \\ %{}) do
    %Ecto.Changeset{valid?: true, data: struct_or_changeset}
  end
end
```

Now that we have our module that manage the changeset, we have to configure `ex_prosemirror` to support it.

```elixir
config :ex_prosemirror,
  debug: true,
  schema: [
    "ExProsemirror.Block.Text": [
      marks: [
        custom_span: MyApp.MyCustomSpan,
      ]
    ]
  ],
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

### Elixir part

We'll use the same changeset that we defined previsouly.

The `ex_prosemirror` configuration should be like the following code.

```elixir
config :ex_prosemirror,
  debug: true,
  schema: [
    "ExProsemirror.Block.Text": [
      blocks: [
        custom_span: MyApp.Block.CustomSpan,
      ]
    ]
  ],
```
