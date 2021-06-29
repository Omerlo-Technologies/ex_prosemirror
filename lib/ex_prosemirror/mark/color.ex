defmodule ExProsemirror.Mark.Color do
  @moduledoc ~S"""
  Color for text.
  """

  use ExProsemirror.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @doc false
  embedded_schema do
    embeds_one :attrs, __MODULE__.Attrs
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}, _opts \\ []) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_embed(:attrs)
  end

  defmodule __MODULE__.Attrs do
    @derive {Jason.Encoder, except: [:__struct__]}
    @moduledoc false

    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field :color, :string
    end

    def changeset(struct_or_changeset, attrs \\ %{}) do
      struct_or_changeset
      |> cast(attrs, [:color])
      |> validate_required([:color])
    end
  end
end
