defmodule ExProsemirror.Block.Paragraph do
  @moduledoc ~S"""
  A paragraph that contains multiple ExProsemirror.Block.Text.
  """

  use ExProsemirror.Schema
  use ExProsemirror
  use ExProsemirror.Encoder.Json, type: :paragraph

  import Ecto.Changeset

  alias ExProsemirror.Block.{HardBreak, Text}
  alias ExProsemirror.Encoder.HTML, as: HTMLEncoder

  @type t :: %__MODULE__{
          content: [Text.t()]
        }

  @doc false
  embedded_schema do
    embedded_prosemirror_content([text: Text, hard_break: HardBreak], array: true)
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}, opts \\ []) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_prosemirror_content(with: [text: {Text, :changeset, [opts]}])
  end

  def extract_simple_text(struct) do
    Enum.map(struct.content, &ExProsemirror.extract_simple_text/1)
  end

  defimpl HTMLEncoder do
    import Phoenix.HTML.Tag, only: [content_tag: 2]

    def encode(struct, _opts) do
      content_tag("p", HTMLEncoder.encode(struct.content))
    end
  end
end
