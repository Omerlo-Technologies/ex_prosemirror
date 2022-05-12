defmodule ExProsemirror.Block.HardBreak do
  @moduledoc ~S"""
  Hard Break tag
  """

  use ExProsemirror.Schema
  use ExProsemirror.Encoder.Json, type: :hard_break

  import Ecto.Changeset

  @doc false
  embedded_schema do
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}) do
    cast(struct_or_changeset, attrs, [])
  end

  defimpl ExProsemirror.Encoder.HTML do
    import Phoenix.HTML.Tag, only: [tag: 1]

    def encode(_struct, _opts) do
      tag(:br)
    end
  end

  def extract_simple_text(_struct), do: "\n"
end
