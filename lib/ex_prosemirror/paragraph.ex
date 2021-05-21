defmodule ExProsemirror.Paragraph do
  @moduledoc false

  use Ecto.Schema
  use ExProsemirror

  import Ecto.Changeset

  embedded_schema do
    embedded_prosemirror_field([text: ExProsemirror.Text], array: true)
  end

  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_prosemirror_fields()
  end
end
