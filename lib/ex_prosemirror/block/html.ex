defmodule ExProsemirror.Block.HTML do
  @moduledoc ~S"""
  HTML blocks only contain attrs that defines:

  * html: html content to embed

  ## JS Interop

  When inserting an HTML block, `ex_prosemirror` will send you a js event.
  With this event, you'll be able to open your own modal to gather the HTML input.

      document.querySelectorAll('.ex-prosemirror').forEach((el) => {
        el.addEventListener('insertPlaceholder', phoenixHook)
      });


  Then you will need to send back the content to `ex_prosemirror`. This is achieved by dispatching
  an event to the ExEditorView instance.

      function phoenixHook(event) {
        this.dispatchEvent(
          new CustomEvent(
            'replacePlaceholder',
            {detail: {id: event.detail.id, tr: event.detail.tr, data: {html: "<div style='color: red;'>Hello World</div>"}}}
          )
        );
      }

  """

  use ExProsemirror.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          attrs: %__MODULE__.Attrs{
            html: String.t()
          }
        }

  @doc false
  embedded_schema do
    embeds_one :attrs, __MODULE__.Attrs
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_embed(:attrs, required: true)
  end

  defmodule __MODULE__.Attrs do
    @derive {Jason.Encoder, except: [:__struct__]}
    @moduledoc false

    use Ecto.Schema

    import Ecto.Changeset

    embedded_schema do
      field :html, :string
    end

    @required_fileds ~w(html)a
    def changeset(struct_or_changeset, attrs \\ %{}) do
      struct_or_changeset
      |> cast(attrs, @required_fileds)
      |> validate_required(@required_fileds)
    end
  end
end
