defmodule ExProsemirror.Block.Paragraph do
  @moduledoc ~S"""
  Create heading text style using `<p></p>` html style.

  ## inputs opts:

      blocks: [:p]

  """

  use ExProsemirror.Schema
  use ExProsemirror

  import Ecto.Changeset

  alias ExProsemirror.Block.Text

  @doc false
  embedded_schema do
    embedded_prosemirror_content([text: Text], array: true)
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}, opts \\ []) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_prosemirror_content()
    |> cast_prosemirror_content(with: [text: {Text, :changeset, [opts]}])
  end

  def extract_simple_text(struct) do
    Enum.map(struct.content, &ExProsemirror.extract_simple_text/1)
  end
end
