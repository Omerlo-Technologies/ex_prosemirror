defmodule ExProsemirror do
  @moduledoc ~S"""
  ExProsemirror is a helper for the [ProseMirror](https://prosemirror.net/) rich-text
  editor inside of [Phoenix.HTML.Form](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html).

  **The current version is in alpha and we don't guarantee it works as expected.**


  ## EEx examples

      <%= form_for @changeset, "#", fn f -> %>
        <%= prosemirror_input f, :title, type: :title %>
        <%= prosemirror_input f, :body, blocks: [h1: false] %>
      <% end %>

  Assuming we have the following in our config:

  ```elixir
  config :ex_prosemirror,
    default: [
      blocks: [:p, :h1, :h2],
      marks: [:strong]
    ],
    types: [
      title: [
        marks: [:em],
        blocks: [:h1]
      ]
    ]
  ```

  We will get the following results:

  * Input of type `:title` will be instantiated with block `h1` and will have the `em` mark
  * Input of type `:body` will be instantiated with blocks `p` and `h2` and will have the `strong` mark

  When providing the `type` option, we are telling ExProsemirror to fetch the blocks and marks specified in our config.

  The following will go to our config, and grab the blocks/marks specified in the `body` type.

  ```elixir
  <%= prosemirror_input f, :title, type: :body ... %>
  ```

  > Currently we don't allow custom blocks / marks. You have to use marks and blocks
  > defined by the lib ex_prosemirror.

  The following code sample will create a form with 2 fields: `title` and `body`. The
  title will expose italic marks only. The body will expose italic and strong
  marks plus paragraph and header 1.


      <form for="article">
        <input type="hidden" name="article[title_plain]">
        <div id="ProseMirrorTitleDiv"></div>

        <input type="hidden" name="article[body_plain]">
        <div id="ProseMirrorBodyDiv"></div>
      </form>


  ## Ecto examples

        use ExProsemirror.Schema

        import Ecto.Changeset
        import ExProsemirror.Changeset

        schema "article" do
          prosemirror_field :title
        end

        def changeset(struct_or_changeset, attrs \\ %{}) do
          struct_or_changeset
          |> cast_prosemirror(attrs, :title, required: true)
        end

  > To learn more, take a look at `ExProsemirror.Schema` and `ExProsemirror.Changeset`.

  ## Installation

  - First, you need to add the dependency according to the following code:

  ```elixir
  def deps do
  [
    {:ex_prosemirror, git: "https://github.com/Omerlo-Technologies/ex_prosemirror", tag: "0.1.2"},
  ]
  end
  ```

  - Then, you have to import `ExProsemirror.HTML.Form` in your views / liveviews
  > This could be done directly in your AppWeb.ex in `view/0` and/or `live_view/0`.
  > In recent phoenix versions, you could simply add the line in `view_helper/0`.

  ``` elixir
  defp view_helpers do
    quote do
      use Phoenix.HTML

      import Phoenix.View

      import ExProsemirror.HTML.Form # <--- this line

      import AppWeb.ErrorHelpers
      alias AppWeb.Router.Helpers, as: Routes
    end
  end
  ```

  - Add the `ex_prosemirror` dependency to your package.json:

  ```json
  {
    ...
    "dependencies": {
      ...
      "ex_prosemirror": "file:../deps/ex_prosemirror/assets"
    }
    ...
  }
  ```

  - Install prosemirror

  ```bash
  npm i --save \
    prosemirror-example-setup \
    prosemirror-menu \
    prosemirror-model \
    prosemirror-schema-basic \
    prosemirror-state \
    prosemirror-view
  ```

  - Finally add `ExProsemirrorHooks` to phoenix hooks

  ```elixir
  // your hooks.js file
  import { ExProsemirrorHooks } from 'ex_prosemirror/js/hooks';

  const Hooks = {}; // your hooks

  export default { ...ExProsemirrorHooks, ...Hooks };
  ```

  > Optional: If you want to use the default prosemirror css, you can import the `css/prosemirror.css` file.
  >
  > E.g `@import "~ex_prosemirror/css/prosemirror.css";`

  """

  @doc ~S"""
  Import ExProsemirror.EctoHelper and add the behaviour of ExProsemirror.

  ## Options

  - `safe_parser` defines if the protocole Pheonix.HTML.Safe should be defined by default. When `true`, it
  will use `ExProsemirror.extract_simple_text/1` (default: `true`)

  """
  defmacro __using__(opts) do
    quote do
      import ExProsemirror.SchemaHelper

      @behaviour ExProsemirror

      unquote(safe_parser(opts))
    end
  end

  def safe_parser(opts) do
    if Keyword.get(opts, :safe_parser, true) do
      quote do
        defimpl Phoenix.HTML.Safe, for: __MODULE__ do
          defdelegate to_iodata(data), to: ExProsemirror, as: :extract_simple_text
        end
      end
    end
  end

  @doc ~S"""
  Override the default `extract_simple_text/1` system for the module that implements the callback.

  ## Examples

        def extract_simple_text(%__MODULE__{text: text}), do: text
  """
  @callback extract_simple_text(struct :: struct()) :: String.t() | nil

  @optional_callbacks [extract_simple_text: 1]

  @doc ~S"""
  Extracts the text(s) value(s) without any text marks / blocks.

  ## Examples

      iex> ExProsemirror.extract_simple_text(%ExProsemirror.Block.Paragraph{content: [
      ...>   %ExProsemirror.Block.Text{text: "Hello"},
      ...>   %ExProsemirror.Block.Text{text: "World"}
      ...> ]})
      ["Hello", "World"]

      iex> ExProsemirror.extract_simple_text([
      ...>   %ExProsemirror.Block.Text{text: "Hello"},
      ...>   %ExProsemirror.Block.Text{text: "World"}
      ...> ])
      ["Hello", "World"]

      iex> ExProsemirror.extract_simple_text(%ExProsemirror.Block.Text{text: "Hello"})
      "Hello"

  """
  def extract_simple_text(list_of_structs) when is_list(list_of_structs) do
    Enum.map(list_of_structs, &extract_simple_text/1)
  end

  def extract_simple_text(struct) when is_struct(struct) do
    cond do
      function_exported?(struct.__struct__, :extract_simple_text, 1) ->
        apply(struct.__struct__, :extract_simple_text, [struct])

      %{content: content} = struct ->
        extract_simple_text(content)

      true ->
        nil
    end
  end

  def extract_simple_text(_), do: nil

  @doc ~S"""
  Setting debug to true will display the hidden form with json structure.
  By default, this field is input_hidden.

  ## Examples

    debug(true)
  """
  def debug(boolean), do: Application.put_env(:ex_prosemirror, :debug, boolean)

  def generate_context() do
    [
      marks: generate_context(:marks, ExProsemirror.Mark),
      nodes: generate_context(:nodes, ExProsemirror.Node),
      types: generate_context(:types, ExProsemirror.Type)
    ]
  end

  def generate_context(type, prefix) when is_atom(type) do
    :ex_prosemirror
    |> Application.get_env(type, [])
    |> generate_context(prefix)
  end

  def generate_context(marks, prefix) when is_list(marks) do
    Enum.map(marks, fn {name, opts} ->
      cond do
        opts[:module] ->
          {name, opts}

        opts[:autogenerate] == false ->
          raise "Autogenerate false required a module"

        true ->
          module = Module.concat(prefix, Macro.camelize("#{name}"))
          {name, Keyword.put(opts, :module, module)}
      end
    end)
  end

  def generate_all() do
    context = generate_context()
    ExProsemirror.Mark.generate(context)
    ExProsemirror.Node.generate(context)
    ExProsemirror.Type.generate(context)

    :ok
  end
end
