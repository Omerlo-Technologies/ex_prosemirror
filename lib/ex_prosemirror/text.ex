defmodule ExProsemirror.Text do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @behaviour ExProsemirror

  embedded_schema do
    field :text, :string
  end

  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [:text])
  end

  def extract_simple_text(%__MODULE__{text: text}), do: text
end
