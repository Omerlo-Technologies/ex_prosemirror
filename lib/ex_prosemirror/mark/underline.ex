defmodule ExProsemirror.Mark.Underline do
  @moduledoc ~S"""
  Create heading text style using `<span style="text-decoration: underline;"></span>` html style.

  ## inputs opts:

      marks: [:underline]

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
    import Phoenix.HTML.Tag, only: [content_tag: 3]

    def encode(_struct, opts) do
      content_tag(:span, opts[:inner_content], style: "text-decoration: underline;")
    end
  end
end
