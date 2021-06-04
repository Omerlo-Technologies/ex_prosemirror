defmodule ExProsemirror.Block.Paragraph do
  @moduledoc ~S"""
  Create heading text style using `<p></p>` html style.

  ## inputs opts:

      blocks: [:p]

  """

  use Ecto.Schema
  use ExProsemirror

  import Ecto.Changeset

  @doc false
  embedded_schema do
    embedded_prosemirror_content([text: ExProsemirror.Block.Text], array: true)
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_prosemirror_content()
  end
end
