defmodule ExProsemirror.Mark.Link do
  @moduledoc ~S"""
  Transform a text to a link.

  ## inputs opts:

      marks: [:link]

  ## JS part

  We do not provide any JS modal for this mark.

  You can easily create your own menu item like the following code.

      export const generateLinkMenuItem = (schema) => {
        if (!schema.marks.link) {
          return [];
        }

        return [new MenuItem({
          title: 'Add or remove link',
          icon: icons.link,
          activate(state) { return markActive(state, schema.marks.link); },
          enable(state) { return !state.selection.empty; },
          run(state, dispatch, view) {
            // What happen when user click on the menu item button.
            // You can open a modal, activate / disable the mark ...
            // Read more on https://prosemirror.net/

            if (markActive(state, schema.marks.link)) {
              toggleMark(schema.marks.link)(state, dispatch);
              return true;
            }

            const attrs = {
              title: "Create a link",
              href: "https://your-link-here.com"
            }

            toggleMark(schema.marks.link, attrs)(view.state, view.dispatch)
            view.focus()
          }
        })];
      }

  Then in the your menu, you can use this function to display the link button.
  """

  use ExProsemirror.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{attrs: %__MODULE__.Attrs{title: title, href: href}}
  @type title :: String.t()
  @type href :: String.t()

  embedded_schema do
    embeds_one :attrs, __MODULE__.Attrs
  end

  def changeset(struct_or_changeset, attrs \\ %{}, _opts \\ []) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_embed(:attrs)
  end

  defimpl ExProsemirror.Encoder.HTML do
    import Phoenix.HTML.Tag, only: [content_tag: 3]

    def encode(struct, opts) do
      content_tag(:a, opts[:inner_content], href: struct.attrs.href)
    end
  end

  defmodule __MODULE__.Attrs do
    @derive {Jason.Encoder, except: [:__struct__]}
    @moduledoc false

    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field :title, :string
      field :href, :string
    end

    def changeset(struct_or_changeset, attrs \\ %{}) do
      struct_or_changeset
      |> cast(attrs, [:title, :href])
      |> validate_required([:href])
    end
  end
end
