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

  defimpl ExProsemirror.Encoder.HTML do
    import Phoenix.HTML.Tag, only: [content_tag: 2]

    def encode(_struct, opts) do
      content_tag(:strong, opts[:inner_content])
    end
  end
end
