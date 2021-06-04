defmodule ExProsemirror.Block.Doc do
  @moduledoc ~S"""
  Root of prosemirror element. It handles element form input and casts it to Ecto schemas.

  A doc could contain one or many :

  - `ExProsemirror.Block.Paragraph`
  - `ExProsemirror.Block.Heading`
  """

  use Ecto.Schema
  use ExProsemirror

  import Ecto.Changeset

  @doc false
  embedded_schema do
    embedded_prosemirror_content(
      [
        p: ExProsemirror.Block.Paragraph,
        heading: ExProsemirror.Block.Heading,
        image: ExProsemirror.Block.Image
      ],
      array: true
    )
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_prosemirror_content()
  end
end
