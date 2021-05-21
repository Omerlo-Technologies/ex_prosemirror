defmodule ExProsemirror.Schema do
  @moduledoc false

  use Ecto.Schema
  use ExProsemirror

  import Ecto.Changeset

  embedded_schema do
    embedded_prosemirror_field(doc: ExProsemirror.Doc)
  end

  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [])
    |> cast_prosemirror_fields()
  end
end
