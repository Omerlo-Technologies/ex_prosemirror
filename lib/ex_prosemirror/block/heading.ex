defmodule ExProsemirror.Block.Heading do
  @moduledoc ~S"""
  Create heading text style using `<hX></hX>` html style.

  > `X` is a number between 1 and 6.

  ## inputs opts:

      blocks: [{:heading, [:h1, :h2, :h3, :h4, :h5, :h6]}]

  """

  use ExProsemirror.Schema
  use ExProsemirror

  import Ecto.Changeset

  alias ExProsemirror.Block.Text

  @doc false
  embedded_schema do
    embeds_one :attrs, __MODULE__.Attrs
    embedded_prosemirror_content([text: Text], array: true)
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}, opts \\ []) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_embed(:attrs, required: true)
    |> cast_prosemirror_content(with: [text: {Text, :changeset, [opts]}])
  end

  defmodule __MODULE__.Attrs do
    @derive {Jason.Encoder, except: [:__struct__]}
    @moduledoc false

    use Ecto.Schema

    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field :level, :integer, default: 1
    end

    def changeset(struct_or_changeset, attrs \\ %{}) do
      struct_or_changeset
      |> cast(attrs, [:level])
      |> validate_required([:level])
      |> validate_inclusion(:level, 1..6)
    end
  end
end
