defmodule ExProsemirror.Node.Doc do
  @moduledoc ~S"""
  Root of prosemirror element. It handles element form input and casts it to Ecto schemas.

  A doc could contain one or many :

  - `ExProsemirror.Node.Paragraph`
  - `ExProsemirror.Node.Heading`
  """

  use Ecto.Schema
  use ExProsemirror

  import Ecto.Changeset

  @doc false
  embedded_schema do
    embedded_prosemirror_field(
      [
        paragraph: ExProsemirror.Node.Paragraph,
        heading: ExProsemirror.Node.Heading
      ],
      array: true
    )
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_prosemirror_fields()
  end
end
