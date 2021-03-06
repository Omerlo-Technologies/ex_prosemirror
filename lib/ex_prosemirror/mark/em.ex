defmodule ExProsemirror.Mark.Em do
  @moduledoc ~S"""
  Italic mark.
  """

  use ExProsemirror.Schema
  use ExProsemirror.Encoder.Json, type: :em

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
      content_tag(:em, opts[:inner_content])
    end
  end
end
