defmodule ExProsemirror.Node.Image do
  @moduledoc ~S"""
  Creates an image using `<img></img>`

  ## inputs opts:

      blocks: [:image]

  ## JS Interop

  When inserting an image, `ex_prosemirror` will send you a js event.
  With this event, you'll be able to open your own modal for image upload for example.

      document.querySelectorAll('.ex-prosemirror').forEach((el) => {
        el.addEventListener('insertPlaceholder', phoenixHook)
      });


  Then you will need to send back the content to `ex_prosemirror`. This is achieved by dispatching
  an event to the ExEditorView instance.

      function phoenixHook(event) {
        this.dispatchEvent(
          new CustomEvent(
            'replacePlaceholder',
            {detail: {id: event.detail.id, tr: event.detail.tr, data: {url: "img_src"}}}
          )
        );
      }

  """

  use Ecto.Schema

  import Ecto.Changeset

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
    @moduledoc false

    use Ecto.Schema

    import Ecto.Changeset

    embedded_schema do
      field :src, :string
      field :alt, :string
      field :title, :string
    end

    def changeset(struct_or_changeset, attrs \\ %{}) do
      struct_or_changeset
      |> cast(attrs, [:src, :alt, :title])
      |> validate_required([:src])
    end
  end
end
