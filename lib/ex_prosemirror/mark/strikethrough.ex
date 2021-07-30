defmodule ExProsemirror.Mark.Strikethrough do
  @moduledoc ~S"""
  Strikethrough mark.
  """

  use ExProsemirror.Schema
  use ExProsemirror.Encoder.Json, type: :strikethrough

  @type t :: %__MODULE__{}

  @doc false
  embedded_schema do
  end

  @doc false
  def changeset(struct_or_changeset, _attrs \\ %{}) do
    %Ecto.Changeset{valid?: true, data: struct_or_changeset}
  end

  defimpl ExProsemirror.Encoder.HTML do
    import Phoenix.HTML.Tag, only: [content_tag: 2]

    def encode(_struct, opts) do
      content_tag(:del, opts[:inner_content])
    end
  end
end
