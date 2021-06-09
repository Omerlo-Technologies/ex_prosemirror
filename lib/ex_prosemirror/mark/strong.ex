defmodule ExProsemirror.Mark.Strong do
  @moduledoc ~S"""
  Create heading text style using `<b></b>` html style.

  ## inputs opts:

      marks: [:strong]

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
