defmodule ExProsemirror.Block.Text do
  @moduledoc ~S"""
  Prosemirror inline element. It's contained by most of ExProsemirror modifiers like
  `ExProsemirror.Block.Paragraph` or `ExProsemirror.Block.Heading`.

  When creating an ExProsemirror block you can use this module thanks to

      embedded_prosemirror_content([text: ExProsemirror.Block.Text], array: true)

  > `embedded_prosemirror_content` is defined in `ExProsemirror.SchemaHelper` and is imported with
  > using `ExProsemirror.Schema`.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import ExProsemirror.SchemaHelper

  @behaviour ExProsemirror

  @doc false
  embedded_schema do
    field :text, :string

    embedded_prosemirror_marks(
      em: ExProsemirror.Mark.Em,
      strong: ExProsemirror.Mark.Strong,
      underline: ExProsemirror.Mark.Underline
    )
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [:text])
    |> cast_prosemirror_marks()
  end

  @doc ~S"""
  Returns the text of an `ExProsemirror.Block.Text`.

  ## E.g

      ExProsemirror.Block.Text.extract_simple_text(%ExProsemirror.Block.Text{text: "Hello elixir's friends"})
      "Hello elixir's friends"
  """
  def extract_simple_text(%__MODULE__{text: text}), do: text
end
