defmodule ExProsemirror.Block.Heading do
  @moduledoc ~S"""
  Heading contains multiple ExProsemirror.Block.Text and have attributes that
  define the level of the heading (between 1 and 6).
  """

  use ExProsemirror.Schema
  use ExProsemirror

  import Ecto.Changeset

  alias ExProsemirror.Block.Text

  @type t :: %__MODULE__{
          attrs: %__MODULE__.Attrs{level: attrs_level},
          content: Text.t()
        }

  @type attrs_level :: 1 | 2 | 3 | 4 | 5 | 6

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
