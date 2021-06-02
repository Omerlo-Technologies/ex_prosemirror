defmodule ExProsemirror.Node.Text do
  @moduledoc ~S"""
  Prosemirror inline element. It's contained by most of ExProsemirror modifiers like
  `ExProsemirror.Node.Paragraph` or `ExProsemirror.Node.Heading`.

  When creating an ExProsemirror node you can use this module thanks to

      embedded_prosemirror_field([text: ExProsemirror.Node.Text], array: true)

  > `embedded_prosemirror_field` is defined in `ExProsemirror.SchemaHelper` and is imported with
  > using `ExProsemirror.Schema`.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @behaviour ExProsemirror

  @doc false
  embedded_schema do
    field :text, :string
  end

  @doc false
  def changeset(struct_or_changeset, attrs \\ %{}) do
    struct_or_changeset
    |> cast(attrs, [:text])
  end

  @doc ~S"""
  Returns the text of an `ExProsemirror.Node.Text`.

  ## E.g

      ExProsemirror.Node.Text.extract_simple_text(%ExProsemirror.Node.Text{text: "Hello elixir's friends"})
      "Hello elixir's friends"
  """
  def extract_simple_text(%__MODULE__{text: text}), do: text
end
