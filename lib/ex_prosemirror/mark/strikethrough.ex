defmodule ExProsemirror.Mark.Strikethrough do
  @moduledoc ~S"""
  Strikethrough mark.
  """

  use ExProsemirror.Schema

  @type t :: %__MODULE__{}

  @doc false
  embedded_schema do
  end

  @doc false
  def changeset(struct_or_changeset, _attrs \\ %{}) do
    %Ecto.Changeset{valid?: true, data: struct_or_changeset}
  end
end
