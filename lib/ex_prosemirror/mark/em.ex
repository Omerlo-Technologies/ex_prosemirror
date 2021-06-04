defmodule ExProsemirror.Mark.Em do
  @moduledoc ~S"""
  Create heading text style using `<i></i>` html style.

  ## inputs opts:

      marks: [:em]

  """

  use Ecto.Schema

  @doc false
  embedded_schema do
  end

  @doc false
  def changeset(struct_or_changeset, _attrs \\ %{}) do
    %Ecto.Changeset{valid?: true, data: struct_or_changeset}
  end
end
