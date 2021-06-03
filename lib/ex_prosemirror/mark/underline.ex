defmodule ExProsemirror.Mark.Underline do
  @moduledoc ~S"""
  Create heading text style using `<span style="text-decoration: underline;"></span>` html style.

  ## inputs opts:

      marks: [:underline]

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
