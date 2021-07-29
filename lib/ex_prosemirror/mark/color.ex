defmodule ExProsemirror.Mark.Color do
  @moduledoc ~S"""
  Color mark for text.

  ## Usage

      {:color, colors_list}

  > `colors_list` is a map where keys are the name of the color and the value
  is the value of the color (could be hex, rgb, or whatever you want).

  ## Examples

      {:color, %{red: "#ff1111", blue: "#1111ff"}}
  """

  use ExProsemirror.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{attrs: %__MODULE__.Attrs{color: color_value}}
  @type color_value :: String.t()

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

  defimpl ExProsemirror.Encoder.HTML do
    import Phoenix.HTML.Tag, only: [content_tag: 3]

    def encode(struct, opts) do
      content_tag(:span, opts[:inner_content], style: "color: #{struct.attrs.color};")
    end
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
