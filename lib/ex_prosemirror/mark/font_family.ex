defmodule ExProsemirror.Mark.FontFamily do
  @moduledoc ~S"""
  Font mark for text.

  ## Usage

      {:font_family, fonts_list}

  > `fonts_list` is an array of allowed font.

  ## Usage

      {:font_family, ["verdana", "Courrier New"]}
  """

  use ExProsemirror.Schema
  use ExProsemirror.Encoder.Json, type: :font_family

  import Ecto.Changeset

  @type t :: %__MODULE__{attrs: %__MODULE__.Attrs{font_family: font_value}}
  @type font_value :: String.t()

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
      content_tag(:span, opts[:inner_content],
        style: ~s(font-family: "#{struct.attrs.font_family};")
      )
    end
  end

  defmodule __MODULE__.Attrs do
    @derive {Jason.Encoder, except: [:__struct__]}
    @moduledoc false

    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field :font_family, :string
    end

    def changeset(struct_or_changeset, attrs \\ %{}) do
      struct_or_changeset
      |> cast(attrs, [:font_family])
      |> validate_required([:font_family])
    end
  end
end
